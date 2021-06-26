function [D] = buildDictSlow(fh,dict,model)

n0 = model.n0; 
xz = model.xz;

xv = dict.xv;
yv = dict.yv;
tv = dict.tv;

R = @(t) [cos(t) -sin(t);sin(t) cos(t)];

%% initialize dictionary
nx = length(xv);
ny = length(yv);
nt = length(tv);

D  = sparse(n0^2,0);
D0 = zeros(n0^2,nx*nt);

%% loop over

for i=1:ny          % y
    p = 1;
    for j = 1:nx    % x
        for k=1:nt  % angle
            D0(:,p) = fh(R(tv(k))*(xz-[xv(j);yv(i)]));
            p = p+1;
        end
    end
    D = [D sparse(D0)];
end

end
