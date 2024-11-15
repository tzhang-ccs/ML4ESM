export PYTHONPATH=/global/homes/z/zhangtao/tmp/fortran-call-python/cffi/call_py_fort/examples

N=(100 1000 10000 100000 1000000)

for nn in "${N[@]}"
do
    echo $nn
    sed -i "/parameter/c\integer, parameter :: N = $nn" setget_array.f90

    rm a.out
    gfortran setget_array.f90  -Wl,-rpath /global/homes/z/zhangtao/cfs_m2136/backup/soft/miniconda3/lib/:/global/homes/z/zhangtao/tmp/fortran-call-python/cffi/call_py_fort/examples  -L/global/homes/z/zhangtao/tmp/fortran-call-python/cffi/call_py_fort/examples -L/global/homes/z/zhangtao/cfs_m2136/backup/soft/miniconda3/lib/  -lcallpy -lpython3.8
    perf-report -o $nn.txt  ./a.out
    time ./a.out
done

grep 'Peak process memory usage' 1*txt
