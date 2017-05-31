%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------Crow_2D_Experimental---------------------------------
% This is the experimental version of the Crow_2D_Simulation function. Note
% that this is not a function, so it takes no input values and returns
% nothing. The source location is no longer simulated. Instead, we use data
% from the audio files selected to create the necessary information.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Receiver Locations
receivernum = 4; % Number of Recorders
x_r(1) = 0; x_r(2) = 1.0; x_r(3) = 0.0; x_r(4) = 1.0;
y_r(1) = 0; y_r(2) = 0.0; y_r(3) = 1.0; y_r(4) = 1.0;
z_r(1:receivernum) = 0;

%% Read File or Create a crow signal
% Read the file
[FileName1,PathName] = uigetfile('*.wav','Select the first file'); [data11,Fs] = audioread(FileName1); data1 = data11(:,1);
[FileName2,PathName] = uigetfile('*.wav','Select the second file'); [data22,Fs] = audioread(FileName2);data2 = data22(:,1);
[FileName3,PathName] = uigetfile('*.wav','Select the third file'); [data33,Fs] = audioread(FileName3); data3 = data33(:,1);
[FileName4,PathName] = uigetfile('*.wav','Select the forth file'); [data44,Fs] = audioread(FileName4); data4 = data44(:,1);
L = length(data1); 
Fs = 50000; % Hz
c = 343; % speed of sound (m/s)
NFFT = 2^nextpow2(L); % Length of the FFT
t = (0:L-1)/Fs;    % Time vector (s)
F = ((0:NFFT-1)/(NFFT))*Fs;   % Frequency vector (Hz)
k = 2*pi*F/c;                                                              % Wave number
Fmin = 1500;                                                               % Minimum Frequency (Hz)
Fmax = 3500;                                                               % Maximum Frequency (Hz)
[~,Imin] = min(abs(F-Fmin));                                               % Minimum Frequency Index
[~,Imax] = min(abs(F-Fmax));                                               % Maximum Frequency Index

% Create the crow signal. If the function was called without values for
% x_s, y_s or z_s, default values will be assigned.
%NOTE: This is no longer used to calculate anything. This will only be used
%for error analysis and visualization.
if ~exist('x_s','var')
    x_s = 0.7;
end
if ~exist('y_s','var')
    y_s = 0.2; 
end
if ~exist('z_s','var')
    z_s = 0;
end
%If the funciton was called without a value for 'hyp_plot', the default
%is set to true (yes plots)
if ~exist('hyp_plot', 'var')
    hyp_plot = true;
end
%% ********************* Localization ***********************
% ************************* CROSS CORRELATION *****************************
x_grid = (-1:0.001:2);
y_grid = (-1:0.001:2);

cor_12 = xcorr(data1,data2,'coef');
cor_13 = xcorr(data1,data3,'coef');
cor_14 = xcorr(data1,data4,'coef');
cor_34 = xcorr(data3,data4,'coef');
% made some changes here; insert correlation from 2 to 4 and 2 to 3
cor_24 = xcorr(data2,data4, 'coeff');
cor_23 = xcorr(data2,data3, 'coeff');

[~, max_ind_12] = max(cor_12);
[~, max_ind_13] = max(cor_13);
[~, max_ind_14] = max(cor_14);
[~, max_ind_34] = max(cor_34);
% added max index 2 to 4 and 2 to 3 here
[~, max_ind_24] = max(cor_24);
[~, max_ind_23] = max(cor_23);

% time delay between element 1 and 2
if max_ind_12 >= L  
    t_max_12 = t(max_ind_12-L+1); 
else
    t_max_12 = -t(L-max_ind_12+1);
end

% time delay between element 1 and 3
if max_ind_13 >= L
       t_max_13 = t(max_ind_13-L+1); 
else
    t_max_13 = -t(L-max_ind_13+1);
end   

% time delay between element 1 and 4
if max_ind_14 >= L    
    t_max_14 = t(max_ind_14-L+1); 
else
    t_max_14 = -t(L-max_ind_14+1);
end   

% time delay between element 3 and 2

if max_ind_34 >= L    
    t_max_34 = t(max_ind_34-L+1); 
else
    t_max_34 = -t(L-max_ind_34+1);
end   

% time delay between element 2 and 4, added by Ben Walzer
if max_ind_24 >= L    
    t_max_24 = t(max_ind_24-L+1);
else
    t_max_24 = -t(L-max_ind_24+1);
end

% time delay between element 2 and 3, added by Ben Walzer
if max_ind_23 >= L    
    t_max_23 = t(max_ind_23-L+1); 
