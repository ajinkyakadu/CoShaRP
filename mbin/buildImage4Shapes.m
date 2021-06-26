function [xTrue,zTrue] = buildImage4Shapes(D,lenD,nshape,n0)

% boundary image
xBound = zeros(n0,n0);
xBound(1,:) = 1;xBound(end,:) = 1;xBound(:,1) = 1;xBound(:,end) = 1;
xBound = xBound(:);

xTrue = zeros(n0^2,1);
zTrue = zeros(size(D,2),1);

%% get separate dictionaries

Di{1} = D(:,1:lenD(1));
Di{2} = D(:,lenD(1)+1:lenD(1)+lenD(2));
Di{3} = D(:,lenD(1)+lenD(2)+1:lenD(1)+lenD(2)+lenD(3));
Di{4} = D(:,lenD(1)+lenD(2)+lenD(3)+1:end);

%% shape 1

nIter = 0;
while nIter < nshape(1)
    zId = randperm(lenD(1),1);
    xP  = Di{1}(:,zId);
    xTrueP = xTrue + xP;
    if (xTrue'*xP <= 0) && (xBound'*xTrueP <= 0)
        xTrue = xTrueP;
        zTrue(zId) = 1;
        nIter = nIter + 1;
    end
end


%% shape 2

nIter = 0;
while nIter < nshape(2)
    zId = randperm(lenD(2),1);
    xP  = Di{2}(:,zId);
    xTrueP = xTrue + xP;
    if (xTrue'*xP <= 0) && (xBound'*xTrueP <= 0)
        xTrue = xTrueP;
        zTrue(lenD(1)+zId) = 1;
        nIter = nIter + 1;
    end
end

%% shape 3

nIter = 0;
while nIter < nshape(3)
    zId = randperm(lenD(3),1);
    xP  = Di{3}(:,zId);
    xTrueP = xTrue + xP;
    if (xTrue'*xP <= 0) && (xBound'*xTrueP <= 0)
        xTrue = xTrueP;
        zTrue(lenD(1)+lenD(2)+zId) = 1;
        nIter = nIter + 1;
    end
end

%% shape 4

nIter = 0;
while nIter < nshape(4)
    zId = randperm(lenD(4),1);
    xP  = Di{4}(:,zId);
    xTrueP = xTrue + xP;
    if (xTrue'*xP <= 0) && (xBound'*xTrueP <= 0)
        xTrue = xTrueP;
        zTrue(lenD(1)+lenD(2)+lenD(3)+zId) = 1;
        nIter = nIter + 1;
    end
end

end

