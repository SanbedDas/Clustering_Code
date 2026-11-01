function[Fij] = calculate_hertzforce(rv,r1,r2)
    if rv>r1+r2
        Fij = 0;
    else
         Fij = (r1+r2-rv)^1.5*((r1*r2)/(r1+r2))^0.5;
end

            












     
        
