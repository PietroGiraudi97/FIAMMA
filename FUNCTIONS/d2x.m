function d2fdx = d2x(f,x)

x = x';
f = f';
[M,N]=size(f);

d2fdx = zeros(M,N);

% % Second order central
% for i = 1:M
%     if i == 1
%         d2fdx(i,:) = (f(i+1,:)-2*f(i,:)+f(i+1,:))./(x(i+1,:)-x(i,:)).^2;
%     elseif i == M
%         d2fdx(i,:) = (f(i-1,:)-2*f(i,:)+f(i,:))./(x(i,:)-x(i-1,:)).^2;
%     else
%         d2fdx(i,:) = (f(i-1,:)-2*f(i,:)+f(i+1,:))./(x(i,:)-x(i-1,:)).^2;
%     end
% end

% Sixth order central
for i = 1:M
    if i == 1
        d2fdx(i,:) = (1/90*f(i+3,:)-3/20*f(i+2,:)+3/2*f(i+1,:)-49/18*f(i,:)+3/2*f(i+1,:)-3/20*f(i+2,:)+1/90*f(i+3,:))./(x(i+1,:)-x(i,:)).^2;
    elseif i == 2
        d2fdx(i,:) = (1/90*f(i+1,:)-3/20*f(i,:)+3/2*f(i-1,:)-49/18*f(i,:)+3/2*f(i+1,:)-3/20*f(i+2,:)+1/90*f(i+3,:))./(x(i+1,:)-x(i,:)).^2;
    elseif i == 3
        d2fdx(i,:) = (1/90*f(i-1,:)-3/20*f(i-2,:)+3/2*f(i-1,:)-49/18*f(i,:)+3/2*f(i+1,:)-3/20*f(i+2,:)+1/90*f(i+3,:))./(x(i+1,:)-x(i,:)).^2;
    elseif i == M-2
        d2fdx(i,:) = (-1/12*f(i-2,:)+16/12*f(i-1,:)-30/12*f(i,:)+16/12*f(i+1,:)-1/12*f(i+2,:))./(x(i+1,:)-x(i,:)).^2;
    elseif i == M-1
        d2fdx(i,:) = (-1/12*f(i-3,:)+4/12*f(i-2,:)+6/12*f(i-1,:)-20/12*f(i,:)+11/12*f(i+1,:))./(x(i+1,:)-x(i,:)).^2;
    elseif i == M
        d2fdx(i,:) = (-1*f(i-3,:)+4*f(i-2,:)-5*f(i-1,:)+2*f(i,:))./(x(i,:)-x(i-1,:)).^2;
    else
        d2fdx(i,:) = (1/90*f(i-3,:)-3/20*f(i-2,:)+3/2*f(i-1,:)-49/18*f(i,:)+3/2*f(i+1,:)-3/20*f(i+2,:)+1/90*f(i+3,:))./(x(i+1,:)-x(i,:)).^2;
    end
end

% % Second order backward
% for i = 1:M
%     if i == 1
%         d2fdx(i,:) = (-1*f(i+3,:)+4*f(i+2,:)-5*f(i+1,:)+2*f(i,:))./(x(i+1,:)-x(i,:)).^2;
%     elseif i == 2
%         d2fdx(i,:) = (-1*f(i+1,:)+4*f(i,:)-5*f(i-1,:)+2*f(i,:))./(x(i,:)-x(i-1,:)).^2;
%     elseif i == 3
%         d2fdx(i,:) = (-1*f(i-1,:)+4*f(i-2,:)-5*f(i-1,:)+2*f(i,:))./(x(i,:)-x(i-1,:)).^2;
%     else
%         d2fdx(i,:) = (-1*f(i-3,:)+4*f(i-2,:)-5*f(i-1,:)+2*f(i,:))./(x(i,:)-x(i-1,:)).^2;
%     end
% end

d2fdx = d2fdx';

end