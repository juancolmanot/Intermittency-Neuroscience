program RulkovChaos
    use precision
    use ran2mod
    implicit none

    real(dp)                :: xn,yn,xn1,yn1
    real(dp)                :: alfa,beta,sigma,dalfa
    integer(dp)             :: i,j
    integer(dp)             :: n_alfa,n_integration,n_transient,n_regime
    integer(sp)             :: seed
    real(dp), allocatable   :: x(:),y(:)
    real(dp)                :: x0,y0

    !open(10,file='Rulkov_integration.dat',status='replace')
    open(11,file='Rulkov_bifurcation-alfa.dat',status='replace')

    n_alfa = 2500_dp
    dalfa = real(5._dp/n_alfa,dp)
    n_integration = 10000_dp
    n_transient = 9500_dp
    n_regime = n_integration-n_transient

    alfa = 0._dp;beta = 0.005_dp;sigma = beta

    allocate(x(n_regime),y(n_regime))

    do j = 1,n_alfa
        if (mod(j,100) == 0) then
            write(*,*) j,alfa
        end if
        alfa = alfa + dalfa

        seed = 21686_sp

        x0 = ran2(seed)*10._dp-5._dp
        y0 = ran2(seed)*10._dp-5._dp

        xn = x0; yn = y0

        do i = 1,n_integration
            xn1 = yn + alfa*1._dp/(1._dp + xn*xn)
            yn1 = yn - sigma*xn - beta
            !write(10,"(I8,4(E14.4))") i,xn1,yn1,xn,yn
            xn = xn1; yn = yn1
            if (i > n_transient) then
                write(11,"(3(E14.4))") alfa,xn1,yn1
            endif
        enddo

    enddo

    close(10);close(11)

end program RulkovChaos