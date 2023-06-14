program Intermittency_type_III_M
    use precision
    use mtmod
    use maps
    use matrixalgebra
    implicit none

    integer(sp)                 :: seed
    integer(dp)                 :: i,j,k,n_bins,n_reinjected,ratio_rein_bins,n_iterations
    real(dp)                    :: xn,xn1,c,lblr,ublr,eps(2),a(2),d(2),M_num,M_den
    integer(dp), allocatable    :: counter(:)
    real(dp), allocatable       :: x_bins(:),M_x1(:)
    real(dp), allocatable       :: x_reinjected(:),x_reinjected_sorted(:)
    real(dp), allocatable       :: x_avg(:),prob(:),M_x2(:)
    

    ! Datafile in which the data will be stored
    open(11,file='datafiles/Intermittency_type_III_x_case1.dat',status='replace')
    open(12,file='datafiles/Intermittency_type_III_xreinjected_case1.dat',status='replace')
    open(13,file='datafiles/Intermittency_type_III_M_sum_case1.dat',status='replace')
    open(14,file='datafiles/Intermittency_type_III_M_prob_case1.dat',status='replace')
    open(15,file='datafiles/Intermittency_type_III_x_case2.dat',status='replace')
    open(16,file='datafiles/Intermittency_type_III_xreinjected_case2.dat',status='replace')
    open(17,file='datafiles/Intermittency_type_III_M_sum_case2.dat',status='replace')
    open(18,file='datafiles/Intermittency_type_III_M_prob_case2.dat',status='replace')

    ! Initialization of Mersenne-Twister generator
    seed = 31122_sp
    call sgrnd(seed)

    ! Limits of the laminar interval
    ! lblr: lower boundary of laminar region
    ! ublr: upper boundary of laminar region
    c = 0.6_dp;lblr = 0._dp; ublr = c
    
    ! Number of bins in which the laminar interval will be divided
    n_bins = 200_dp

    ! Intended number of reinjected points
    n_reinjected = 15000_dp

    ! Number of iterations being made
    n_iterations = 0_dp

    ! Ratio of reinjected points over bins
    ratio_rein_bins = int(real(n_reinjected, dp) / real(n_bins, dp))

    ! Allocation and initialization of different vectors of interest
    allocate(M_x1(n_reinjected),prob(n_bins))
    allocate(x_bins(n_bins + 1),counter(n_bins),x_avg(n_bins),M_x2(n_bins))
    allocate(x_reinjected(n_reinjected),x_reinjected_sorted(n_reinjected))
    M_x1 = 0._dp;M_x2 = 0._dp
    x_avg = 0._dp; x_bins = 0._dp; counter = 0_dp;
    x_reinjected = 0._dp; x_reinjected_sorted = 0._dp

    ! Parameters of the map
    eps = [0.01_dp, 0.0001_dp]
    a = [1._dp, 1.1_dp]
    d = [1.1_dp, 1.35_dp]

    ! We set the array of the domain
    x_bins = linspace(lblr,ublr,n_bins+1_dp);

    ! Loop through both set of parameters
    do i = 1,2
        xn = grnd()

        M_x1 = 0._dp; M_x2 = 0._dp
        x_avg = 0._dp; counter = 0_dp; prob = 0._dp

        ! Loop until we obtain the desired amount of reinjection points
        j = 0_dp;
        n_iterations = 0_dp
        do while (j < n_reinjected)
            n_iterations = n_iterations + 1_dp
            xn1 = map_III_a(xn,eps(i),a(i),d(i))
            if (i == 1) then
                write(11,"(I8,E16.6)") j,xn1
            else if (i == 2) then
                write(15,"(I8,E16.6)") j,xn1
            endif
            if (xn1 > lblr .and. xn1 <= c .and. abs(xn) > abs(c)) then
                j = j + 1_dp
                x_reinjected(j) = xn1
                if (i == 1) then
                    write(12,"(I8,E14.4)") j,xn1
                else if (i == 2) then
                    write(16,"(I8,E14.4)") j,xn1
                endif
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

        ! Sort vector from min to max value
        x_reinjected_sorted = sort_minor(x_reinjected)

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

        ! Start computing the M function with te probabilities
        M_num = 0._dp; M_den = 0._dp

        do j = 1,n_bins
            M_num = M_num + x_avg(j)*prob(j)
            M_den = M_den + prob(j)

            if (M_den > 0._dp) then
                M_x2(j) = M_num/M_den
            else if (M_den == 0._dp) then
                M_x2(j) = 0._dp
            endif
            
            if (i == 1) then
                write(14,"(3(E16.6))") x_bins(j),prob(j),M_x2(j)
            else if (i == 2) then
                write(18,"(3(E16.6))") x_bins(j),prob(j),M_x2(j)
            endif
        enddo
        
        ! Compute the M function with the ordered sum
        do j = 1,n_reinjected
            do k = 1,j
                M_x1(j) = M_x1(j) + x_reinjected_sorted(k)
            enddo
            M_x1(j) = M_x1(j)/real(j,dp)
            if (i == 1_dp) then
                write(13,"(2(E16.6))") x_reinjected_sorted(j),M_x1(j)
            else if (i == 2_dp) then
                write(17,"(2(E16.6))") x_reinjected_sorted(j),M_x1(j)
            endif
        enddo

        M_x2 = 0._dp; x_avg = 0._dp; M_x1 = 0._dp; counter = 0_dp; x_reinjected = 0._dp; x_reinjected_sorted = 0._dp

    enddo

    deallocate(counter,x_bins,x_avg,x_reinjected,x_reinjected_sorted,M_x1,M_x2)

    close(11)
    close(12)
    close(13)
    close(14)
    close(15)
    close(16)
    close(17)
    close(18)

end program Intermittency_type_III_M