include=/global/cfs/projectdirs/m2136/backup/conda/envs/pytorch1/include/python3.11
libs=/global/cfs/projectdirs/m2136/backup/conda/envs/pytorch1/lib
export PYTHONPATH=/global/homes/z/zhangtao/tmp/fortran-call-python/cffi/cython

N=(100 1000 10000 100000 1000000)
for nn in "${N[@]}"
do
    echo $nn
    sed -i "/parameter/c\integer, parameter :: N = $nn" zm.f90

    rm cape *.o *.mod

    cython ml_pdf_cape.pyx
    gcc -g -c cape_ml_bridge.c ml_pdf_cape.c -I${include}  -I/global/cfs/projectdirs/m2136/backup/conda/envs/pytorch1/include/python3.11

    gfortran -g  -o cape  cape_ml_wrapper.F90 cape_ml_bridge.o ml_pdf_cape.o zm.f90  -Wl,-rpath ${libs} -L${libs} -lpython3.11
    perf-report -o $nn.txt  ./cape
    time ./cape
done
