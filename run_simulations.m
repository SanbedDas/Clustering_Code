tic;
clc;
clear;
fp='outputs_L_50_Gam_Ecap_scan_Phi_c_0_3';
pfc=0.3;
gam=0:0.1:1;
ecap=0:0.1:1;
Ka=1;
L=50;
dim=2;
seed=1:10;
[A, B, C]=ndgrid(gam,ecap,seed);
params=[A(:), B(:), C(:)];

addpath src plt;
maxNumCompThreads(2);  % Threads per worker
parpool(100);
parfor (i=1:size(params,1))
    Main (Ka,pfc, params(i,1), params(i,2), params(i,3),fp,L,dim);
end
delete(gcp("nocreate"));
toc;