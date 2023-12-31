function dfdz = dz(f,z)

[M,N]=size(f);

dfdz = zeros(M,N);

%First order backward
for i = 1:M
    if i == 1
        dfdz(i,:) = 0;%(f(i,:)-f(i,:))./(z(i+1,:)-z(i,:));
    elseif i == M
        dfdz(i,:) = (f(i,:)-f(i-1,:))./(z(i,:)-z(i-1,:));
    else
        dfdz(i,:) = (f(i,:)-f(i-1,:))./(z(i,:)-z(i-1,:));
    end
end

% %Second order backward
% for i = 1:M
%     if i == 1
%         dfdz(i,:) = 0;%(1/2*f(i,:)-2*f(i,:)+3/2*f(i,:))./(z(i+1,:)-z(i,:));
%     elseif i == 2
%         dfdz(i,:) = (-f(i-1,:)+f(i,:))./(-z(i-1,:)+z(i,:));
%     elseif i == M
%         dfdz(i,:) = 0;%(1/2*f(i-2,:)-2*f(i-1,:)+3/2*f(i,:))./(z(i,:)-z(i-1,:));
%     else
%         dfdz(i,:) = (1/2*f(i-2,:)-2*f(i-1,:)+3/2*f(i,:))./(z(i,:)-z(i-1,:));
%     end
% end

% %Second order central
% for i = 1:M
%     if i == 1
%         dfdz(i,:) = (f(i+1,:)-f(i,:))./(z(i+1,:)-z(i,:));
%     elseif i == M
%         dfdz(i,:) = (f(i,:)-f(i-1,:))./(z(i,:)-z(i-1,:));
%     else
%         dfdz(i,:) = (f(i+1,:)-f(i-1,:))./(z(i+1,:)-z(i-1,:));
%     end
% end

% %Sixt order central
% for i = 1:M
%     if i == 1
%         dfdz(i,:) = (-1/60*f(i,:)+3/20*f(i,:)-3/4*f(i,:)+3/4*f(i+1,:)-3/20*f(i+2,:)+1/60*f(i+3,:))./(z(i+1,:)-z(i,:));
%     elseif i == 2
%         dfdz(i,:) = (-1/60*f(i-1,:)+3/20*f(i-1,:)-3/4*f(i-1,:)+3/4*f(i+1,:)-3/20*f(i+2,:)+1/60*f(i+3,:))./(z(i+1,:)-z(i,:));
%     elseif i == 3
%         dfdz(i,:) = (-1/60*f(i-2,:)+3/20*f(i-2,:)-3/4*f(i-1,:)+3/4*f(i+1,:)-3/20*f(i+2,:)+1/60*f(i+3,:))./(z(i+1,:)-z(i,:));
%     elseif i == M-2
%         dfdz(i,:) = (-1/60*f(i-3,:)+3/20*f(i-2,:)-3/4*f(i-1,:)+3/4*f(i+1,:)-3/20*f(i+2,:)+1/60*f(i+2,:))./(z(i+1,:)-z(i,:));
%     elseif i == M-1
%         dfdz(i,:) = (-1/60*f(i-3,:)+3/20*f(i-2,:)-3/4*f(i-1,:)+3/4*f(i+1,:)-3/20*f(i+1,:)+1/60*f(i+1,:))./(z(i+1,:)-z(i,:));
%     elseif i == M
%         dfdz(i,:) = (-1/60*f(i-3,:)+3/20*f(i-2,:)-3/4*f(i-1,:)+3/4*f(i,:)-3/20*f(i,:)+1/60*f(i,:))./(z(i,:)-z(i-1,:));
%     else
%         dfdz(i,:) = (-1/60*f(i-3,:)+3/20*f(i-2,:)-3/4*f(i-1,:)+3/4*f(i+1,:)-3/20*f(i+2,:)+1/60*f(i+3,:))./(z(i+1,:)-z(i,:));
%     end
% end

end