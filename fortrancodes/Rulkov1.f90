program Rulkov1
    use precision
    use NeuronModels
    implicit none

    integer(dp)     :: i,n_steps
    real(dp)        :: x,y,alfa,sigma,mu,I_n,xy(2)

    open(11,file='Rulkov_1.dat',status='replace')

    alfa = 6._dp; sigma = -1.3_dp; mu = 0.001_dp; I_n = 0._dp

    n_steps = 2000_dp

    x = -1._dp; y = -4._dp

    do i = 1, n_steps
        xy = Rulkov(x,y,alfa,sigma,mu,I_n)
        write(11,"(3(E16.6))") real(i,dp),xy(1),xy(2)
        x = xy(1); y = xy(2)
    enddo
 
end program Rulkov1