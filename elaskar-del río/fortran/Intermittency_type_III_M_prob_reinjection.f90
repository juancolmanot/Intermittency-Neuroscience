program Intermittency_type_III_M_prob_reinjection
    use precision
    use mtmod
    use maps
    use matrixalgebra
    use vector_statistics
    implicit none

    integer(sp)                 :: seed
    integer(dp)                 :: i,j,k
    integer(dp)                 :: n_bins,n_iterations,n_reinjected
    real(dp)                    :: xn,xn1,c,eps(2),a(2),d(2)
    real(dp)                    :: lblr,ublr,M_num,M_den
    integer(dp), allocatable    :: counter(:)
    real(dp), allocatable       :: x_bins(:),M_x(:)
    real(dp), allocatable       :: x_avg(:),prob(:)

    ! Open files to write
    open(21,file='datafiles/Intermittency_type_III_x_reinj_trajectory1.dat',status='replace')
    open(22,file='datafiles/Intermittency_type_III_x_reinj_trajectory2.dat',status='replace')
    open(23,file='datafiles/Intermittency_type_III_M_reinj_prob1.dat',status='replace')
    open(24,file='datafiles/Intermittency_type_III_M_reinj_prob2.dat',status='replace')
    

    ! Initialization of Mersenne-Twister generator
    seed = 31122_sp
    call sgrnd(seed)

    ! We define some quantities of interest
    n_reinjected = 15000_dp
    n_iterations = 0_dp ! Number of iterations
    n_bins = 100_dp ! Number of sub-intervals in laminar-zone

    ! Limits of laminar interval
    ! lblr: lower boundary of laminar region
    ! ublr: upper boundary of laminar region
    c = 0.6_dp; lblr = 0._dp; ublr = c

    ! Allocation of arrays to be used
    allocate(M_x(n_bins),x_avg(n_bins))
    allocate(prob(n_bins),counter(n_bins))
    allocate(x_bins(n_bins+1_dp))
    
    ! Parameters of the map
    eps = [0.01_dp, 0.0001_dp]
    a = [1._dp, 1.1_dp]
    d = [1.1_dp, 1.35_dp]

    ! We set the array of the domain
    x_bins = linspace(lblr,ublr,n_bins+1_dp)

    ! Loop through both set of parameters
    do i = 1,2
        ! Set arrays to zero.
        M_x = 0._dp; x_avg = 0._dp
        counter = 0_dp; prob = 0._dp

        xn = grnd()
        ! Compute the map the desired number of iterations
        j = 1_dp
        n_iterations = 0_dp
        do while (j < n_reinjected)
            n_iterations = n_iterations + 1_dp
            xn1 = map_III_a(xn,eps(i),a(i),d(i))
            if (i == 1) then
                write(21,"(I8,E16.6)") j,xn1
            else if (i == 2) then
                write(22,"(I8,E16.6)") j,xn1
            endif
            if (xn1 > lblr .and. xn1 <= c .and. abs(xn) > abs(c)) then
                j = j + 1_dp
                ! Fill arrays of probability, counter and x_avg
                do k = 1,n_bins
                    if (xn1 >= x_bins(k) .and. xn1 < x_bins(k+1)) then
                        counter(k) = counter(k) + 1_dp
                        x_avg(k) = x_avg(k) + xn1
                    endif
                enddo
            endif
            xn = xn1
        enddo
    
        ! We procede to compute the global probabilities
        do j = 1,n_bins
            if (counter(j) > 0_dp) then
                x_avg(j) = x_avg(j)/counter(j)
                prob(j) = real(counter(j),dp)/real(n_reinjected,dp)
            else if (counter(j) == 0_dp) then
                x_avg(j) = 0._dp
                prob(j) = 0._dp
            endif
        enddo

        ! Now declare the variables to store both the numerator and the denominator
        ! of M function.

        ! Numerator will store the integral of the product x*phi(x) between
        ! the fixed point (0.0) and the current value of the x in the domain given by the
        ! x_bins array.

        M_num = 0._dp

        ! Denominator will store the integral of the probability function bet-
        ! ween the fixed point and the current value of x.

        M_den = 0._dp

        do j = 1,n_bins
            M_num = M_num + x_avg(j)*prob(j)
            M_den = M_den + prob(j)

            if (M_den > 0._dp) then
                M_x(j) = M_num/M_den
            else if (M_den == 0._dp) then
                M_x(j) = 0._dp
            endif
            
            if (i == 1) then
                write(23,"(I8,4(E16.6))") counter(j),x_bins(j),x_avg(j),prob(j),M_x(j)
            else if (i == 2) then
                write(24,"(I8,4(E16.6))") counter(j),x_bins(j),x_avg(j),prob(j),M_x(j)
            endif
        enddo
    enddo

    deallocate(x_bins,x_avg,M_x,counter,prob)

    close(21)
    close(22)
    close(23)
    close(24)


end program Intermittency_type_III_M_prob_reinjection