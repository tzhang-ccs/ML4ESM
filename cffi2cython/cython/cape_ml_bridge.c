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

    //python_init();

    return 0;
}

double 
cape_ml(int N, double *a, double *b, double *c, double *d, double *a_new)
{
    double *cape_r;
    int i,j;

    cape_r = calc_cape(N, a,b,c,d);

    return 1.0;
}

