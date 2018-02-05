clear all, close all, clc;

%Rectangular Coordinates R by Z

%Plot Range
x_ran = 0:0.05:1;
z_ran = 0:0.05:1;
[R,Z] = meshgrid(x_ran,z_ran);

%Constant: ratio width to period? between 0 and 1
E_c = 0.05;

%G(Z)
G = 1 + E_c*cos(2*pi*Z);

%Constraining R and Z
R < G;
%Z at R less than G at R
R > 0;
Z > 0;
Z < 1;

%Pressure Matrix
P_hat = (1+5*E_c^2)*Z - (2/pi)*E_c*sin(2*pi*Z) + (5/(4*pi))*(E_c^2)*sin(4*pi*Z);
%normalized by pressure drop

%Two components of velocity 
U_hat = -E_c*(R.^3 - R).*sin(2*pi*Z) + ((E_c^2)/2)*(5*R.^3 - 3*R).*sin(4*pi*Z);
W_hat = ((R.^2 - 1)/4) + 7*E_c^2 - E_c*(R.^2 -0.5).*cos(2*pi*Z) + ((E_c^2)/2)*((5/4)*R.^2 - 3/8).*cos(4*pi*Z);

%Surface
S = G;


size = size(U_hat);

for i =1:size(1,2)
    for j = 1:size(1,1)
        if R(j,i) > S(j,i)
            U_hat(:,i) = zeros();
            W_hat(:,i) = zeros();
        end
    end 
end

%GRAPH
figure(1)
% subplot(2,2,[1,3])
plot(S,Z);
hold on;
quiver(R,Z,U_hat,W_hat);
% Create title
title({'Vector Representation of Fluid Flow with Components U and W'});
% Create ylabel
ylabel({'Z (length)'});
% Create xlabel
xlabel({'Radius'});
%xaxis limits
xlim([0.5 1.1]);
%yaxis limits
ylim([0 1]);


% 
% subplot(2,2,[2,4])
% plot(P_hat,Z);
% % Create title
% title({'Pressure Gradient'});
% % Create ylabel
% ylabel({'Z (length)'});
% % Create xlabel
% xlabel({'Pressure'});
% %xaxis limits
% xlim([0 1]);
% %yaxis limits
% ylim([0 1]);
% 
