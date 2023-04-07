program Intermittency_type_III_ection
    use precision
    use mtmod
    use maps
    use matrixalgebra
    use vector_statistics
    implicit none

    integer(sp)                 :: seed
    integer(dp)                 :: i,j,k,l
    integer(dp)                 :: n_bins,n_iterations,n_reinjected
    integer(dp)                 :: maxlength,minlength
    real(dp)                    :: xn,xn1,c,eps(2),a(2),d(2)
    real(dp)                    :: lblr,ublr
    real(dp)                    :: avglength
    integer(dp), allocatable    :: counter(:),lengths_dom(:)
    real(dp), allocatable       :: x_reinjected(:)
    real(dp), allocatable       :: laminarlength(:),laminar_avg(:),prolam(:)

    ! Open files to write
    open(31,file='datafiles/Intermittency_type_III_xreinj1.dat',status='replace')
    open(32,file='datafiles/Intermittency_type_III_xreinj2.dat',status='replace')
    open(33,file='datafiles/Intermittency_type_III_lam_length_1.dat',status='replace')
    open(34,file='datafiles/Intermittency_type_III_lam_length_2.dat',status='replace')
    open(35,file='datafiles/Intermittency_type_III_avglam_length_1.dat',status='replace')
    open(36,file='datafiles/Intermittency_type_III_avglam_length_2.dat',status='replace')
    

    ! Initialization of Mersenne-Twister generator
    seed = 31122_sp
    call sgrnd(seed)

    ! We define some quantities of interest
    n_reinjected = 25000_dp
    n_iterations = 0_dp ! Number of iterations
    n_bins = 100_dp ! Number of sub-intervals in laminar-zone

    ! Limits of laminar interval
    ! lblr: lower boundary of laminar region
    ! ublr: upper boundary of laminar region
    c = 0.6_dp; lblr = 0._dp; ublr = c

    ! Allocation of arrays to be used
    allocate(lengths_dom(n_bins),laminar_avg(n_bins))
    allocate(laminarlength(n_reinjected))
    allocate(x_reinjected(n_reinjected))
    allocate(prolam(n_bins),counter(n_bins))
    
    ! Parameters of the map
    eps = [0.01_dp, 0.0001_dp]
    a = [1._dp, 1.1_dp]
    d = [1.1_dp, 1.35_dp]

    ! Loop through both set of parameters
    do i = 1,2
        ! Set arrays to zero.
        laminar_avg = 0._dp
        laminarlength = 0._dp
        counter = 0_dp; prolam = 0._dp
        x_reinjected = 0._dp
        xn = grnd()
        ! Compute the map the desired number of reinjections
        j = 0_dp
        l = 0_dp
        n_iterations = 0_dp
        do while (l < n_reinjected)
            j = j + 1_dp
            n_iterations = n_iterations + 1_dp
            xn1 = map_III_a(xn,eps(i),a(i),d(i))

            if (i == 1) then
                write(31,"(I8,E16.6)") j,xn1
            else if (i == 2) then
                write(32,"(I8,E16.6)") j,xn1
            endif
            if (xn1 > lblr .and. xn1 <= c .and. abs(xn) > abs(c)) then
                k = j
                l = l + 1_dp
                x_reinjected(l) = xn1
                ! Fill arrays of probability, counter and x_avg
            endif

            if (xn > lblr .and. xn <= c .and. abs(xn1) > abs(c) .and. l > 0_dp) then
                laminarlength(l) = j - k
            endif
            xn = xn1
        enddo

        ! Now we define the domain of laminar lengths
        maxlength = int(maxval(laminarlength))
        minlength = int(minval(laminarlength))

        lengths_dom = int(linspace(1._dp,real(maxlength,dp),n_bins+1_dp))

        do j = 1,n_reinjected
            do k = 1,n_bins
                if (laminarlength(j) >= lengths_dom(k) .and. laminarlength(j) < lengths_dom(k+1)) then
                    counter(k) = counter(k) + 1_dp
                    laminar_avg(k) = laminar_avg(k) + laminarlength(j)
                endif
            enddo
        enddo

        do j = 1,n_bins
            if (counter(j) > 0_dp) then
                laminar_avg(j) = laminar_avg(j)/real(counter(j),dp)
            else if (counter(j) == 0_dp) then
                laminar_avg(j) = 0._dp
            endif
            if (i == 1) then
                write(33,"(I8,I8,E16.6)") lengths_dom(j),counter(j),real(counter(j),dp)/real(n_reinjected,dp)
            else if (i == 2) then
                write(34,"(I8,I8,E16.6)") lengths_dom(j),counter(j),real(counter(j),dp)/real(n_reinjected,dp)
            endif
        enddo

        avglength = 0._dp
        do j = 1,n_bins
            avglength = avglength + laminar_avg(j)/n_bins
            if (i == 1) then
                write(35,"(I8,E16.6)") lengths_dom(j),avglength
            else if (i == 2) then
                write(36,"(I8,E16.6)") lengths_dom(j),avglength
            endif
        enddo

        laminar_avg = 0._dp; lengths_dom = 0_dp; laminarlength = 0._dp
        x_reinjected = 0._dp; counter = 0_dp; prolam = 0._dp 

    enddo        
    deallocate(laminar_avg,lengths_dom,laminarlength)
    deallocate(x_reinjected,counter,prolam)

    close(31)
    close(32)
    close(33)
    close(34)
    close(35)
    close(36)

end program Intermittency_type_III_ection