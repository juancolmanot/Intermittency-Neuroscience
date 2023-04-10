program Intermittency_type_III_laminar_test
    use precision
    use mtmod
    use maps
    use matrixalgebra
    use intermittency_type_III_DR_E_D_2011
    implicit none

    integer(sp)             :: seed
    integer(dp)             :: i,j,k
    integer(dp)             :: n_bins,n_iterations,n_reinjected,n_lengths
    real(dp)                :: xi,l,c,a,b,eps,alfa,prob_l,max_length,xn,xn1
    real(dp)                :: lblr,ublr,lengths_ratio,l_media1,l_media2,xh,lg
    real(dp), allocatable   :: x_reinjected(:),laminar_length(:)
    real(dp), allocatable   :: laminar_theoric(:),l_bins(:)
    real(dp), allocatable   :: prob_laminar(:),l_prob(:)
    real(dp), allocatable   :: x_bins(:),prob_reinjection(:),val_reinjection(:)

    open(30, file='datafiles/Intermittency_type_III_laminar_test_1.dat', status='replace')
    open(31, file='datafiles/Intermittency_type_III_laminar_test_2.dat', status='replace')
    open(32, file='datafiles/Intermittency_type_III_laminar_test_3.dat', status='replace')
    open(33, file='datafiles/Intermittency_type_III_laminar_test_4.dat', status='replace')
    open(34, file='datafiles/Intermittency_type_III_laminar_test_5.dat', status='replace')
    
    seed = 31123_sp
    call sgrnd(seed)
    
    a = 1.035_dp; b = 1.05_dp; eps = 0.001_dp
    c = 0.6_dp
    alfa = 0.5_dp
    xi = 0._dp

    lblr = 0._dp; ublr = c

    n_reinjected = 55000_dp
    n_iterations = 0_dp
    n_bins = 200_dp
    n_lengths = 50_dp
    max_length = 150._dp
    lengths_ratio = max_length / real(n_lengths, dp)

    allocate(laminar_theoric(n_reinjected),l_bins(n_lengths+1))
    allocate(x_bins(n_bins+1),prob_reinjection(n_bins),val_reinjection(n_bins))
    allocate(x_reinjected(n_reinjected),laminar_length(n_reinjected))
    allocate(l_prob(n_lengths),prob_laminar(n_lengths))
    x_bins = linspace(lblr, ublr, n_bins + 1_dp)
    l_bins = linspace(1._dp, max_length, n_lengths + 1_dp)
    x_reinjected = 0._dp; laminar_length = 0._dp
    prob_reinjection = 0._dp; val_reinjection = 0._dp; laminar_theoric = 0._dp

    i = 0_dp; j = 0_dp
    xn = grnd()
    do while (i < n_reinjected)
        n_iterations = n_iterations + 1_dp
        xn1 = map_III_a(xn, eps, a, b)
        if (abs(xn1) > abs(lblr) .and. abs(xn1) <= abs(ublr) .and. abs(xn) > abs(ublr)) then
            j = n_iterations
            i = i + 1_dp
            x_reinjected(i) = xn1
            laminar_theoric(i) = laminarlength(xn1, ublr, a, eps)
            write(30,"(I8,2(E14.4))") i, xn1, laminar_theoric(i)
            ! Computing general probabilities
            do k = 1,n_bins
                if (x_reinjected(i) >= x_bins(k) .and. x_reinjected(i) < x_bins(k+1)) then
                    prob_reinjection(k) = prob_reinjection(k) + 1._dp
                    val_reinjection(k) = val_reinjection(k) + xn1
                endif
            enddo
        endif
 
        if (abs(xn) > abs(lblr) .and. abs(xn) <= abs(c) .and. abs(xn1) > abs(c) .and. i > 0_dp) then
            laminar_length(i) = n_iterations - j
        endif
        xn = xn1
    enddo

    do i = 1,n_reinjected
        do j = 1,n_lengths
            if (laminar_length(i) >= l_bins(j) .and. laminar_length(i) < l_bins(j + 1)) then
                prob_laminar(j) = prob_laminar(j) + 1._dp
                l_prob(j) = l_prob(j) + laminar_length(i)
            endif
        enddo
    enddo

    do i = 1,n_lengths
        if (prob_laminar(i) > 0._dp) then
            l_prob(i) = l_prob(i) / prob_laminar(i)
        else if (prob_laminar(i) == 0._dp) then
            l_prob(i) = 0._dp
        endif
        l_prob(i) = l_prob(i) / (real(n_reinjected, dp) * lengths_ratio)
        ! write(*,"(3(E14.4))") l_bins(i),prob_laminar(i)/real(n_reinjected,dp),l_prob(i)
        write(31,"(3(E14.4))") l_bins(i),prob_laminar(i)/real(n_reinjected,dp),l_prob(i)
    enddo

    l_media1 = 0._dp
        
    do i = 1,n_lengths
        l_media1 = l_media1 + prob_laminar(i)*0.5_dp*(l_bins(i) + l_bins(i + 1))
        write(32,"(2(E14.4))") l_bins(i),l_media1
    enddo    

    l_media1= 0._dp; l_media2 = 0._dp

    do i = 2,n_bins
        xh = x_bins(i) - x_bins(i - 1)

        lg = laminarlength(xn1, ublr, a, eps)
        l_media1 = l_media1 + prob_reinjection(i) * lg
    
        !l_media2 = l_media2 + l_prob(i)/real(n_bins, dp)

        write(33,"(2(E14.4))") x_bins(i),l_media1!,l_media2

    enddo

    deallocate(laminar_theoric,l_bins)
    deallocate(x_bins,prob_reinjection,val_reinjection)
    deallocate(x_reinjected,laminar_length)

    close(30)
    close(31)
    close(32)
    close(33)
    close(34)

end program Intermittency_type_III_laminar_test