function [rnewws] = generate_IC(L,Nc,Ng,rc,rg,dim)

%calling makesphere function
 cells=generate_cells(L,Nc,rc,dim);

%making and assigning the new row vector for types of particles
type = zeros((Nc+Ng),1);

type(1:Nc) = 1;

%initialization of Gel particles
gel = [];
minDistance = rc+rg;

 while size(gel, 1) < Ng
        % Generate a random particle position within the cuboid
        newGel = (rand(1,dim).*L-0.5*L);
        
        % Check distance condition with all existing particles
        if  (all(vecnorm(cells-newGel,2,2) >= minDistance) )
            gel = [gel; newGel];  % Add particle if condition met
        end
 end 
rnewws = [cells;gel];
rnewws = [type,rnewws];
end
