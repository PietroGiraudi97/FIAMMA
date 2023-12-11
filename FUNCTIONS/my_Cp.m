function Cp = my_Cp(c)
global FLAMESTRUCTURE

c(c>1)=1;
c(c<0)=0;

%% Cantera Flame Structure
Cp = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.Cp,c);

end