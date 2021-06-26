function [xf,uf,hist] = CoShaRP(A,D,y,K,opt)


if nargin < 5
    opt = [];
end

progTol  = getoptions(opt,'progTol',1e-8);
optTol   = getoptions(opt,'optTol',1e-8);
MaxIter  = getoptions(opt,'MaxIter',1e6);
verbose  = getoptions(opt,'verbose',0);

%% pre-processing

[m,n] = size(A);
[n,p] = size(D);

AD = A*D;
eD = normest(AD);
AD = AD/eD;
yD = y/eD;

gamma = 0.95/sqrt(2);

%% initialize

x = zeros(p,1);
u = zeros(m,1);
v = zeros(p,1);

%% main loop

for i=1:MaxIter
    
    % update x
    xprev = x;
    x = xprev - gamma*(AD'*u+v);
    
    % update u
    dx = xprev - 2*x;
    uprev = u;
    % u  = proxfs(uprev - gamma*(AD*dx),gamma,yD);
    idx = randperm(m,1);
    u(idx)  = proxfs(uprev(idx) - gamma*(AD(idx,:)*dx),gamma,yD(idx));
    
    % update v
    vprev = v;
    v = proxgs(vprev - gamma*dx,gamma,K);
    
    % check optimality
    hist.pr(i) = norm(x-xprev) + norm(u-uprev) + norm(v-vprev);
    hist.f(i)  = 0.5*norm(AD*x-yD)^2;
    hist.opt(i)= norm(AD'*u+v);
    
    if (hist.pr(i) < progTol) || (hist.opt(i) < optTol)
        fprintf('iter %d: progress:%f, opt:%f\n',i,hist.pr(i),hist.opt(i));
        break;
    end
    
    if verbose && mod(i,floor(MaxIter/10))==0
        fprintf('%5.0d \t %.6e \t %.6e \t %.6e \n',i,hist.f(i),...
            hist.opt(i),hist.pr(i));
    end
    
end
%% 

xf = x;
uf = u;

end

function [z] = proxgs(x,gamma,K)
    z0 = proxg(x/gamma,1/gamma,K);
    z = x - gamma*z0;
end

function [z,fc] = proxg(x,gamma,K)
% projection onto x^1 = K, 0 <= x <= 1 

fh = @(mu) sum(min(max(x-mu,0),1)) - K;

c = fzero(fh,0);
fc= fh(c);

z = min(max(x-c,0),1);

end

function [z] = proxfs(x,gamma,y)
    % z = (x - gamma*y)/(1+gamma);
    z = x - gamma*proxf(x/gamma,1/gamma,y);
end

function [z] = proxf(x,gamma,y)

z = (1 - gamma/max(norm(x-y),gamma))*norm(x-y) + y;
end


function v = getoptions(options, name, v, mandatory)

% getoptions - retrieve options parameter



if nargin<4
    mandatory = 0;
end

if isfield(options, name)
    v = eval(['options.' name ';']);
elseif mandatory
    error(['You have to provide options.' name '.']);
end 
end
