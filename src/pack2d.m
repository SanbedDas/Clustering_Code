function [Nc,Ng] = pack2d(L,rg,rc,PFc,PFg)

%function to automate to find out number of particles
Nc = round((PFc)*((L^2)/(pi*rc^2))); %Number of Cells
Ng = round((PFg)*((L^2)/(pi*rg^2))); %Number of Gels

end