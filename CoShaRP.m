function [zf,uf,hist] = CoShaRP(A,D,y,K,opt)
% CoShaRP provides shape coefficients by solving a convex program
%
% solves the following optimization problem:
%  
%       minimize    || A*D*z - y ||_2 
%       subject to  sum(z) == K, 0 <= z_i <= 1
%
%  where A is a tomography matrix, D is a shape dictionary, y are the
%  tomographic measurements, z are the shape coefficients, and K is the
%  total number of shapes
%   
% Usage:
%   [z] = CoShaRP(A,D,y,K);
% 
% Example:
%   n = 128^2;      % image size
%   m = 1024;       % measurements
%   p = 10000;      % dictionary elements
%   K = 10;         % number of shapes
%   A = tomographyMatrix(m,n);
%   D = dictionaryMatrix(n,p);
%   zTrue = zeros(p,1);
%   zTrue(randperm(p,K),1) = 1;
%   xTrue = D*zTrue;
%   y = A*xTrue;
%   zCSR = CoShaRP(A,D,y,K);
% 
% Input:
%   A : tomography matrix of size m x n 
%   D : dictionary matrix of size n x p
%   y : tomographic measurements of size m x 1
%   K : number of shapes
%   opt : structure with following options
%       - MaxIter : maximum number of iterations
%       - optTol  : tolerance for optimality criterion
%       - progTol : tolerance for progress of iterates
%       - fTol    : tolerance for function value
%       - verbose : indicator to print the iterates
%       - stochUp : indicator to update iterates stochastically
% 
% Output:
%   zf : final value of z variable (primal)
%   uf : final value of dual variable 
%   hist : history (structure) consisting of following
%       - f  : function values at every iterates
%       - pr : progress of iterates
%       - opt: optimality value at every iterate
%
% Created by: 
%   Ajinkya Kadu
%   Centrum Wiskunde & Informatica, Amsterdam


if nargin < 5
    opt = [];
end

progTol  = getoptions(opt,'progTol',1e-8);
optTol   = getoptions(opt,'optTol',1e-8);
fTol     = getoptions(opt,'fTol',1e-8);
MaxIter  = getoptions(opt,'MaxIter',1e6);
verbose  = getoptions(opt,'verbose',0);
stochUp  = getoptions(opt,'stochUp',1);     % stochastic update 

%% pre-processing

[m,n] = size(A);
[n,p] = size(D);

AD    = A*D;            % store the total matrix
eD    = normest(AD);    % compute norm of the matrix
AD    = AD/eD;          % scale matrix by its norm
yD    = y/eD;           % scale corresponding measurments by norm of matrix 

% acceleration factor
gamma = 0.95/sqrt(2);

%% initialize

z = zeros(p,1);
u = zeros(m,1);
v = zeros(p,1);

%% main loop

for i=1:MaxIter
    
    % update z
    zprev = z;
    z = zprev - gamma*(AD'*u+v);
    
    % update u
    dz = zprev - 2*z;
    uprev = u;
    
    if stochUp      % stochastic update
        idx = randperm(m,10);
        u(idx)  = proxfs(uprev(idx) - gamma*(AD(idx,:)*dz),gamma,yD(idx));
    else
        u  = proxfs(uprev - gamma*(AD*dz),gamma,yD);
    end
    
    % update v
    vprev = v;
    v = proxgs(vprev - gamma*dz,gamma,K);
    
    % check optimality
    hist.pr(i) = norm(z-zprev) + norm(u-uprev) + norm(v-vprev);
    hist.f(i)  = norm(AD*z-yD);
    hist.opt(i)= norm(AD'*u+v);
    
    if (hist.pr(i) < progTol) || (hist.opt(i) < optTol) || (hist.f(i) < fTol)
        fprintf('iter %d: function:%2.2e progress:%2.2e opt:%2.2e\n',i,hist.f(i),hist.pr(i),hist.opt(i));
        break;
    end
    
    if verbose && mod(i,floor(MaxIter/10))==0
        fprintf('%5.0d \t %.6e \t %.6e \t %.6e \n',i,hist.f(i),...
            hist.opt(i),hist.pr(i));
    end
    
end
%% 

zf = z;
uf = u;

end

function [z] = proxgs(x,gamma,K)
% proximal for dual of K-simplex constraints

z0 = proxg(x/gamma,1/gamma,K);
z = x - gamma*z0;
end

function [z,fc] = proxg(x,gamma,K)
% projection onto K-simplex (x^1 = K, 0 <= x <= 1 )

fh = @(mu) sum(min(max(x-mu,0),1)) - K;

c = fzero(fh,0);
fc= fh(c);

z = min(max(x-c,0),1);

end

function [z] = proxfs(x,gamma,y)
% proximal for dual of \ell_2 norm

z = x - gamma*proxf(x/gamma,1/gamma,y);
end

function [z] = proxf(x,gamma,y)
% proximal for \ell_2 norm (i.e., f(x) = ||x - y||_2)

normxy = norm(x-y);
z = (1 - gamma/max(normxy,gamma))*normxy + y;
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
