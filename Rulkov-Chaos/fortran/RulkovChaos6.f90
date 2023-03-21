program RulkovPaper3
    use precision
    use rangens
    use matrixalgebra
    implicit none

    integer(sp)             :: seed1,seed2
    integer(dp)             :: i,j,n_steps,n_transient,n_eps
    real(dp)                :: xn,yn,xn1,yn1,alfa,beta,sigma,g1,g2,e,de

    open(12,file='RulkovChaos6_A.dat',status='replace')

    seed1 = 2152_sp;seed2 = 88633_sp

    alfa = 1.9_dp; beta = 0.005_dp; sigma = beta

    n_steps = 10000_dp; n_transient = 9000_dp

    n_eps = 1000_dp
    e = 0._dp; de = 0.001_dp/real(n_eps,dp)
    do i  = 1,n_eps

        xn = -1.23_dp; yn = -1.95_dp

        do j = 1,n_steps
            g1 = gaussdev(seed1); g2 = gaussdev(seed2)
            xn1 = alfa*(1._dp/(1._dp + xn*xn)) + yn + e*g1
            yn1 = yn - sigma*xn - beta + e*g2
            xn = xn1; yn = yn1
            if (j > n_transient) then
                write(12,"(3(E18.8))") e,xn,yn
            endif
        enddo
        e = e + de
    enddo
 
end program RulkovPaper3