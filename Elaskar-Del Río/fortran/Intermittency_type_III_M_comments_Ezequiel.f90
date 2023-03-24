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

    ! Here we detect a reinjected point into the laminar interval and both
    ! store its value and the index of iterations in order to compare it 
    ! to the same number for when it leaves the laminar zone, and compute
    ! the numerical laminar length. Also compute the theoretical
    ! laminar lengths according to Kim 1998 and Elaskar.
    if (x .ge. xmax .or. x .le. xmin) then
        if (y .ge. xmin .and. y .le. xmax) then
          yden = y  !valor de "y" reinyectado en la zona laminar usando como centro de cordendas el punto (dx,dy)
          xden = x  !valor de "x" fuera de la zona laminar desde el cual reingresa "y" a la zona laminar usando como centro de cordendas el punto (dx,dy)
          k = j
          ke = ke + 1
          yd(ke) = y !valor de "y" reinyectado en la zona laminar usando como centro de cordendas el punto (dx,dy)
          write (40,200) xden, yden   ! archivo 40 es "para matematica.txt"
  
          lolate(ke) = (dlog(xint/abs(yden)) - 0.5d0*dlog((aa*xint*xint+epsi)/(aa*yden*yden+epsi))) / epsi  
          ! lolate es la longitud laminar teorica dada por ec.(1) paper Kim de 1998
  
          lolates(ke) = (dlog(xint/abs(yden)) - 0.5d0*dlog((aa*xint*xint+0.5d0*epsi)/(aa*yden*yden+0.5d0*epsi))) / (0.5d0)*epsi  
          ! lolate es la longitud laminar teorica calculada por mi
  
  
        end if
    end if
  
    ! When the point leaves the laminar region, the laminar length is computed.
    if (y .ge. xmax .or. y .le. xmin) then
        if (x .ge. xmin .and. x .le. xmax) then
            yfue = y
            xfue = x  !valor de "x" dentro de la zona laminar desde el cual "y" sale de la zona laminar usando como centro de cordendas el punto (dx,dy)
            l = j
            ll = l - k
            lonlam(ke) = ll	  ! longitud del estado laminar
            write (30,300) xfue, yfue, ll, k, l, yden, yfue   ! archivo 30 es "reinyeccion.txt"
        end if
    end if

    ! Now we define the "domain" of number of laminar lengths in xa, discretized
    ! in bins of length 10 iterations "sua".
    do i = 1,ns+1,sua
        xa(i) = 0.5d0 + (i-1) * 1.d0   ! establece los intervalos en los que 
                                       ! pueden estar las distintas longitudes laminares
    end do
    
    ! Loop through the amount of reinjected numbers
    do j = 1,kt
        ! Loop through the number of laminar lengths defined as domain
        do i = 1,ns,sua
            ! If the current laminar length falls between the domain we stored in vectors
            ! one for the probability computation and another for the average length.
            if(lonlam(j) .ge. xa(i)) then  
    !	      if(lonlam(j) .lt. xa(i+1)) then
                if(lonlam(j) .lt. xa(i+sua)) then
                prolam(i) = prolam(i) + 1.d0  ! probabilidad de la longitud del estado laminar
                longpro(i) = longpro(i) + lonlam(j)
                end if
            end if
        end do
    end do

    ! Once the accumulation is over, we get the avg values of 
    ! laminar lengths for every sub-interval
            
    do i = 1,ns
        if(prolam(i) > 0) then
            longpro(i) = longpro(i)/prolam(i)
        end if
        if(prolam(i) .eq. 0) then
            longpro(i) = 0.d0
        end if	  
    end do

    ! The probability of laminar reinjection is computed and the center of 
    ! the sub intervals is computed too, for the file writing.
    do i = 1,ns,sua 
        prolam(i) = prolam(i)/kt ! probabilidad de la longitud del estado laminar
        ws = (2.d0*i+sua)/2.d0
        !write (90,204) i, prolam(i) ! archivo 90 es "probabilidad longitudes laminares.txt"
        write (90,200) ws, prolam(i)/(1.d0*sua) ! archivo 90 es "probabilidad longitudes laminares.txt"
    end do

    ! Computing of average of reinjected points.
    do j = 1,kt
        do i = 1,ns 
            if(yd(j) .ge. xi(i)) then
                if(yd(j) .lt. xi(i+1)) then
                prob(i) = prob(i) + 1.d0
                val(i) = val(i) + yd(j)  !suma todos los valores de "y" que estan en cada subintervalo
                !longpro(i) = longpro(i) + lonlam(j)
                end if
            end if
        end do
    end do

    ! Here we compute the average of the reinjected points and count
    ! the number of them in every sub-interval
    do i = 1,ns
        if(prob(i) > 0.0) then
            val(i) = val(i)/prob(i)  !promedio aritmetico de los valores de "y" que estan en cada subintervalo
            !longpro(i) = longpro(i)/prob(i) !promedio aritmetico de los valores de "longitud laminar" en cada subintervalo
            prob(i) = prob(i)/(1.d0*kt)
        end if
  
        if(prob(i) .eq. 0.0) then
            val(i) = 0.d0  !promedio de los valores de "y" que estan en cada subintervalo
            prob(i) = 0.d0
        end if
        write (70,200) xi(i), val(i)  ! archivo 70 es "valor medio aritmetico.txt"
      end do
  
    ! Actual normalized probability in interval
    do i = 1,ns
        probr(i) = prob(i)*ns/(xmax-xmin)  !probabilidad real para intervalo xmax-xmin
    end do
    
    ! Array for computing RPD
    funpro(1) = prob(1)

    ! The RPD is the derivative with respect to x of the normalized reinjection
    ! probability, given the fact that is a density.

    ! On the other hand funpro accumulates the probability, being this
    ! the cumulate distribution function of the reinjected points up to that
    ! value of x.
    do i = 2,ns
        dprob(i) = (prob(i) - prob(i-1)) / delta  !funcion densidad de probabilidad
        funpro(i) = funpro(i-1) + prob(i)  !funcion probabilidad en el intervalo (0,i)
    end do

    dprob(1) = dprob(2)


    ! Now we compute the mean laminar length
    lmedia = 0.d0
	lmedia1 = 0.d0
	
