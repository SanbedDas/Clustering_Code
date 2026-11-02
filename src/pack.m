function [Nc,Ng] = pack(L,rg,rc,PFc,PFg,dim)

%function to automate to find out number of particles
if dim==2
    Nc = round((PFc)*((L^2)/(pi*rc^2))); %Number of Cells (area fraction)
    Ng = round((PFg)*((L^2)/(pi*rg^2))); %Number of Gels
else
    Nc = round((PFc)*((L^3)/((4/3)*pi*rc^3))); %Number of Cells (volume fraction)
    Ng = round((PFg)*((L^3)/((4/3)*pi*rg^3))); %Number of Gels
end

end
