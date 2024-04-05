module cape_ml_wrapper
    interface
    real (C_DOUBLE) function cape_ml_c(pcols,pver,t,p,q, cape)  bind(C, name="cape_ml")
        use iso_c_binding
        implicit none
        integer (C_INT), value :: pcols
        integer (C_INT), value :: pver

        real (C_DOUBLE), DIMENSION(:,:)  :: t
        real (C_DOUBLE), DIMENSION(:,:)  :: p
        real (C_DOUBLE), DIMENSION(:,:)  :: q
        real (C_DOUBLE), DIMENSION(:,:)  :: cape

    end function cape_ml_c
    integer function ml_init() bind(C, name="ml_init_c")
        use iso_c_binding
        implicit none
    end function ml_init
    end interface
end module cape_ml_wrapper
     
