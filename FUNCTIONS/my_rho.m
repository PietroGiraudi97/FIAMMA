function rho = my_rho(c)
global FLAMESTRUCTURE

c(c>1)=1;
c(c<0)=0;

%% Cantera Flame Structure
rho = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.rho,c);

end