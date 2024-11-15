program example
use callpy_mod
implicit none

integer, parameter :: N = 1000000
real(8) :: a(N)
real(8) :: b(N)
real(8) :: c(N)
real(8) :: d(N)
real(8) :: a_new(N)
integer i


do i=1,N
    call random_number(a(i))
    call random_number(b(i))
    call random_number(c(i))
    call random_number(d(i))
end do


do i = 1, 1000
    call set_state("a", a)
    call set_state("b", b)
    call set_state("c", c)
    call set_state("d", d)
    call call_function("setget_array", "fun")
    ! read any changes from "a" back into a.
    call get_state("a_new", a_new)
    !print *, a_new
end do

end program example
