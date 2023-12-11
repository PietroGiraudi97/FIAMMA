function Q = computeHRR(F,U,t,x,z)
global PROBLEMDATA
%x = MESH.xx;
%z = MESH.zz;

%Function to compute the heat release rate
[Nz,Nx] = size(x);
dxx = [zeros(Nz,1) diff(x,1,2)];
dzz = [zeros(1,Nx); diff(z,1,1)];

for i = 1:length(t)
    U1 = U(:,:,i);
    F1 = F(:,:,i);
    %% HRR for CH4-Air combustion
    % [OH][CH2O] (molar fraction)
    %q = (my_YOH(F1).*my_W(F1)./17).*(my_YCH2O(F1).*my_W(F1)./30);
    % [OH][CH2O] (mass fraction)
    %q = my_YOH(F1).*my_YCH2O(F1);


    %% HRR for H2-Air combustion
    % [OH] (molar fraction)
    %q = (my_YOH(F1).*my_W(F1)./0.017);
    % [OH] (mass fraction)
    %q = my_YOH(F1);

    %% HRR based on temperature
    if i == 1
        E1 = my_rho(F1).*my_Cp(F1).*my_T(F1);
        q = U1.*dz(E1,z);
    else
        F0 = F(:,:,i-1);
        E0 = my_rho(F0).*my_Cp(F0).*my_T(F0);
        E1 = my_rho(F1).*my_Cp(F1).*my_T(F1);
        q = (E1-E0)./(t(i)-t(i-1))+U1.*dz(E1,z);
    end

    %Q(i) = sum((q).*dxx.*dzz,"all");
    Q(i) = sum((q).*2.*pi.*(x+dxx/2).*dxx.*dzz,"all");
    %% 
    %Q(i) = computeSurfaceArea(F1,x,z,FLAMESTRUCTURE.Z_st);
end
Q = smoothdata(Q);
end