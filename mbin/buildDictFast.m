function [D] = buildDictFast(fh,dict,model)

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

D0 = zeros(n0^2,nx*ny*nt);

%% loop over

p = 1;
for i=1:ny          % y
    for j = 1:nx    % x
        for k=1:nt  % angle
            D0(:,p) = fh(R(tv(k))*(xz-[xv(j);yv(i)]));
            p = p+1;
        end
    end
end

D = sparse(D0);


end
