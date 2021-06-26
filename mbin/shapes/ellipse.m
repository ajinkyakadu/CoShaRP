function [y] = ellipse(x,mot)

W = mot.W;
s = mot.s;

y = zeros(1,size(x,2));
y(sum((W*x).^2,1)<=s^2) = 1;

y = y(:);

end

