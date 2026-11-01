function [rn] = check_cond(r,L)

    N = size(r,1);
    dim=size(r,2);
    for i=1:N
       for (j=1:dim)
            if (r(i,j)>0.5*L) r(i,j)=r(i,j)-L; end
            if (r(i,j)<-0.5*L) r(i,j)=r(i,j)+L; end
       end
    end
    rn=r;
end


