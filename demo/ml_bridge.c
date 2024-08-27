#include <stdio.h>
#include <Python.h>
#include "ml_pdf_cape.h"
#include <sys/time.h>

int
ml_init_c()
{
    int i;
    PyImport_AppendInittab("ml_pdf_cape", PyInit_ml_pdf_cape);
    Py_Initialize();
    PyImport_ImportModule("ml_pdf_cape");

    python_init();

    return 0;
}

double 
wrap_ml_c(int pcols, int pver, double **t, double **cape)
{
    double *cape_r;
    struct timeval tv1,tv2;
    float runtime;
    int i,j;

    cape_r = calc_cape(pcols,pver,t);

    return 1.0;
}

