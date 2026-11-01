function Fj = evolve_active_force(Fa,Nc,Ng,Ka,gam,dt,dim)
%what dimension of matrix is required
    eti = randn(Nc,dim);
    etz = zeros(Ng,dim);
    et = [eti;etz];  
    Fj = Fa-((Ka*dt).*Fa)+(gam*(dt)^0.5).*et;
end

 





