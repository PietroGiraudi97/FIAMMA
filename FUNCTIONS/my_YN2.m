function YN2 = my_YN2(c)
global FLAMESTRUCTURE

c(c>1)=1;
c(c<0)=0;

%% Cantera Flame Structure
YN2 = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YN,c);

end