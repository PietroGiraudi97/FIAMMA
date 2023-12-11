function Area = computeSurfaceArea(F,x,z,Z_st)

options = optimset('Display','off');
i=1;
while F(i,1)>Z_st
    i1 = max(find(F(i,:)>Z_st));
    i2 = i1+1;
    fun = @(xq) (F(i,i2)-F(i,i1))/(x(i,i2)-x(i,i1))*xq+F(i,i1)-Z_st;
    x_flame(i) = fzero(fun,(x(i,i1)+x(i,i2))/2,options)+x(i,i1);
    z_flame(i) = z(i,1);
    i = i+1;
end
fun = @(zq) interp1(z(:,1),F(:,1),zq)-Z_st;
x_flame(i) = 0;
z_flame(i) = fzero(fun,mean(z(:,1)),options);

x_flame(isnan(x_flame)) = 0;
z_flame(isnan(z_flame)) = 0;

dx = diff(x_flame);
dz = diff(z_flame);
dA = pi.*(x_flame(1:end-1)+x_flame(2:end)).*sqrt(dx.^2+dz.^2);
%dA = sqrt(dx.^2+dz.^2);

Area = sum(dA,'all');

end