program RulkovPaper3
    use precision
    use rangens
    use matrixalgebra
    implicit none

    integer(sp)             :: seed1,seed2
    integer(dp)             :: i,j,n_steps,n_transient
    real(dp)                :: xn,yn,xn1,yn1,alfa,beta,sigma,g1,g2
    real(dp), allocatable   :: e(:)

    open(12,file='RulkovChaos5_A.dat',status='replace')

    seed1 = 2152_sp;seed2 = 88633_sp

    alfa = 1.9_dp; beta = 0.005_dp; sigma = beta

    allocate(e(2))

    e = [0.0005_dp, 0.0008_dp]

    n_steps = 47000_dp; n_transient = 0_dp
    
    do i  = 1,2
        xn = -1.23_dp; yn = -1.95_dp

        do j = 1,n_steps
            g1 = gaussdev(seed1); g2 = gaussdev(seed2)
            xn1 = alfa*(1._dp/(1._dp + xn*xn)) + yn + e(i)*g1
            yn1 = yn - sigma*xn - beta + e(i)*g2
            xn = xn1; yn = yn1
            if (j > n_transient) then
                write(12,"(3(E18.8))") real(j,dp),xn,yn
            endif
        enddo
    enddo
 
end program RulkovPaper3