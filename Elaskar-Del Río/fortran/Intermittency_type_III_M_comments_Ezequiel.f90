program Intermittency_type_III_M_prob_comments_Ezequiel
    use precision
    use mtmod
    use maps
    use matrixalgebra
    use vector_statistics
    implicit none

    integer(sp)                 :: seed
    integer(dp)                 :: i,j,k,n_bins,n_reinjected,n_iterations
    real(dp)                    :: xn,xn1,c,x_start,x_end,eps(2),a(2),d(2),M_num,M_den
    integer(dp), allocatable    :: counter(:)
    real(dp), allocatable       :: x_bins(:),M_x(:),M_x_avg(:)
    real(dp), allocatable       :: x_reinjected(:),x_reinjected_sorted(:)
    real(dp), allocatable       :: x_avg(:),prob(:)

    ! Initialization of Mersenne-Twister generator
    seed = 31122_sp
    call sgrnd(seed)

    ! We define some quantities of interest
    n_iterations = 5000_dp ! Number of iterations
    n_bins = 100_dp ! Number of sub-intervals in laminar-zone

    ! Limits of laminar interval
    ! lblr: lower boundary of laminar region
    ! ublr: upper boundary of laminar region
    c = 0.6_dp; lblr = 0._dp; ublr = c

    ! Allocation of arrays to be used
    allocate(M_x(n_bins),x_avg(nbins))
    allocate(prob(n_bins),counter(n_bins))
    allocate(x_bins(n_bins+1_dp))
    
    M_x = 0._dp; x_avg = 0._dp
    counter = 0_dp; prob = 0._dp

    ! Parameters of the map
    eps = [0.01_dp, 0.0001_dp]
    a = [1._dp, 1.1_dp]
    d = [1.1_dp, 1.35_dp]

    ! We set the array of the domain
    x_bins = linspace(lblr,uplr,n_bins+1_dp)

    ! Loop through both set of parameters
    do i = 1,1
        xn = grnd()
        ! Compute the map the desired number of iterations
        do j = 1,n_iterations
            xn1 = map_III_a(xn,eps(i),a(i),d(i))
            ! Fill arrays of probability, counter and x_avg
            do k = 1,n_bins
                if (xn1 >= x_bins(k) .and. xn1 < x_bins(k+1)) then
                    counter(k) = counter(k) + 1_dp
                    x_avg(k) = x_avg(k) + xn1
                endif
            enddo
            xn = xn1
        enddo
    enddo

    ! We procede to compute the global probabilities
    do i = 1,n_bins
        if (counter(i) > 0_dp) then
            x_avg(i) = x_avg(i)/counter(i)
            prob(i) = real(counter(i)/real(n_iterations,dp),dp)
        else if (counter(i) == 0_dp) then
            x_avg(i) = 0._dp
            prob(i) = 0._dp
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

    

    ! We compute the general probability in the laminar interval

    ! probgen will count the number of points in each sub-interval of the laminar region
    ! valgen will sum the values of the points in the sub-intervals of the laminar region

    ! This calculations will be made independently of if the points are
    ! reinjected.

    do i = 1,ns 
        if(y .ge. xi(i)) then
            if(y .lt. xi(i+1)) then
            probgen(i) = probgen(i) + 1.d0
            valgen(i) = valgen(i) + y
            end if
        end if
    end do

    ! Computing of global probability, independently of reinjection

    ! Once we have the number of points in each sub-interval, and the
    ! sum of all values in those sub-intervals, we procede to compute
    ! the general probability of being in a given sub-interval in probgen
    ! and the mean value of the points in the sub-intervals, with the purpose of 
    ! obtaining a smooth function clearly defined in a well defined 
    ! domain (the one that we have imposed).
    do i = 1,ns
        ! First we check if the sub-interval has at least one point
        ! in it, to avoid the numerical errors.
        if(probgen(i) > 0.0) then
        valgen(i) = valgen(i)/probgen(i)  !arithmetic mean of "y" values in each sub-interval of laminar interval
        probgen(i) = probgen(i)/(1.d0*n_iterations) !total general probability in each sub-interval independently of reinjection
        end if

        ! If some interval has zero points, both variables are 
        ! set to zero to avoid the program to blow up.
        if(probgen(i) .eq. 0.0) then
        valgen(i) = 0.d0  
        probgen(i) = 0.d0
        end if

    end do

    ! Compute cumulative probability function in the laminar interval 
    ! This vector acumulates the same values as the mfunagen variable does
    ! so it's of no actual need to have it. The mfungen variable just takes
    ! the values previously acumulated here, so its reduntant too.
    funprogen(1) = probgen(1)

    do i = 2,ns
        funprogen(i) = funprogen(i-1) + probgen(i)
    enddo

    ! Here we define and compute both the numerator and denominator of the
    ! M(x) function, being mfunagen and mfungen the denominator
    ! and vazagen and vazgen the numerator.

    ! Given the nature of the computation, some variables are reduntant, and
    ! the two "methods" of computing the function given by the original code are
    ! actually the same method implemented with virtually no changes so the new
    ! implementation will be dramatically different from this one.

    mfunagen = 0.d0 ! acumulates the total probability (integrates the prob function)
    vazagen = 0.d0 ! integrates the product of the values and the probability acumulation up to that value

    mfungen = 0.d0 ! takes the value of the already acumulated probability in funprogen
    vazgen = 0.d0 ! ! integrates the product of the values and the probability acumulation up to that value

    ! We loop through the laminar interval
    do j = 1,ns

        ! In mfunagen we accumulate (integrate) the general probability in the laminar interval
        ! In vazagen we integrate the product of the varible with the general probability as 
        ! defined in the M(x) function.
        mfunagen = mfunagen + probgen(j)
        vazagen = vazagen + valgen(j)*probgen(j)

        ! If we have points in the given sub-interval, then we procede
        ! to compute, to avoid the numerical errors.
        if (mfunagen .gt. 0.0) then
            ! Function M(x), integrates between the fixed point (0 in this case)
            ! and the superior limit of the laminar interval.
            ! In this line we compute the M(xj) value of M(x), that just integrate bewtween
            ! the fixed point and xj.
            fmpagen(j) = vazagen/mfunagen
        end if
        
        ! If no points are found up to xj, then we assing 0 to the function in this point.
        if (mfunagen .eq. 0.0) then
            fmpagen(j) = 0.d0
        end if

        ! Here we repeat the process above, with a very similar structure.
        mfungen = funprogen(j)
        vazgen = vazgen + valgen(j)*probgen(j)

        ! M(x) is computed in the same way as before.
        if (mfungen .gt. 0.0) then
            fmpgen(j) = vazgen/mfungen
        end if

        if (mfungen .eq. 0.0) then
            fmpgen(j) = 0.d0
        end if
    end do
        



end program Intermittency_type_III_M_prob_comments_Ezequiel