function rfinal = evolveTrajectory(initial_r,dt,T,rg,rc,L,Nc,Ng,Ka,gam,folderPath,ecap,delta,dim)

rtime = initial_r(:,1:dim);

iter = 0;

type = initial_r(:,dim+1);

Fprev = randn(Nc,dim)*gam;

Fprev = [Fprev;zeros(Ng,dim)];

for t=0:dt:T

    % tic

    rwt = [type,rtime];

    % if (t==T)
        make_file(rwt,iter,folderPath,dim);
    % end

    Fpassive = forces(rtime,type,rg,rc,L,ecap,delta,dim);

    Factive = evolve_active_force(Fprev,Nc,Ng,Ka,gam,dt,dim);

    rtime = rtime + (Fpassive+Factive).*dt;

    [rn] = check_cond(rtime,L);  

    rtime = rn;

    iter = iter+1;

    disp(t)

    Fprev = Factive;
    % toc
end
   rfinal=[type rtime];
end
