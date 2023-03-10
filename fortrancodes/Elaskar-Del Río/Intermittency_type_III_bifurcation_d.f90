program Intermittency_type_III_bifurcation_d
    use precision
    use mtmod
    use maps
    implicit none

    integer(sp)         :: seed
    integer(dp)         :: i,j,n_steps,n_transient,n_d
    real(dp)            :: x,x1,eps,a,d

    open(11,file='RPD-type-III_intermittency_bifurcation.dat',status='replace')
    open(12,file='RPD-type-III_intermittency_trajectory.dat',status='replace')

    seed = 9852_sp

    call sgrnd(seed)

    d = 0.9_dp

    eps = 0.01_dp; a = 1._dp

    n_d = 50_dp;n_steps = 5000_dp; n_transient = 4000_dp

    do i = 1,n_d
        d = d + (1.25_dp - 0.9_dp)/real(n_d,dp)
        x = grnd()
        do j = 1,n_steps
            x1 = map_III_a(x,eps,a,d)
            if(j > n_transient) then
                write(11,"(E16.6,I8,E16.6)") d,j,x
            endif
            x = x1
        enddo
    enddo

    n_steps = 1500_dp
    x = grnd()
    d = 1.05_dp
    do i = 1,n_steps
        x1 = map_III_a(x,eps,a,d)
        write(12,"(I8,E16.6)") i,x
        x = x1
    enddo

end program Intermittency_type_III_bifurcation_d