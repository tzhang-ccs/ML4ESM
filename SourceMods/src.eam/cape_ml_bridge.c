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
cape_ml(int pcols, int pver, double **t, double **p, double **q, double **cape)
{
    double *cape_r;
    struct timeval tv1,tv2;
    float runtime;

    //PyImport_AppendInittab("ml_pdf_cape", PyInit_ml_pdf_cape);
    //Py_Initialize();
    //PyImport_ImportModule("ml_pdf_cape");

    printf("Before CAPE by Python in C\n");
    gettimeofday(&tv1,NULL);
    cape_r = calc_trigger(pcols,pver,t,p,q);
    gettimeofday(&tv2,NULL);
    runtime = (tv2.tv_sec - tv1.tv_sec) + (double)(tv2.tv_usec - tv1.tv_usec)/1000000.0;


    printf("CAPE by Python in C %f\n",cape_r[0]); 

    for(int i=0; i < pcols * 2; i++){
    //for(int i=0; i < pcols; i++){
    //    printf("%f ", cape_r[i]);
        cape[0][i] = cape_r[i];
    }
//    printf("\n");

    return 1.0;
//    Py_Finalize();

}

//int
//main11(int argn, char **argv)
//{
//    double args[72*3];
//    double *cape;
//
//    PyImport_AppendInittab("ml_pdf_cape", PyInit_ml_pdf_cape);
//    Py_Initialize();
//    PyImport_ImportModule("ml_pdf_cape");
//
//    for(int i=0; i<72*3; i++){
//        args[i] = rand()/(double)RAND_MAX;
//        printf("%f ", args[i]);
//    }
//
//    printf("first arg is %f\n",args[0]);
//    cape = calc_cape(args);
//    
//    printf("cape is %f\n", cape[0]);
//
//    Py_Finalize();
//
//    return 0;
//}
