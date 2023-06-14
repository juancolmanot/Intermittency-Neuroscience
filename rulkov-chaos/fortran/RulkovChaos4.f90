program RulkovPaper3
    use precision
    use mtmod
    use matrixalgebra
    implicit none

    integer(sp)             :: seed
    integer(dp)             :: i,j,n_steps,n_transient
    real(dp)                :: xn,yn,xn1,yn1,beta,sigma
    real(dp), allocatable   :: alfa(:)

    open(12,file='RulkovChaos4_A.dat',status='replace')

    seed = 2152_sp
    call sgrnd(seed)

    beta = 0.005_dp; sigma = beta

    alfa = [1.994_dp, 1.995_dp, 1.99527_dp, 1.99528_dp, 1.996_dp]

    n_steps = 10000_dp; n_transient = 5000_dp


    
    do i  = 5,1,-1
        xn = -1.245_dp; yn = -1.98_dp

        do j = 1,n_steps
            xn1 = alfa(i)*(1._dp/(1._dp + xn*xn)) + yn
            yn1 = yn - sigma*xn - beta
            xn = xn1; yn = yn1
            if (j > n_transient) then
                write(12,"(2(E18.8))") xn,yn
            endif
        enddo
    enddo
 
end program RulkovPaper3