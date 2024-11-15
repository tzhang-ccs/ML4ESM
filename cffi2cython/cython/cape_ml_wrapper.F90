module cape_ml_wrapper
    interface
    integer function cape_ml_c(N,a,b,c,d,a_new)  bind(C, name="cape_ml")
        use iso_c_binding
        implicit none
        integer (C_INT),value :: N
        real(C_DOUBLE), DIMENSION(:) :: a
        real(C_DOUBLE), DIMENSION(:) :: b
        real(C_DOUBLE), DIMENSION(:) :: c
        real(C_DOUBLE), DIMENSION(:) :: d
        real(C_DOUBLE), DIMENSION(:) :: a_new
        !real(C_DOUBLE) :: cape(16)

    end function cape_ml_c

    integer function ml_init() bind(C, name="ml_init_c")
        use iso_c_binding
        implicit none
    end function ml_init
    end interface
end module cape_ml_wrapper
     
