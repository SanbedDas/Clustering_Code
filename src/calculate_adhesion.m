function F = calculate_adhesion(ecap, delta, rv, rc)

    if rv > (2 * rc) && rv <= (2 * rc + delta)
        F = -ecap * (rv - 2 * rc) / delta;
    elseif rv > (2 * rc + delta) && rv <= 2 * (rc + delta)
        F = -ecap + (ecap * (rv - delta - 2 * rc) / delta);
    else
        F = 0; % Ensure F = 0 
    end
end