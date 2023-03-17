program Intermittency_type_III_M_function
    use precision
    use mtmod
    use maps
    use matrixalgebra
    use vector_statistics

    integer(sp)                 :: seed
    integer(dp)                 :: i,j,k,n_bins,n_reinjected
    real(dp)                    :: xn,xn1,c,x_start,x_end,eps(2),a(2),d(2)
    integer(dp), allocatable    :: counter(:)
    real(dp), allocatable       :: x_bins(:),M_x(:),M_x_avg(:)
    real(dp), allocatable       :: x_reinjected(:),x_reinjected_sorted(:)
    real(dp), allocatable       :: x_avg(:)

    ! Datafile in which the data will be stored
    open(12,file='Intermittency_type_III_xreinjected_case1.dat',status='replace')
    open(13,file='Intermittency_type_III_M_case1.dat',status='replace')
    open(14,file='Intermittency_type_III_M_avg_case1.dat',status='replace')
    open(15,file='Intermittency_type_III_xreinjected_case2.dat',status='replace')
    open(16,file='Intermittency_type_III_M_case2.dat',status='replace')
    open(17,file='Intermittency_type_III_M_avg_case2.dat',status='replace')

    ! Initialization of Mersenne-Twister generator
    seed = 31122_sp
    call sgrnd(seed)

    ! Limits of the laminar interval
    c = 0.6_dp;x_start = 0._dp; x_end = c
    
    ! Number of bins in which the laminar interval will be divided
    n_bins = 100_dp

    ! Intended number of reinjected points
    n_reinjected = 10000_dp

    ! Allocation and initialization of different vectors of interest
    allocate(M_x(n_reinjected))
    allocate(x_avg(n_bins))
    allocate(x_bins(n_bins),M_x_avg(n_bins),counter(n_bins))
    allocate(x_reinjected(n_reinjected),x_reinjected_sorted(n_reinjected))
    M_x = 0._dp
    x_avg = 0._dp
    x_bins = 0._dp; M_x_avg = 0._dp; counter = 0_dp;
    x_reinjected = 0._dp; x_reinjected_sorted = 0._dp
    !x_bins = linspace(x_start, x_end, n_bins)

    ! Parameters of the map
    eps = [0.01_dp, 0.0001_dp]
    a = [1._dp, 1.1_dp]
    d = [1.1_dp, 1.35_dp]

    ! Loop through both set of parameters
    do i = 1,1
        !write(*,*) i
        xn = grnd()
        ! Loop to obtained the desired amount of reinjection points
        k = 0_dp
        do while (k < n_reinjected)
            xn1 = map_III_a(xn,eps(i),a(i),d(i))
            if (xn1 > 0._dp .and. xn1 <= c .and. abs(xn) > abs(c)) then
                k = k + 1_dp
                x_reinjected(k) = xn1
                if (i == 1) then
                    write(12,"(I8,E14.4)") k,xn1
                else if (i == 2) then
                    write(15,"(I8,E14.4)") k,xn1
                endif
            endif
            xn = xn1
        enddo
        ! Sort vector from min to max value
        x_reinjected_sorted = sort_minor(x_reinjected)

        ! Compute the M function
        do j = 1,n_reinjected
            do k = 1,j
                M_x(j) = M_x(j) + x_reinjected_sorted(k)
            enddo
            if (i == 1_dp) then
                write(13,"(2(E16.6))") x_reinjected_sorted(j),M_x(j)/real(j,dp)
            else if (i == 2_dp) then
                write(16,"(2(E16.6))") x_reinjected_sorted(j),M_x(j)/real(j,dp)
            endif
        enddo

        ! 
        x_avg = x_n_avg(x_reinjected_sorted,n_bins)

        ! Compute M function with averages
        do j = 1,n_bins
            do k = 1,j
                M_x_avg(j) = M_x_avg(j) + x_avg(j)
            enddo
            if (i == 1_dp) then
                write(14,"(2(E16.6))") x_avg(j),M_x_avg(j)/real(j,dp)
            else if (i == 2_dp) then
                write(17,"(2(E16.6))") x_avg(j),M_x_avg(j)/real(j,dp)
            endif
        enddo

        M_x = 0._dp; counter = 0_dp; M_x_avg = 0._dp; x_reinjected = 0._dp; x_reinjected_sorted = 0._dp
    enddo

    


end program Intermittency_type_III_M_function