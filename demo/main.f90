program simple
    use ml_wrapper
    implicit none
    integer*4 ierr, taskid, npes, i, j
    integer*4 pcols, pver
    !real*8 tmp
    real*8 t(16,72)
    real*8 q(16,72)
    real*8 p(16,72)
    real*8 cape(16,1)
    !TYPE(C_PTR) :: tmp

    i = ml_init()

    pcols = 16
    pver = 72
    
    do i=1,pcols
        t(i,1) = i
    end do

    do i=1,pcols
        t(i,2) = i
    end do
    !call MPI_INIT(ierr)
    !call MPI_COMM_RANK(MPI_COMM_WORLD, taskid, ierr)
    !call MPI_COMM_SIZE(MPI_COMM_WORLD, npes, ierr)

    j = wrap_ml_f(pcols,pver,t,cape)
    !print *, "cape", cape
    !print *, "I am rank ", taskid
    !print *, "before cape"
    !print *, "after cape"

    !call MPI_FINALIZE(ierr)

end program simple
