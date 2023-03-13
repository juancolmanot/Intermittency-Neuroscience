program Intermittency_type_III_M_function
    use precision
    use mtmod
    use maps
    use matrixalgebra

    integer(sp)                 :: seed
    integer(dp)                 :: i,j,k,n_transient,n_bins,n_reinjected
    real(dp)                    :: xn,xn1,c,x_start,x_end,eps(2),a(2),d(2)
    integer(dp), allocatable    :: count(:)
    real(dp), allocatable       :: x_bins(:),M_x(:),x_reinjected(:)

    ! Datafile in which the data will be stored
    open(12,file='Intermittency_type_III_M.dat',status='replace')

    ! Initialization of Mersenne-Twister generator
    seed = 31122_sp
    call sgrnd(seed)

    ! Limits of the laminar interval
    c = 0.6_dp; x_start = 0._dp; x_end = c
    
    ! Number of bins in which the laminar interval will be divided
    n_bins = 100_dp

    ! Intended number of reinjected points
    n_reinjected = 1000_dp

    ! Allocation and initialization of different vectors of interest
    allocate(x_bins(n_bins),M_x(n_bins),count(n_bins),x_reinjected(n_reinjected))
    x_bins = 0._dp; M_x = 0._dp; count = 0_dp; x_reinjected = 0._dp
    x_bins = linspace(x_start, x_end, n_bins + 1_dp)

    ! Number of steps of assumed transient behavior
    n_transient = 100_dp

    ! Parameters of the map
    eps = [0.01_dp, 0.0001_dp]
    a = [1._dp, 1.1_dp]
    d = [1.1_dp, 1.35_dp]

    ! Loop through both set of parameters
    do i = 1,1
        xn = grnd()
        write(*,*) xn
        ! Loop to obtained the desired amount of reinjection points
        k = 0_dp
        do while (k < n_reinjected)
            xn1 = map_III_a(xn,eps(i),a(i),d(i))
            if (j > n_transient) then
                write(*,*) "Got passed transient"
                if (xn1 > 0._dp .and. xn1 <= c .and. abs(xn) > abs(c)) then
                    write(*,*) "Got a reinjected point",k
                    k = k + 1_dp
                    x_reinjected(k) = xn1
                endif
            endif
            xn = xn1
        enddo
        do j = 1,n_reinjected
            write(12,"(I8,E16.6)") j,x_reinjected(j)
        enddo
    enddo


end program Intermittency_type_III_M_function