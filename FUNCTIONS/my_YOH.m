function YOH = my_YOH(c)
global FLAMESTRUCTURE

c(c>1)=1;
c(c<0)=0;

%% Cantera Flame Structure
YOH = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YOH,c);

end