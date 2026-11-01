function [particles] = generate_cells(L,Nc,rc,dim)

 particles = [];  % Store particle positions
 minDistance = 2 * rc;  % Minimum distance between particles

    % Generate particles
    while size(particles, 1) < Nc
        % Genergate a random particle position within the cuboid
        newParticle = (rand(1,dim).*(L)-0.5*L);
        
        % Check distance condition with all existing particles
        if isempty(particles) || all(vecnorm(particles-newParticle,2,2) >= minDistance)
            particles = [particles; newParticle];  % Add particle if condition met
        end
    end
end





