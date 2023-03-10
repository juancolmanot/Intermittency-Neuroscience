program CNV1
    use precision
    use NeuronModels
    implicit none

    integer(dp)     :: i,n_steps
    real(dp)        :: x,y,m0,m1,a,beta,eps,d,J,xy(2)

    open(12,file='CNV_1.dat',status='replace')

    m0 = 0.864_dp; m1 = 0.65_dp; a = 0.2_dp; d = 0.4_dp
    beta = 0.4_dp; eps = 0.002_dp; J = 0.13_dp

    n_steps = 2000_dp

    x = 0._dp; y = 0._dp

    do i = 1, n_steps
        xy = CNV(x,y,m0,m1,a,beta,eps,d,J)
        write(12,"(3(E16.6))") real(i,dp),xy(1),xy(2)
        x = xy(1); y = xy(2)
    enddo
 
end program CNV1
