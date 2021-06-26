function [xCSR] = formImage4shapes(A,D,y,zCSR,K,kmax,nshape,lenD)

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
nsI       = 0*nshape;


for i=1:kmax
    zId   = maxId(i);
    xCSR0 = D(:,zId);
    xCSRp = xCSR + xCSR0;
    
    if (max(xCSRp) <= 1) && (norm(A*xCSRp-y) <= norm(A*xCSR-y)) &&  ...
            (xBound'*xCSRp <= 0) && (nsP < K) && (xCSR0'*xCSR <= 0)
        
        % check for shape 1
        if (zId <= lenD(1)) && (nsI(1) < nshape(1))
            xCSR   = xCSRp;
            nsP    = nsP + 1;
            nsI(1) = nsI(1) + 1;
        end
        
        % check for shape 2
        if (zId > lenD(1)) && (zId <= lenD(1)+lenD(2)) && ...
                (nsI(2) < nshape(2))
            xCSR   = xCSRp;
            nsP    = nsP + 1;
            nsI(2) = nsI(2) + 1;
        end
        
        % check for shape 3
        if (zId > lenD(1)+lenD(2)) && (zId <= lenD(1)+lenD(2)+lenD(3)) ...
                && (nsI(3) < nshape(3))
            xCSR   = xCSRp;
            nsP    = nsP + 1;
            nsI(3) = nsI(3) + 1;
        end
        
        % check for shape 4
        if (zId > lenD(1)+lenD(2)+lenD(3))  && (nsI(4) < nshape(4))
            xCSR   = xCSRp;
            nsP    = nsP + 1;
            nsI(4) = nsI(4) + 1;
        end
        
    end
end

end

