function YO2 = my_YO2(c)
global FLAMESTRUCTURE

c(c>1)=1;
c(c<0)=0;

%% Cantera Flame Structure
YO2 = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YO,c);

end