program Chialvo1
    use precision
    use NeuronModels
    implicit none

    integer(dp)     :: i,n_steps
    real(dp)        :: x,y,a,b,c,I_n,xy(2)

    open(13,file='Chialvo_1.dat',status='replace')

    a = 0.89_dp; b = 0.6_dp; c = 0.28_dp; I_n = 0.04_dp

    n_steps = 500_dp

    x = 0._dp; y = 0._dp

    do i = 1, n_steps
        xy = Chialvo(x,y,a,b,c,I_n)
        write(13,"(3(E16.6))") real(i,dp),xy(1),xy(2)
        x = xy(1); y = xy(2)
    enddo
 
end program Chialvo1