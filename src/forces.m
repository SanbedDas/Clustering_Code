function F =  forces(r,rtype,rg,rc,L,ecap,delta,Eg_by_Ec,dim)

N = size(r,1);
F = zeros(N,dim);

for i=1:N
    for j=i+1:N
        rL=periodic_displacement(r(i,:),r(j,:),L);
% Tagging r1 and r2 on basis of type
        if rtype(i)==1  r1 = rc;
        else
            r1 = rg;
        end
        if rtype(j)==1 r2 = rc;
        else
            r2 = rg;
        end
%calling the hertzian force model
        rcap=rL/norm(rL);
        rv=norm(rL);
        f= zeros(2,dim);
        % Calculating the corresponding Hertz Forces for interactiojn among all the particles
        
        if ((rtype(i)==1 && rtype(j)==1))   % Cell-cell    
            [Fij]=calculate_hertzforce(rv,r1,r2);  
            
            f(1,:) = f(1,:)+Fij.*rcap;
            f(2,:) = f(2,:)-Fij.*rcap;
        elseif ((rtype(i)==0 && rtype(j)==0))   %Gel-gel
            [Fij]=Eg_by_Ec*calculate_hertzforce(rv,r1,r2);  
            
            f(1,:) = f(1,:)+Fij.*rcap;
            f(2,:) = f(2,:)-Fij.*rcap;
        else                                %Cell-Gel
            %The HARMONIC Mean
            [Fij]=(2*Eg_by_Ec)/(1+Eg_by_Ec)*calculate_hertzforce(rv,r1,r2);
            
            % The ARITHMETIC Mean
            %[Fij]=((1+Eg_by_Ec)/2)*calculate_hertzforce(rv,r1,r2);   
 
            f(1,:) = f(1,:)+Fij.*rcap;
            f(2,:) = f(2,:)-Fij.*rcap;  
        end

        % Calculate the Adhesion force for the cell-cell particles
        if ((rtype(i)==1 && rtype(j)==1))
        [Fad] = calculate_adhesion(ecap,delta,rv,rc);
        f(1,:) = f(1,:)+Fad.*rcap;
        f(2,:) = f(2,:)-Fad.*rcap;
        end
        F(i,:) = F(i,:)+f(1,:);
        F(j,:) = F(j,:)+f(2,:);
    end
end

