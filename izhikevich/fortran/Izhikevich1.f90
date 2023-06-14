program Izhikevich1
    use precision
    use NeuronModels
    implicit none

    integer(dp)     :: i,j,n_steps
    real(dp)        :: u,v,a,b,c,d,I_n,uv(2)

    open(10,file='Izhikevich_1.dat',status='replace')

    a = 0.02_dp; b = 0.25_dp; c = -55._dp; d = 0._dp; I_n = -0.8_dp

    n_steps = 1000_dp

    u = -13._dp; v = 0._dp

    do j = 1, n_steps
        uv = Izhikevich(u,v,a,b,c,d,I_n)
        write(10,"(3(E16.6))") real(j,dp),uv(1),uv(2)
        u = uv(1); v = uv(2)
    enddo
 
end program Izhikevich1