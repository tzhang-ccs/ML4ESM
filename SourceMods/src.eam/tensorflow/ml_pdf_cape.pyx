# cython: language_level=3

cdef public void python_init():
    import time
    time1 = time.time()

    from datetime import datetime
    import numpy as np
#    from keras.models import model_from_json
    import tensorflow as tf
    import sys
    import gc

    global means
    global stds
    global CAPE_model
    global BCU_model

    time2 = time.time()
#    print(f'Time in Python: import = {time2-time1:.2f}s')

    time1 = time.time()
    file_path = "//global/cfs/projectdirs/e3sm/zhangtao/E3SM/ML4E3SM/CAPE_PDF/"
    means = np.loadtxt(f'{file_path}/E3SM_ml_pdf_cape_mean.dat')
    stds  = np.loadtxt(f'{file_path}/E3SM_ml_pdf_cape_std.dat')

    CAPE_json = open(f'{file_path}/E3SM_ML_PDF_CAPE.json','r').read()
    BCU_json  = open(f'{file_path}/E3SM_ML_BCU.json', 'r').read()

    CAPE_model = tf.keras.models.load_model("/pscratch/sd/z/zhangtao/E3SMv2_1/F2010.ne30pg2_EC30to60E2r2_ML_Test_Framework/case_scripts/SourceMods/src.eam/tf")
    BCU_model = tf.keras.models.load_model("/pscratch/sd/z/zhangtao/E3SMv2_1/F2010.ne30pg2_EC30to60E2r2_ML_Test_Framework/case_scripts/SourceMods/src.eam/tf")

    #CAPE_model = model_from_json(CAPE_json)
    #BCU_model = model_from_json(BCU_json)

    #CAPE_model.load_weights(f'{file_path}/E3SM_ML_PDF_CAPE_trained_on_31_days.h5')
    #BCU_model.load_weights(f'{file_path}/E3SM_ML_BCU.h5')

    time2 = time.time()

#    print(f'Time in Python: load data = {time2-time1:.2f}s')

cdef public double* calc_trigger(int pcols, int pver, double **t, double **p, double **q):
    import numpy as np
    import time

    cdef double [:] cape

    time1 = time.time()
    temp = np.zeros((pver,pcols))
    pres = np.zeros((pver,pcols))
    qv = np.zeros((pver,pcols))

    for i in range(pver):
        for j in range(pcols):
            temp[i,j] = t[0][j+i*pcols]
            pres[i,j] = p[0][j+i*pcols]
            qv[i,j]   = q[0][j+i*pcols]

    time2 = time.time()

#    print(f'Time in Python: convert double ** to numpy  = {time2-time1:.2f}s')

    BCU_trig, CAPE = cape_pdf(pcols, temp, pres, qv)
    cape = np.concatenate([BCU_trig,CAPE])

    print("Python BCU ",BCU_trig)
    print("Python cape ",CAPE)
    print("BCU_trig shape=", BCU_trig.shape, " CAPE shape=", CAPE.shape)

    del temp 
    del pres 
    del qv

    return &cape[0]

def cape_pdf(pcols, temp, pres, qv):
    import numpy as np
    import time

    nz = 72
    n_channels = 3
    n_scalars  = 4
    n_bins     = 32
    
    # Apply 1st simple (global) normalisation
    max_temp  = 320.0
    min_temp  = 140.0
    max_qv    = 0.025
    max_pres  = 106000.0
    temp      = ( temp - min_temp) / (max_temp-min_temp)
    qv        = qv / max_qv
    pres      = pres / max_pres

    temp_mean = means[   0:  nz]
    qv_mean   = means[  nz:2*nz]
    pres_mean = means[2*nz:3*nz]
    #
    temp_std  = stds[   0:  nz]
    qv_std    = stds[  nz:2*nz]
    pres_std  = stds[2*nz:3*nz]
    # Do 2nd normalisation
    
    time1 = time.time()
    for k in np.arange(0,nz):
        if temp_std[k] > 0.0:
            temp[k,:]=(temp[k,:]-temp_mean[k])/temp_std[k]
        else:
            temp[k,:]=temp[k,:]-temp_mean[k]
        if qv_std[k] > 0.0:
            qv[k,:]=(qv[k,:]-qv_mean[k])/qv_std[k]
        else:
            qv[k,:]=qv[k,:]-qv_mean[k]
        if pres_std[k] > 0.0:
            pres[k,:]=(pres[k,:]-pres_mean[k])/pres_std[k]
        else:
            pres[k,:]=pres[k,:]-pres_mean[k]

    time2 = time.time()
    #print(f'Time in Python: normalization  = {time2-time1:.2f}s')

    # Define arrays of correct size for passing into ML
    tqp_data=np.empty([pcols,nz,n_channels])
    extra_data=np.empty([pcols,1,n_scalars])
    # Now deal with 4 scalar inputs
    max_orog          = 4000.0
    # Specify an altitude of 100m (normalised by 4000)
    extra_data[0,:,0] = 100.0 / max_orog
    # Specify a std of orography of 50m (normalised by 1200)
    extra_data[0,:,1] = 50.0 / 1200.0
    # Specify the land-sea mask, i.e. fraction of the grid-box that is land (let's say 80% land : 20% sea in this example)
    extra_data[0,:,2] = 0.8
    # Specify a gridbox size (normalised by 144km, i.e. 1 for dx=144km, 0.5 for dx=72km, 0.347 for 50 km.
    extra_data[0,:,3] = 0.347
    # Replicate that entry.
    #extra_data[1,:,:] = extra_data[0,:,:]

    time1 = time.time()
    for i in range(pcols):
        # Put temp, qv and pressure into the 3 channels
        tqp_data[i,:,0] = temp[:,i]
        tqp_data[i,:,1] = qv[:,i]
        tqp_data[i,:,2] = pres[:,i]

        extra_data[i,:,:] = extra_data[0,:,:]
        # As ML algo expects to deal with lots of sample, it complains when it only has one,
        # (so just replicate that one entry).
        #tqp_data[1,:,:] = tqp_data[0,:,:]

    thres = 0.05 # 0.01 0.02 0.05 0.1

    
    print("after load model")
    tqp_data = np.expand_dims(tqp_data,3)
    extra_data = extra_data[:,0,:]
    BCU_trig = BCU_model.predict([tqp_data,extra_data])[0]
    expectation_value = CAPE_model.predict([tqp_data,extra_data]).astype(np.float64)[0]

    #tqp_data = tf.convert_to_tensor(tqp_data,dtype=tf.float32)
    #extra_data = tf.convert_to_tensor(extra_data,dtype=tf.float32)
    #BCU = BCU_model.predict([tqp_data, extra_data], verbose=False)
    #CAPE = CAPE_model.predict([tqp_data, extra_data], verbose=False)
    

#    BCU_trig = np.any(BCU >= thres, axis=1).astype(float)
#    pdf_of_cape = CAPE
#    x           = np.arange(0,n_bins)
#    max_cape    = 4500
#    cape_array  = (x**2.0)*max_cape/((n_bins-1)*(n_bins-1))
#    expectation_value = np.sum( cape_array * pdf_of_cape, axis=1)

    time2 = time.time()
    print(f'Time in Python: calculation  = {time2-time1:.2f}s')
    del tqp_data 
    del extra_data
    del temp 
    del qv 
    del pres 
#    del x
    
    print(f'zhangtao BCU and CAPE')
    return BCU_trig, expectation_value
    #return expectation_value, expectation_value
