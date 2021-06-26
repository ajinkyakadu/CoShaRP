function [xCSR] = formImage1shape(A,D,y,zCSR,K,kmax)

n  = size(A,2);
n0 = sqrt(n); 

% boundary image
xBound        = zeros(n0,n0);
xBound(1,:)   = 1;
xBound(end,:) = 1;
xBound(:,1)   = 1;
xBound(:,end) = 1;
xBound        = xBound(:);

%%

[~,maxId] = maxk(zCSR,kmax);
xCSR      = 0*D(:,maxId(1));
nsP       = 0;


for i=1:kmax
    zId   = maxId(i);
    xCSR0 = D(:,zId);
    xCSRp = xCSR + xCSR0;
    
    if (max(xCSRp) <= 1) && (norm(A*xCSRp-y) <= norm(A*xCSR-y)) &&  ...
            (xBound'*xCSRp <= 0) && (nsP < K) && (xCSR0'*xCSR <= 0)
        
        xCSR   = xCSRp;
        nsP    = nsP + 1;
    end
end

end

