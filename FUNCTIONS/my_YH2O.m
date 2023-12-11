function YH2O = my_YH2O(c)
global FLAMESTRUCTURE

c(c>1)=1;
c(c<0)=0;

%% Cantera Flame Structure
YH2O = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YP,c);

end