function dfdx = dx(f,x)

x = x';
f = f';
[M,N]=size(f);

dfdx = zeros(M,N);

%First order backward
for i = 1:M
    if i == 1
        dfdx(i,:) = 0;%(f(i+1,:)-f(i,:))./(x(i+1,:)-x(i,:));
    elseif i == M
        dfdx(i,:) = 0;%(f(i,:)-f(i-1,:))./(x(i,:)-x(i-1,:));
    else
        dfdx(i,:) = (f(i,:)-f(i-1,:))./(x(i,:)-x(i-1,:));
    end
end

% %Second order backward
% for i = 1:M
%     if i == 1
%         dfdx(i,:) = 0;%(1/2*f(i+2,:)-2*f(i+1,:)+3/2*f(i,:))./(x(i+1,:)-x(i,:));
%     elseif i == 2
%         dfdx(i,:) = (1/2*f(i,:)-2*f(i-1,:)+3/2*f(i,:))./(x(i,:)-x(i-1,:));
%     else
%         dfdx(i,:) = (1/2*f(i-2,:)-2*f(i-1,:)+3/2*f(i,:))./(x(i,:)-x(i-1,:));
%     end
% end

% %Second order central
% for i = 1:M
%     if i == 1
%         dfdx(i,:) = 0;%(f(i+1,:)-f(i,:))./(x(i+1,:)-x(i,:));
%     elseif i == M
%         dfdx(i,:) = (f(i,:)-f(i-1,:))./(x(i,:)-x(i-1,:));
%     else
%         dfdx(i,:) = 0;%(f(i+1,:)-f(i-1,:))./(x(i+1,:)-x(i-1,:));
%     end
% end

% %Sixth order central
% for i = 1:M
%     if i == 1
%         dfdx(i,:) = (-1/60*f(i+3,:)+3/20*f(i+2,:)-3/4*f(i+1,:)+3/4*f(i+1,:)-3/20*f(i+2,:)+1/60*f(i+3,:))./(x(i+1,:)-x(i,:));
%     elseif i == 2
%         dfdx(i,:) = (-1/60*f(i+1,:)+3/20*f(i,:)-3/4*f(i-1,:)+3/4*f(i+1,:)-3/20*f(i+2,:)+1/60*f(i+3,:))./(x(i+1,:)-x(i,:));
%     elseif i == 3
%         dfdx(i,:) = (-1/60*f(i-1,:)+3/20*f(i-2,:)-3/4*f(i-1,:)+3/4*f(i+1,:)-3/20*f(i+2,:)+1/60*f(i+3,:))./(x(i+1,:)-x(i,:));
%     elseif i == M-2
%         dfdx(i,:) = (-1/60*f(i-3,:)+3/20*f(i-2,:)-3/4*f(i-1,:)+3/4*f(i+1,:)-3/20*f(i+2,:)+1/60*f(i+2,:))./(x(i+1,:)-x(i,:));
%     elseif i == M-1
%         dfdx(i,:) = (-1/60*f(i-3,:)+3/20*f(i-2,:)-3/4*f(i-1,:)+3/4*f(i+1,:)-3/20*f(i+1,:)+1/60*f(i+1,:))./(x(i+1,:)-x(i,:));
%     elseif i == M
%         dfdx(i,:) = 0;%(-1/60*f(i-3,:)+3/20*f(i-2,:)-3/4*f(i-1,:)+3/4*f(i,:)-3/20*f(i,:)+1/60*f(i,:))./(x(i,:)-x(i-1,:));
%     else
%         dfdx(i,:) = (-1/60*f(i-3,:)+3/20*f(i-2,:)-3/4*f(i-1,:)+3/4*f(i+1,:)-3/20*f(i+2,:)+1/60*f(i+3,:))./(-1/60*x(i-3,:)+3/20*x(i-2,:)-3/4*x(i-1,:)+3/4*x(i+1,:)-3/20*x(i+2,:)+1/60*x(i+3,:));
%     end
% end



dfdx = dfdx';
end