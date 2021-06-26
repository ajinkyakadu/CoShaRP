function [y] = sphere(x,s)

y = zeros(1,size(x,2));
y(sum(x.^2,1)<=s^2) = 1;

y = y(:);

end