else
    t_max_23 = -t(L-max_ind_23+1);
end   

% figure(3)
% subplot(4,1,1)
% hold all
% plot(-t,cor_12(L:-1:1)./max(cor_12),'k','LineWidth',2); plot(t,cor_12(L:2*L-1)./max(cor_12),'k','LineWidth',2);
% title_name = strcat( 'Time Delay 12: ',num2str(t_max_12),' sec'); title(title_name,'fontsize',18);
% subplot(4,1,2)
% hold all
% plot(-t,cor_13(L:-1:1)./max(cor_13),'k','LineWidth',2); plot(t,cor_13(L:2*L-1)./max(cor_13),'k','LineWidth',2);
% title_name = strcat( 'Time Delay 13: ',num2str(t_max_13),' sec'); title(title_name,'fontsize',18);
% subplot(4,1,3)
% hold all
% plot(-t,cor_14(L:-1:1)./max(cor_14),'k','LineWidth',2); plot(t,cor_14(L:2*L-1)./max(cor_14),'k','LineWidth',2);
% title_name = strcat( 'Time Delay 14: ',num2str(t_max_14),' sec'); title(title_name,'fontsize',18);
% subplot(4,1,4)
% hold all
% plot(-t,cor_34(L:-1:1)./max(cor_34),'k','LineWidth',2); plot(t,cor_34(L:2*L-1)./max(cor_34),'k','LineWidth',2);
% title_name = strcat( 'Time Delay 34: ',num2str(t_max_34),' sec'); title(title_name,'fontsize',18);

%% **************************** HYPERBOLA **********************************
%This section creates the hyperbolas that arise from the time difference of
%arrivals that we calculated above. There are 6 hyperbolas between the
%4 microphones. 

%The hyperbolas that are between mics 1_2, 1_3, 2_4, 3_4 are simple to
%create (i.e, the hyperbola_points function will do everything for you with
%the right values). However, the hyperbolas between 1_4 and 2_3 are more
%difficult because they require rotation after the fact, and some
%translations.

%number of points on the hyperbola, more points results in a more precise
%calculation, but will take more time to calculate.
point_num = 10000;

%Hyperbola between mics 1 and 2, plotted in BLACK
a_12 = abs(t_max_12)*c/2; %a value for the hypoerbola
c_12 =  sqrt((x_r(1)-x_r(2))^2+(y_r(1)-y_r(2))^2+(z_r(1)-z_r(2))^2); %c value for the hyperbola
b_12 = sqrt(c_12^2-a_12^2); %b value for the hyperbola
x_mid_12 = (x_r(1)+x_r(2))/2; %calculates the x-value at the midpoint between the two microphones
y_mid_12 = (y_r(1)+y_r(2))/2; %calculates the y-value at the midpoint between the two microphones
%hyperbola_points is a function that takes all the different parts of the
%hyperbola, and creates a matrix of size 2 x (point_num*2+1), where the
%first row is the x values and the second row is the y values. See the
%hyperbola_points function for more detail
[h_12(1,:), h_12(2,:)] = hyperbola_points(a_12, b_12, x_mid_12, y_mid_12, x_r(1)-5, x_r(4)+5, y_r(1)-5, y_r(4)+5, point_num, 1);

%Hyperbola between mics 1 and 3, plotted in RED
a_13 = abs(t_max_13)*c/2;
c_13 =  sqrt((x_r(1)-x_r(3))^2+(y_r(1)-y_r(3))^2+(z_r(1)-z_r(3))^2); 
b_13 = sqrt(c_13^2-a_13^2);
x_mid_13 = (x_r(1)+x_r(3))/2; 
y_mid_13 = (y_r(1)+y_r(3))/2;
[h_13(1,:), h_13(2,:)] = hyperbola_points(a_13, b_13, x_mid_13, y_mid_13, x_r(1)-5, x_r(4)+5, y_r(1)-5, y_r(4)+5, point_num, 2);


%Hyperbola between mics 1 and 4, plotted in PURPLE
%(BW) I'm attempting to plot the hyperbola as if point 4 was on the x axis,
%preserving distance between the points
x_4_rotated = x_r(1) + sqrt((x_r(4) - x_r(1))^2 + (y_r(4) - y_r(1))^2); %preserving the distance between points 1 and 4
y_4_rotated = y_r(1); %rotating point 4 down to be in line horizontally with recorder 1
a_14 = abs(t_max_14)*c/2; 
c_14 = sqrt((x_r(1) - x_4_rotated)^2 + (y_r(1) - y_4_rotated)^2 + (z_r(1) - z_r(4))^2);
b_14 = sqrt(c_14^2-a_14^2);
x_mid_14 = (x_r(1) + x_4_rotated)/2;
y_mid_14 = (y_r(1) + y_4_rotated)/2;
[h_14(1,:), h_14(2,:)] = hyperbola_points(a_14, b_14, x_mid_14, y_mid_14, x_r(1)-5, x_r(4)+5, y_r(1)-5, y_r(4)+5, point_num, 1);

