function y = my_drho(c)
global FLAMESTRUCTURE PROBLEMDATA

c(c>1)=1;
c(c<0)=0;

z = linspace(0,1);
rho = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.rho,z);
drho = diff(rho)./diff(z);
drho = [drho(1) drho];

y = interp1(z,drho,c);

end