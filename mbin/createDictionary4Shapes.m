function [Dfull,lenD,Di] = createDictionary4Shapes(x,z,n0,model)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

nBd  = floor((0.2/2)*n0);
xv   = x(nBd:4:end-nBd);
yv   = z(nBd:4:end-nBd);
tv   = linspace(0,1,5)*pi;
tv   = tv(1:end-1);

dict.xv = xv;
dict.yv = yv;
dict.tv = tv;

%% shape 1

S1.W  = [1 0;0 0.4];
S1.s  = 0.06;
S1.f  = @(x) ellipse(x,S1);
D1    = buildDictSlow(S1.f,dict,model);
D1    = 0.3*D1;

fprintf('Dictionary D1: %d x %d \n',size(D1));

%% shape 2

S2.W  = [1 0;0 1];
S2.s  = 0.1;
S2.f  = @(x) ellipse(x,S2);
dict.tv= 0;
D2    = buildDictFast(S2.f,dict,model);
D2    = 0.5*D2;

fprintf('Dictionary D2: %d x %d \n',size(D2));


%% shape  3

S3.W  = [1 0.25;0.25 1];
S3.s  = 0.1;
S3.f  = @(x) rect(x,S3);
dict.tv= tv;
D3    = buildDictSlow(S3.f,dict,model);

fprintf('Dictionary D3: %d x %d \n',size(D3));


%% shape 4

S4.W  = [1 0;0 1];
S4.s  = 0.05;
S4.f  = @(x) rect(x,S4); % ellipse(x,motS);
dict.tv= 0;
D4    = buildDictFast(S4.f,dict,model);
D4    = 0.8*D4;

fprintf('Dictionary D4: %d x %d \n',size(D4));

%% full dictionary 

Dfull = [D1 D2 D3 D4];

%%% lengths
lenD  = [size(D1,2) size(D2,2) size(D3,2) size(D4,2)];



end