%Because the h_14 hyperbolas was initially calculated as if recorder 4 was
%inline horizontally with recorder 1, the hyperbola needs to be rotated up
%by theta_14 radians. This is calculated by taking the arctan of the ratio
%of the y distance between recorders 1 and 4, given by y_r(4) - y_r(1), 
%and the x distance between recorders 1 and 4, given by x_r(4) - x_r(1)
theta_14 = atan(abs(y_r(4) - y_r(1)) / abs(x_r(4) - x_r(1))); 

%the 4x8 rotation matrix, this rotates the hyperbola by theta_14 degrees
%counterclockwise, centered at the origin.
rotation = [cos(theta_14) -sin(theta_14);
             sin(theta_14) cos(theta_14)];
h_14 = rotation * h_14;

%Hyperbola between mics 3 and 4, plotted in BLUE
a_34 = abs(t_max_34)*c/2;
c_34 =  sqrt((x_r(3)-x_r(4))^2+(y_r(3)-y_r(4))^2+(z_r(3)-z_r(4))^2); 
b_34 = sqrt(c_34^2-a_34^2);
x_mid_34 = (x_r(3)+x_r(4))/2;
y_mid_34 = (y_r(3)+y_r(4))/2;
[h_34(1,:), h_34(2,:)] = hyperbola_points(a_34, b_34, x_mid_34, y_mid_34, x_r(1)-5, x_r(4)+5, y_r(1)-5, y_r(4)+5, point_num, 1);

%Hyperbola between mics 2 and 3, plotted in Green
x_3_rotated = x_r(2) - sqrt((x_r(2) - x_r(3))^2 + (y_r(2) - y_r(3))^2);
y_3_rotated = y_r(2);
a_23 = abs(t_max_23)*c/2;
c_23 = sqrt((x_r(3) - x_3_rotated)^2 + (y_r(3) - y_3_rotated)^2); %excluding z for now, because it's 0 in testing
b_23 = sqrt(c_23^2 - a_23^2);
x_mid_23 = (x_3_rotated + x_r(2))/2;
y_mid_23 = (y_3_rotated + y_r(2))/2;
[h_23(1,:), h_23(2,:)] = hyperbola_points(a_23, b_23, x_mid_23, y_mid_23, x_r(1)-5, x_r(4)+5, y_r(1)-5, y_r(4)+5, point_num, 1);

%shift the hyperbola over, so it can be rotated about the origin
h_23(1,:) = h_23(1,:) - x_r(2);

%rotation matrix, rotates theta_23 radians counterclockwise, centered about
%the origin
theta_23 = -atan(abs(y_r(3) - y_r(2)) / abs(x_r(3) - x_r(2)));
rotation = [cos(theta_23) -sin(theta_23);
             sin(theta_23) cos(theta_23)];
h_23 = rotation * h_23;
h_23(1,:) = h_23(1,:) + x_r(2);

%Hyperbola between mics 2 and 4, plotted in Cyan
a_24 = abs(t_max_24)*c/2;
c_24 = sqrt((x_r(2) - x_r(4))^2 + (y_r(2) - y_r(4))^2 + (z_r(2) - z_r(4))^2);
b_24 = sqrt(c_24^2 - a_24^2);
x_mid_24 = (x_r(2) + x_r(4))/2;
y_mid_24 = (y_r(2) + y_r(4))/2;
[h_24(1,:), h_24(2,:)] = hyperbola_points(a_24, b_24, x_mid_24, y_mid_24, x_r(1)-5, x_r(4)+5, y_r(1)-5, y_r(4)+5, point_num, 2);

