include=/global/cfs/projectdirs/m2136/backup/conda/envs/pytorch2/include/python3.12
libs=/global/cfs/projectdirs/m2136/backup/conda/envs/pytorch2/lib
export PYTHONPATH=/global/homes/z/zhangtao/tmp/fortran-call-python/cython/main

rm main
rm *.o *.mod

gcc -c ml_bridge.c ml_pdf_cape.c   -I${include}

gfortran -g -o main ml_wrapper.F90 ml_bridge.o main.f90 ml_pdf_cape.o  -Wl,-rpath ${libs} -L${libs} -lpython3.12
./main
