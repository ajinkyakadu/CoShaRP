function [y] = rect(x,mot)

W = mot.W;
s = mot.s;

y = zeros(1,size(x,2));
y(max(abs(W*x))<=s) = 1;

y = y(:);

end

