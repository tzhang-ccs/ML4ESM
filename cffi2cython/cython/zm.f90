program simple
    use cape_ml_wrapper
    implicit none
integer, parameter :: N = 1000000

    !real*8 tmp
    real*8 a(N)
    real*8 b(N)
    real*8 c(N)
    real*8 d(N)
    real*8 a_new(N)
    integer i,j


    do i=1,N
        call random_number(a(i))
        call random_number(b(i))
        call random_number(c(i))
        call random_number(d(i))
    end do
    
    i = ml_init()

    do i=1,1000
        j = cape_ml_c(N,a,b,c,d,a_new)
    end do 
end program simple
