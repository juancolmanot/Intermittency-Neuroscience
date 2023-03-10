program Intermittency_type_III_M_function
    use precision
    use mtmod
    use maps
    use matrixalgebra

    integer(sp)                 :: seed
    integer(dp)                 :: i,j,k,n_steps,n_transient,n_bins
    real(dp)                    :: xn,xn1,c,x_start,x_end,eps(2),a(2),d(2)
    integer(dp), allocatable    :: count(:)
    real(dp), allocatable       :: x_bins(:),M_x(:)

    open(12,file='Intermittency_type_III_M.dat',status='replace')

    seed = 4969_sp

    call sgrnd(seed)

    c = 0.6_dp; x_start = -c; x_end = c
    
    n_bins = 100_dp

    allocate(x_bins(n_bins),M_x(n_bins),count(n_bins))

    x_bins = 0._dp; M_x = 0._dp; count = 0_dp

    x_bins = linspace(x_start, x_end, n_bins + 1_dp)

    n_steps = 20000_dp; n_transient = 1000_dp

    eps = [0.01_dp, 0.0001_dp]
    a = [1._dp, 1.1_dp]
    d = [1.1_dp, 1.35_dp]

    do i = 1,2
        xn = grnd()
        do j = 1,n_steps
            xn1 = map_III_a(xn,eps(i),a(i),d(i))
            if (j > n_transient) then
                if (xn > c .and. xn1 <= c) then
                    do k = 1,n_bins-1
                        if (xn1 > x_bins(k) .and. xn1 <= x_bins(k+1)) then
                            count(k) = count(k) + 1_dp
                            M_x(k) = M_x(k) + xn1
                        endif
                    enddo
                endif
            endif
            xn = xn1
        enddo
        do j = 1,n_bins
            write(12,"(2(I8),2(E14.4))") i,count(j),x_bins(j),M_x(j)/real(count(j),dp)
        enddo
    enddo


end program Intermittency_type_III_M_function