!    mns = 2 + (ns/2)

    mns = 2 
    ! Iterate through the laminar interval
	do i = mns-1,ns
        ! If it is the first step, then it's just the value
		if(i .eq. mns-1) then
		  xh = xi(i)
		end if
		! For next intervals we have to substract the already
        ! passed values of lengths in order to have just
        ! the length of the actual interval.
		if(i .ne. mns-1) then
		  xh = xi(i) - xi(mns-1)
		end if
		
!	    lg = (dlog(xint/abs(xh)) - 0.5d0*dlog((aa*xint*xint+epsi)/(aa*xh*xh+epsi))) / epsi  
        ! We use the classic theorical equation for the laminar length
	    lg = (dlog(xint/abs(xh)) - 0.5d0*dlog((aa*(xint**(lambda-1.))+epsi)/(aa*(xh**(lambda-1.))+epsi))) / epsi  
				
        lmedia = lmedia + prob(i) * lg
		lmedia_s = lmedia_s + longpro(i)/ns

!       lmedia = lmedia + prob(i) * lonlam(i); !no se puede utilizar porque hay que calcular 
                                                !lonlam de i, porque lonlam esta definda para 
												!cada punto de reinjeccion
		
		lmedia1 = lmedia1 + lg/(ns+1.d0) 

		write (135,200) xi(i), lmedia	 !funcion longotud media en el intervalo (0,i)

		write (139,200) xi(i), lmedia_s	 !funcion longotud media en el intervalo (0,i) de Sergio

		write (136,200) xi(i), lmedia1	 !funcion longotud media en el intervalo (0,i) con probabilidad uniforme
		
	end do

    !CALCULO DE LA LONGITUD LAMINAR MEDIA ESTADISTICA TEORICA PARA PROBABILIDAD = CTE

	vx = (sqrt(epsi))/xint ! Aproximación teórica
!	lgt = (-0.5d0/epsi)*dlog10(1.d0+vx*vx) + (0.5d0/vx)*(pi-2.d0*datan(vx)+(dlog10(1.d0+vx*vx))/vx) 
	
	lgt = (datan(xint*sqrt(aa/epsi)))/(xint*sqrt(aa*epsi)) !ecuacion (3) paper de Kim de 1998

!   lgts es la longitud media deducida por Sergio 
!	lgts = cte1 * xmax**(1+ae)*((1/epsi)-(aa*(xmax**2.)/(epsi**2.))+(0.5d0*(aa**2.)*(xmax**4.)/(epsi**3.)))/((1.d0+ae)*(3.d0+ae))
	
!   lgte es la longitud media deducida por Ezequiel
 	lgte = (0.5d0*cte1*pi/(aa*(ae+1))) * ((aa/epsi)**(0.5*(1.d0-ae))) * datan(0.5d0*pi*ae)



end program Intermittency_type_III_M_prob_comments_Ezequiel