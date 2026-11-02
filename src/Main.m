function Main (Ka,PFc,gam,ecap,EgEc,seed,fp,L,dim)
    rc =0.5; %Radius of Cell
    rg = 0.5;  %Radius of Gel
    PFg=1-PFc;
    T= 10;
    dt=0.01;
    delta=0.2;
                                                                                                                                                
    folderPath=strcat(fp,'/ka=',num2str(Ka),'_gamma=',sprintf('%.2f',(round(gam,2))),'_ecap=',sprintf('%.2f',(round(ecap,2))),'_Pfc=',sprintf('%.1f',(round(PFc,1))),'_EgEc=',sprintf('%.2f',EgEc),'_seed=',sprintf('%03d',seed));
    mkdir(folderPath);
    rng(seed);

    %Calling pack function
    [Nc,Ng] =pack(L,rg,rc,PFc,PFg,dim);
    
    %Calling makebox and makesphere
    initial_r =generate_IC(L,Nc,Ng,rc,rg,dim);

    %Calling evolve trajectory for forces and new coordinate calculation
    evolveTrajectory(initial_r,dt,T,rg,rc,L,Nc,Ng,Ka,gam,folderPath,ecap,delta,EgEc,dim);
end