%% plotting the hyperbolas
if hyp_plot == true %hyp_plot == TRUE -> plot hyperbolas, hyp_plot == FALSE -> no plotting
    figure (7); %creates a new window
    xlim([x_r(1)-.01 x_r(2)+0.01]); %restricts the plot window 
    ylim([y_r(1)-0.01 x_r(2)+.01]); %restricts the plot window

    hold on; %stops changes being made to the configuration of the plots
    plot(x_s,y_s,'dk','MarkerFaceColor','y','markersize',14,'LineWidth',1); %plots a Green diamond at the simulated source location
    plot(x_r(1),y_r(1),'ob','MarkerFaceColor','b','markersize',14,'LineWidth',1); %plots a blue dot at the location of the four microphones
    plot(x_r(2),y_r(2),'ob','MarkerFaceColor','b','markersize',14,'LineWidth',1); 
    plot(x_r(3),y_r(3),'ob','MarkerFaceColor','b','markersize',14,'LineWidth',1);
    plot(x_r(4),y_r(4),'ob','MarkerFaceColor','b','markersize',14,'LineWidth',1);
    legend('Actual Source Location','Receivers Location') %adds a legend to the plot

    %Plots the hyperbola between mics 1 and 2: Black
    plot(h_12(1,:),h_12(2,:),'k'); 

    %Plots the hyperbola between mics 1 and 3: Red
    plot(h_13(1,:),h_13(2,:),'r'); 

    %Plots the hyperbola between mics 1 and 4: Purple
    plot(h_14(1,:), h_14(2,:), 'm');

    %Plots the hyperbola between mics 3 and 4: Blue
    plot(h_34(1,:),h_34(2,:),'b'); 
    
    %Plots the hyperbola between mics 2 and 4: Cyan
    plot(h_24(1,:), h_24(2,:), 'c');

    %Plots the hyperbola between mics 2 and 3: Green   
    plot(h_23(1,:), h_23(2,:), 'g');
end
%% **************************** Testing Accuracy **********************************
% %The purpose of this section is to calculate the distance between the test
% %point and point closest on each hyperbola. 

%gets the dimension of the hyperbola h_12. Note that this dimension should be the same for each hyperbola. 
%Should always be a 2 x (point_num*2+1) matrix
[rows, cols] = size(h_12); 

%sets the initial minimum to be at (0,0) and its distance to be infinity
min_12 = [0, 0, inf];

%goes through every set of points in the hyperbola matrix
for i = 1:cols
    %calculates the euclidean distance between the current point and the
    %simulated source location
    distance = sqrt((h_12(1,i) - x_s)^2 + (h_12(2,i) - y_s)^2);
    
    %if the current distance is less than the smallest so far, the current
    %point is set as the new minimum
    if distance < min_12(3)
        min_12 = [h_12(1,i), h_12(2,i), distance];
    end
end

min_13 = [0, 0, inf];
for i = 1:cols
    distance = sqrt((h_13(1,i) - x_s)^2 + (h_13(2,i) - y_s)^2);
    if distance < min_13(3)
        min_13 = [h_13(1,i), h_13(2,i), distance];
    end
end

min_14 = [0, 0, inf];
for i = 1:cols
    distance = sqrt((h_14(1,i) - x_s)^2 + (h_14(2,i) - y_s)^2);
    if distance < min_14(3)
        min_14 = [h_14(1,i), h_14(2,i), distance];
    end
end

min_23 = [0, 0, inf];
for i = 1:cols
    distance = sqrt((h_23(1,i) - x_s)^2 + (h_23(2,i) - y_s)^2);
    if distance < min_23(3)
        min_23 = [h_23(1,i), h_23(2,i), distance];
    end
end

min_24 = [0, 0, inf];
for i = 1:cols
    distance = sqrt((h_24(1,i) - x_s)^2 + (h_24(2,i) - y_s)^2);
    if distance < min_24(3)
        min_24 = [h_24(1,i), h_24(2,i), distance];
    end
end

min_34 = [0, 0, inf];
for i = 1:cols
    distance = sqrt((h_34(1,i) - x_s)^2 + (h_34(2,i) - y_s)^2);
    if distance < min_34(3)
        min_34 = [h_34(1,i), h_34(2,i), distance];
    end
end

%sets the return values (see first line of this function)
min_dist_12 = min_12(3);
min_dist_23 = min_23(3);
min_dist_34 = min_34(3);
min_dist_14 = min_14(3);
min_dist_13 = min_13(3);
min_dist_24 = min_24(3);

%plots the points closest to source location
if hyp_plot == true
    plot (min_12(1), min_12(2), 'sk', 'markersize', 10, 'markerfacecolor', 'k');
    plot (min_13(1), min_13(2), 'sk', 'markersize', 10, 'markerfacecolor', 'r');
    plot (min_14(1), min_14(2), 'sk', 'markersize', 10, 'markerfacecolor', 'm');
    plot (min_23(1), min_23(2), 'sk', 'markersize', 10, 'markerfacecolor', 'g');
    plot (min_24(1), min_24(2), 'sk', 'markersize', 10, 'markerfacecolor', 'c');
    plot (min_34(1), min_34(2), 'sk', 'markersize', 10, 'markerfacecolor', 'b');
end