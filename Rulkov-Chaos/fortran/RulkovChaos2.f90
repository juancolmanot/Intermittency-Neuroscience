program RulkovPaper2
    use precision
    use mtmod
    use matrixalgebra
    implicit none

    integer(sp)             :: seed
    integer(dp)             :: i,j,n_steps,n_transient
    real(dp)                :: xn,yn,xn1,yn1,beta,sigma
    real(dp), allocatable   :: alfa(:),x0(:,:)

    open(12,file='RulkovChaos2_A.dat',status='replace')

    seed = 2152_sp
    call sgrnd(seed)

    beta = 0.005_dp; sigma = beta

    alfa = [1.9_dp, 1.98_dp]

    n_steps = 500_dp; n_transient = 0_dp!900_dp

    allocate(x0(2,2))

    x0(1,1) = -1.2488_dp; x0(1,2) = -1.9438_dp
    x0(2,1) = -1.2488_dp; x0(2,2) = -1.9467_dp

    do i  = 1,2
        xn = x0(i,1); yn = x0(i,2)

        do j = 1,n_steps
            xn1 = alfa(1)*(1._dp/(1._dp + xn*xn)) + yn
            yn1 = yn - sigma*xn - beta
            xn = xn1; yn = yn1
            if (j > n_transient) then
                write(12,"(2(E18.8))") xn,yn
            endif
        enddo
    enddo
 
end program RulkovPaper2