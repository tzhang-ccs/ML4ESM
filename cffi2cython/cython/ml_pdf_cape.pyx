# cython: language_level=3

#!/usr/bin/env python	
#
# Cyril J Morcrette (2021), Met Office, UK
#
# In Met Office, use "module load scitools/experimental-current" at the command line before running this.
#
# Code for 
#
# Import some modules (possibly more than are strictly needed, but I did not remove what was not needed).

cdef public void python_init():
    import time
    time1 = time.time()
  
    from datetime import datetime
    from loguru import logger
    import numpy as np
    from keras.models import model_from_json
    import sys

    time2 = time.time()
    print(f'Time in Python: import = {time2-time1:.2f}s')

    time1 = time.time()
    file_path = "/global/cscratch1/sd/zhangtao/E3SM/ml_mod/pdf_cape/"
    means = np.loadtxt(f'{file_path}/E3SM_ml_pdf_cape_mean.dat')
    stds  = np.loadtxt(f'{file_path}/E3SM_ml_pdf_cape_std.dat')

    CAPE_json = open(f'{file_path}/E3SM_ML_PDF_CAPE.json','r').read()
    BCU_json  = open(f'{file_path}/E3SM_ML_BCU.json', 'r').read()
    
    global CAPE_model 
    global BCU_model

    CAPE_model = model_from_json(CAPE_json)
    BCU_model = model_from_json(BCU_json)

    CAPE_model.load_weights(f'{file_path}/E3SM_ML_PDF_CAPE_trained_on_31_days.h5')
    BCU_model.load_weights(f'{file_path}/E3SM_ML_BCU.h5')

    time2 = time.time()

    print(f'Time in Python: load data = {time2-time1:.2f}s')

cdef public double* calc_cape(int N, double *a, double *b, double *c, double *d):

    for i in range(N):
        a[i] + b[i] + c[i] + d[i]

    return a
    
