function mu = my_mu(c)
global FLAMESTRUCTURE

c(c>1)=1;
c(c<0)=0;

%% Cantera Flame Structure
mu = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.mu,c);

end