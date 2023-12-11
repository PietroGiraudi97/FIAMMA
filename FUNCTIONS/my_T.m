function t = my_T(c)
global FLAMESTRUCTURE

c(c>1)=1;
c(c<0)=0;

% %% Cantera Flame Structure
t = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.T,c);

end