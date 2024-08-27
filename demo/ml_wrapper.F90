module ml_wrapper
    interface
    integer function wrap_ml_f(pcols,pver,t,cape)  bind(C, name="wrap_ml_c")
        use iso_c_binding
        implicit none
        integer (C_INT),value :: pcols
        integer (C_INT),value :: pver       
        real(C_DOUBLE), DIMENSION(:,:) :: t
        real(C_DOUBLE), DIMENSION(:,:) :: cape
        !real(C_DOUBLE) :: cape(16)

    end function wrap_ml_f

    integer function ml_init() bind(C, name="ml_init_c")
        use iso_c_binding
        implicit none
    end function ml_init
    end interface
end module ml_wrapper
     
