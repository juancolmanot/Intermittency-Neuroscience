program Intermittency_type_III_cobweb
    use precision
    use mtmod
    use maps
    use matrixalgebra

    integer(sp)             :: seed
    integer(dp)             :: i,n_steps,n_xn,n_cobweb
    real(dp)                :: xn,xn1,a,d,eps
    real(dp)                :: x_domain
    real(dp), allocatable   :: xn_map(:),x_cobweb(:,:)

    ! File for writting the results
    open(13,file='Intermittency_type_III_map_F_cobweb.dat',status='replace')
    open(14,file='Intermittency_type_III_trajectory_cobweb.dat',status='replace')

    ! Parameters for the random starting point generation
    seed = 2934_sp
    call sgrnd(seed)

    ! Evolution parameters
    n_steps = 1000_dp

    ! Assing values to the parameters
    eps = 0.01_dp; a = 1._dp; d = 1.05_dp

    ! Construct the domain for the map-F plotting
    n_xn = 200_dp
    x_domain = 1.35_dp
    allocate(xn_map(n_xn + 1))
    xn_map = 0._dp
    xn_map = linspace(-x_domain,x_domain,n_xn + 1_dp)

    ! Initialize x0 value
    xn = grnd()

    do i = 1,n_xn + 1_dp
        xn1 = map_III_a(xn_map(i),eps,a,d)
        write(13,"(2(E14.4))") xn_map(i),xn1
    enddo

    ! Number of points in cobweb
    n_cobweb = 100_dp

    ! Construct matrix for cobweb
    allocate(x_cobweb(2,n_cobweb))
    x_cobweb = 0._dp
    xn = grnd()
    x_cobweb(1,1) = xn
    x_cobweb(2,1) = map_III_a(xn,eps,a,d)

    do i = 2,n_cobweb-1,2
        x_cobweb(1, i) = x_cobweb(2, i - 1)
        x_cobweb(2, i) = x_cobweb(2, i - 1)
        x_cobweb(1, i + 1) = x_cobweb(2, i - 1)
        x_cobweb(2, i + 1) = map_III_a(x_cobweb(2, i - 1), eps, a, d)
    enddo

    do i = 1,n_cobweb
        write(14,"(2(E14.4))") x_cobweb(1,i),x_cobweb(2,i)
    enddo

end program Intermittency_type_III_cobweb