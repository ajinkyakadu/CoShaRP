% test script for 2D image model
% image has 4 different types of shapes
% each shape is repeated multiple types (with different roto-translation)
% consists only CoShaRP results


clc; clearvars; close all;

% add the required function files
addpath(genpath([pwd '/mbin/']));

% random stream
s = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(s);

% results directory
resDir = [pwd '/results/test2D_4shapes/'];
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

[D,lenD] = createDictionary4Shapes(x,z,n0,model);


%% build image

nshape = [4 5 2 6];     % number of shapes

[xTrue,zTrue] = buildImage4Shapes(D,lenD,nshape,n0);

%% measurements

y = A*xTrue;


%% CoShaRP

K  = sum(nshape);   % number of shapes

% optimization options
opt.MaxIter = 1e6;
opt.progTol = 1e-8;
opt.optTol  = 1e-8;
opt.fTol    = 1e-8;
opt.verbose = 1;

[zCSR,~,hist] = CoShaRP(A,D,y,K,opt);


%% image formation from dictionary coefficients

kmax = length(zCSR);
xCSR = formImage4shapes(A,D,y,zCSR,K,kmax,nshape,lenD);

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
