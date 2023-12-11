function YH2 = my_YH2(c)
global FLAMESTRUCTURE

c(c>1)=1;
c(c<0)=0;

%% Cantera Flame Structure
YH2 = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YF,c);

end