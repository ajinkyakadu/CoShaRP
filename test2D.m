% test script for 2D image model

clc; clearvars; close all;

% add the required function files
addpath(genpath([pwd '/mbin/']));

% random stream
s = RandStream('mt19937ar','Seed',10);
RandStream.setGlobalStream(s);

% results directory
resDir = [pwd '/results/test2D/'];
if ~exist(resDir, 'dir'), mkdir(resDir); end


%% 2D model

% setup grid
n0      = 128;
n       = n0^2;
z       = linspace(-0.5,0.5,n0);
x       = z;
[zz,xx] = ndgrid(z,x);
xz      = [xx(:)';zz(:)'];

% model structure
model.n  = n;
model.n0 = n0;
model.z  = z;
model.x  = x;
model.xz = xz;

%% measurement matrix (single-shot)

theta = [180];                          % angle
pA    = floor(n0^2/4);                  % number of fan-beam rays
A     = fanlineartomo(n0,theta,pA,4,4); % measurement matrix
A     = A(any(A,2),:);                  % remove zero rows

% size
[m,n] = size(A);

%% dictionary

nBd     = floor((0.2/2)*n0);
dict.xv = x(nBd:4:end-nBd);
dict.yv = z(nBd:4:end-nBd);
dict.tv = 0;

rad = 0.1;
f   = @(x) circle(x,rad);
D   = buildDictFast(f,dict,model);

fprintf('Dictionary D: %d x %d \n',size(D));


%% build image

% number of shapes
nshape = 4;

%%% boundary image
xBound = zeros(n0,n0);
xBound(1,:) = 1;xBound(end,:) = 1;xBound(:,1) = 1;xBound(:,end) = 1;
xBound = xBound(:);

% initialize
xTrue = zeros(n0^2,1);
zTrue = zeros(size(D,2),1);

% loop
nIter = 0;
while nIter < nshape(1)
    zId = randperm(size(D,2),1);
    xP  = D(:,zId);
    xTrueP = xTrue + xP;
    if (xTrue'*xP <= 0) && (xBound'*xTrueP <= 0)
        xTrue = xTrueP;
        zTrue(zId) = 1;
        nIter = nIter + 1;
    end
end

%% measurements

y = A*xTrue;


%% CoShaRP

K  = sum(nshape);

opt.MaxIter = 1e5;
opt.progTol = 1e-8;
opt.optTol  = 1e-8;
opt.verbose = 1;

[zCSR,~,hist] = CoShaRP(A,D,y,K,opt);


%% image formation from dictionary coefficients

kmax = length(zCSR);
xCSR = formImage1shape(A,D,y,zCSR,K,kmax);

fig1 =figure(1);
imagesc(reshape(xTrue,n0,n0),[0 1]);axis image;colormap(flipud(hot));
set(gca,'xtick',[],'ytick',[]);
saveas(fig1,[resDir 'true'],'epsc');
saveas(fig1,[resDir 'true'],'fig');
pause(0.001);

fig2 =figure(2);
imagesc(reshape(xCSR,n0,n0),[0 1]);axis image;colormap(flipud(hot));
set(gca,'xtick',[],'ytick',[]);
saveas(fig2,[resDir 'CoShaRP'],'epsc');
saveas(fig2,[resDir 'CoShaRP'],'fig');
pause(0.001);
