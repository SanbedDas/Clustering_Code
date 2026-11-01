function disp_vec=periodic_displacement(r1,r2,L)
     % Compute the raw displacement between the two positions
    disp_vec = r1 - r2;
    dim=size(r1,2);
    % Apply periodic boundary conditions by shifting displacement to the nearest image
    for i = 1:dim
        % Shift the displacement to lie within [-L/2, L/2]
        if disp_vec(i) > L/2
            disp_vec(i) = disp_vec(i) - L;
        elseif disp_vec(i) < -L/2
            disp_vec(i) = disp_vec(i) + L;
        end
    end
end