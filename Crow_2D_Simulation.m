function [min_dist_12, min_dist_13, min_dist_14, min_dist_23, min_dist_24, min_dist_34] = Crow_2D_Simulation(x_s, y_s, z_s, hyp_plot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------Crow_2D_Simulation---------------------------------
% This function attempts to locate a crow within an array of 4 microphones. 
% INPUTS: - x_s, y_s, z_s: the x, y, and z coordinates of the test point of
%                         origin. If the function is called without these values specified, the
%                         defaults can be changed below.
%
%         - hyp_plot: a switch to plot the hyperbolas calculated or not. true
%                     plots the hyperbolas, false does not plot. If the funciton is
%                     called without these values specified, the default is
%                     set to true
%                     and can be changed below.
%
% OUTPUTS: - min_dist_##: the point closest to the test point, arranged like
%                        [x_coordinate, y_coordinate, distance_from_test]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Receiver Locations
receivernum = 4; % Number of Recorders
x_r(1) = 0; x_r(2) = 1.0; x_r(3) = 0.0; x_r(4) = 1.0;
y_r(1) = 0; y_r(2) = 0.0; y_r(3) = 1.0; y_r(4) = 1.0;
z_r(1:receivernum) = 0;

%% Read File or Create a crow signal
% Read the file
% [FileName1,PathName] = uigetfile('*.wav','Select the first file'); [data11,Fs] = audioread(FileName1); data1 = data11(:,1);
% [FileName2,PathName] = uigetfile('*.wav','Select the second file'); [data22,Fs] = audioread(FileName2);data2 = data22(:,1);
% [FileName3,PathName] = uigetfile('*.wav','Select the third file'); [data33,Fs] = audioread(FileName3); data3 = data33(:,1);
% [FileName4,PathName] = uigetfile('*.wav','Select the forth file'); [data44,Fs] = audioread(FileName4); data4 = data44(:,1);
% L = length(data1); 
L = 1024; % length of signal in time
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
if ~exist('x_s','var')
    x_s = 0.6;
end
if ~exist('y_s','var')
    y_s = 0.7; 
end
if ~exist('z_s','var')
    z_s = 0;
end
%If the funciton was called without a value for 'hyp_plot', the default
%is set to true (yes plots)
if ~exist('hyp_plot', 'var')
    hyp_plot = true;
end
   % Creating the source signal
for u = 1:receivernum
    r(u) = sqrt((x_r(u)-x_s)^2+(y_r(u)-y_s)^2+(z_r(u)-z_s)^2);
end
g = zeros(NFFT,receivernum);
for u = 1:receivernum
    for i = Imin:Imax
        g(i,u) = exp(-1j*(k(i)*r(u)));        
    end
    ff = -1;
    for i = NFFT-Imax+2:NFFT-Imin+2
        ff = ff+1;
        g(i,u) = exp(+1j*(k(Imax-ff)*r(u)));        
    end
end

isc(1:L/8) = chirp(t(1:L/8),(Fmin),t(L/8),(Fmax));
is(1:L/8) = isc(1:L/8);
is(L/8+1:L) = 0;
s = fft(is,NFFT);

for u = 1:receivernum
    for i = 1:NFFT
        p(i,u) = s(i)*g(i,u);
    end
end
     
data1 = ifft(p(:,1), L);
data2 = ifft(p(:,2), L);
data3 = ifft(p(:,3), L);
data4 = ifft(p(:,4), L);
% *******************************
% ArrayGeometry = figure;
% hold all
% plot(x_r,y_r,'o','markersize',12,'LineWidth',5); 
% xlabel('X (m)');ylabel('Y (m)')
% 
% ReceivedSignal = figure;
% subplot(4,1,1)
% plot(t,data1)
% xlabel('Time (s)')
% title('Recorded signal at receiver 1')
% subplot(4,1,2)
% plot(t,data2)
% xlabel('Time (s)')
% title('Recorded signal at receiver 2')
% subplot(4,1,3)
% plot(t,data3)
% xlabel('Time (s)')
% title('Recorded signal at receiver 3')
% subplot(4,1,4)
% plot(t,data4)
% xlabel('Time (s)')
% title('Recorded signal at receiver 4')

%% Plot Spectrogram
% Nfft = 256;    win_size = 125;    ovlap = 0.90;
% [~,FFM_1,TTM_1,PM_1] = spectrogram(data1,hanning(win_size),round(ovlap*win_size),Nfft,Fs);
% [~,FFM_2,TTM_2,PM_2] = spectrogram(data2,hanning(win_size),round(ovlap*win_size),Nfft,Fs);
% [~,FFM_3,TTM_3,PM_3] = spectrogram(data3,hanning(win_size),round(ovlap*win_size),Nfft,Fs);
% [~,FFM_4,TTM_4,PM_4] = spectrogram(data4,hanning(win_size),round(ovlap*win_size),Nfft,Fs);
% 
% figure(6)
% subplot(4,1,1)
% imagesc(TTM_1,FFM_1(1:Nfft/2+1)/1000,10*log10(PM_1(1:Nfft/2+1,:))/10e-6);axis xy;colormap(jet)
% xlabel('Time(s)')
% ylabel('Frequency(kHz)')
% title('Element 1')
% subplot(4,1,2)
% imagesc(TTM_2,FFM_2(1:Nfft/2+1)/1000,10*log10(PM_2(1:Nfft/2+1,:))/10e-6);axis xy;colormap(jet)
% xlabel('Time(s)')
% ylabel('Frequency(kHz)')
% title('Element 2')
% subplot(4,1,3)
% imagesc(TTM_3,FFM_3(1:Nfft/2+1)/1000,10*log10(PM_3(1:Nfft/2+1,:))/10e-6);axis xy;colormap(jet)
% xlabel('Time(s)')
% ylabel('Frequency(kHz)')
% title('Element 3')
% subplot(4,1,4)
% imagesc(TTM_4,FFM_4(1:Nfft/2+1)/1000,10*log10(PM_4(1:Nfft/2+1,:))/10e-6);axis xy;colormap(jet)
% xlabel('Time(s)')
% ylabel('Frequency(kHz)')
% title('Element 4')
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
%number of points on the hyperbola
point_num = 10000;

%1 and 2, BLACK
a_12 = abs(t_max_12)*c/2;
c_12 =  sqrt((x_r(1)-x_r(2))^2+(y_r(1)-y_r(2))^2+(z_r(1)-z_r(2))^2);
b_12 = sqrt(c_12^2-a_12^2);
x_mid_12 = (x_r(1)+x_r(2))/2;
y_mid_12 = (y_r(1)+y_r(2))/2;
h_12 = create_hyperbola(a_12,b_12,0,x_mid_12,y_mid_12,1,point_num);

%1 and 3 RED
a_13 = abs(t_max_13)*c/2;
c_13 =  sqrt((x_r(1)-x_r(3))^2+(y_r(1)-y_r(3))^2+(z_r(1)-z_r(3))^2); 
b_13 = sqrt(c_13^2-a_13^2);
x_mid_13 = (x_r(1)+x_r(3))/2; 
y_mid_13 = (y_r(1)+y_r(3))/2;
h_13 = create_hyperbola(a_13,b_13,0,x_mid_13,y_mid_13,2,point_num); %changed the hyperbola style to 2, rotates it 90 degrees (BW)


%1 and 4 PURPLE
%(BW) I'm attempting to plot the hyperbola as if point 4 was on the x axis,
%preserving distance between the points
x_4_rotated = x_r(1) + sqrt((x_r(4) - x_r(1))^2 + (y_r(4) - y_r(1))^2); %preserving the distance between points 1 and 4
y_4_rotated = y_r(1); %rotating point 4 down to be in line horizontally with recorder 1
a_14 = abs(t_max_14)*c/2; 
c_14 = sqrt((x_r(1) - x_4_rotated)^2 + (y_r(1) - y_4_rotated)^2 + (z_r(1) - z_r(4))^2);
b_14 = sqrt(c_14^2-a_14^2);
x_mid_14 = (x_r(1) + x_4_rotated)/2;
y_mid_14 = (y_r(1) + y_4_rotated)/2;
[h_14] = create_hyperbola(a_14,b_14,0,x_mid_14,y_mid_14,1,point_num);

%Because the h_14 hyperbolas was initially calculated as if recorder 4 was
%inline horizontally with recorder 1, the hyperbola needs to be rotated up
%by theta_14 radians. This is calculated by taking the arctan of the ratio
%of the y distance between recorders 1 and 4, given by y_r(4) - y_r(1), 
%and the x distance between recorders 1 and 4, given by x_r(4) - x_r(1)
theta_14 = atan(abs(y_r(4) - y_r(1)) / abs(x_r(4) - x_r(1))); 

%the 4x8 rotation matrix, this rotates the hyperbola by theta_14 degrees
%counterclockwise, centered at the origin.
rotation = [cos(theta_14) -sin(theta_14) 0 0;
            sin(theta_14) cos(theta_14) 0 0 ;
            0 0 cos(theta_14) -sin(theta_14);
            0 0 sin(theta_14) cos(theta_14)];
h_14 = rotation*h_14;

%3 and 4 BLUE
a_34 = abs(t_max_34)*c/2;
c_34 =  sqrt((x_r(3)-x_r(4))^2+(y_r(3)-y_r(4))^2+(z_r(3)-z_r(4))^2); 
b_34 = sqrt(c_34^2-a_34^2);
x_mid_34 = (x_r(3)+x_r(4))/2;
y_mid_34 = (y_r(3)+y_r(4))/2;
h_34 = create_hyperbola(a_34,b_34,0,x_mid_34,y_mid_34,1,point_num);

%2 and 3 Yellow
x_3_rotated = x_r(2) - sqrt((x_r(2) - x_r(3))^2 + (y_r(2) - y_r(3))^2);
y_3_rotated = y_r(2);
a_23 = abs(t_max_23)*c/2;
c_23 = sqrt((x_r(3) - x_3_rotated)^2 + (y_r(3) - y_3_rotated)^2); %excluding z for now, because it's 0 in testing
b_23 = sqrt(c_23^2 - a_23^2);
x_mid_23 = (x_3_rotated + x_r(2))/2;
y_mid_23 = (y_3_rotated + y_r(2))/2;
h_23 = create_hyperbola(a_23, b_23, 0, x_mid_23, y_mid_23, 1, point_num); 

%shift the hyperbola left for ritation
h_23(1,:) = h_23(1,:) - x_r(2);
h_23(3,:) = h_23(3,:) - x_r(2);
%rotate the hypberola
theta_23 = -atan(abs(y_r(3) - y_r(2)) / abs(x_r(3) - x_r(2)));
rotation = [cos(theta_23) -sin(theta_23) 0 0;
            sin(theta_23) cos(theta_23) 0 0 ;
            0 0 cos(theta_23) -sin(theta_23);
            0 0 sin(theta_23) cos(theta_23)];
h_23 = rotation*h_23;
%shift the hyperbola back (undoing the first shift)
h_23(1,:) = h_23(1,:) + x_r(2);
h_23(3,:) = h_23(3,:) + x_r(2);

%2 and 4 Cyan
a_24 = abs(t_max_24)*c/2;
c_24 = sqrt((x_r(2) - x_r(4))^2 + (y_r(2) - y_r(4))^2 + (z_r(2) - z_r(4))^2);
b_24 = sqrt(c_24^2 - a_24^2);
x_mid_24 = (x_r(2) + x_r(4))/2;
y_mid_24 = (y_r(2) + y_r(4))/2;
h_24 = create_hyperbola(a_24, b_24, 0, x_mid_24, y_mid_24, 2, point_num); %changed the hyperbola style to 2, rotates it 90 degrees (BW)
%% plotting the hyperbolas
if hyp_plot == true %hyp_plot == TRUE -> plot hyperbolas, hyp_plot == FALSE -> no plotting
    figure (7)
    xlim([x_r(1)-.01 x_r(2)+0.01]);
    ylim([y_r(1)-0.01 x_r(2)+.01]);
    hold all
    plot(x_s,y_s,'dk','MarkerFaceColor','y','markersize',14,'LineWidth',1);
    plot(x_r(1),y_r(1),'ob','MarkerFaceColor','b','markersize',14,'LineWidth',1); 
    plot(x_r(2),y_r(2),'ob','MarkerFaceColor','b','markersize',14,'LineWidth',1); 
    plot(x_r(3),y_r(3),'ob','MarkerFaceColor','b','markersize',14,'LineWidth',1);
    plot(x_r(4),y_r(4),'ob','MarkerFaceColor','b','markersize',14,'LineWidth',1);

    % 1 and 2: Black
    plot(h_12(1,:),h_12(2,:),'k'); 
    plot(h_12(3,:),h_12(4,:),'k');

    %1 and 3: Red
    plot(h_13(1,:),h_13(2,:),'r'); 
    plot(h_13(3,:),h_13(4,:),'r');

    %1 and 4: Purple
    plot(h_14(1,:), h_14(2,:), 'm');
    plot(h_14(3,:), h_14(4,:), 'm');

    %3 and 4: Blue
    plot(h_34(1,:),h_34(2,:),'b'); 
    plot(h_34(3,:),h_34(4,:),'b');

    %2 and 4: Cyan
    plot(h_24(1,:), h_24(2,:), 'c');
    plot(h_24(3,:), h_24(4,:), 'c');

    %2 and 3: Yellow
    plot(h_23(1,:), h_23(2,:), 'y'); 
    plot(h_23(3,:), h_23(4,:), 'y');

    legend('Actual Source Location','Receivers Location')
end
%% **************************** Testing Accuracy **********************************
%The purpose of this section is to calculate the distance between the test
%point and point closest on each hyperbola. 

%gets the size of the points where the hyperbola points are stored
%Note that the size of each hyperbola should be the same, so these values will be reused for the other checks
[rows, cols] = size(h_12);                                                  

%Minimize Hyperbola 1-2
%min_12 is the point at where the hyperbola is closest to the sample point,
%and its distance from the sample at that point.
%It's initial value is the first point in the hyperbola
min_12 = [h_12(1,1), h_12(2,1), sqrt((h_12(1,1) - x_s)^2 + (h_12(2,1) - y_s)^2)];  

%loops through all points of hyperbola between mics 1 and 2
%euclidean distance between the point on the hyperbola and the sample point
%checks if a new point is closer than the previous closest
%if new closest point is found, sets it as the closest point
for i = 1:cols                                                              
    distance_12a = sqrt((h_12(1,i) - x_s)^2 + (h_12(2,i) - y_s)^2);
    distance_12b = sqrt((h_12(3,i) - x_s)^2 + (h_12(4,i) - y_s)^2);
   if  distance_12a < min_12(3)                                                
       min_12 = [h_12(1,i), h_12(2,i), distance_12a];
   end
   if distance_12b < min_12(3)
       min_12 = [h_12(3,i), h_12(4,i), distance_12b];
   end
end
if hyp_plot == true
    plot (min_12(1), min_12(2), 'sk', 'markersize', 10, 'markerfacecolor', 'k');
end

%Minimize Hyperbola 1-3
min_13 = [h_13(1,1), h_13(2,1), sqrt((h_13(1,1) - x_s)^2 + (h_13(2,1) - y_s)^2)];
for i = 1:cols
    distance_13a = sqrt((h_13(1,i) - x_s)^2 + (h_13(2,i) - y_s)^2);
    distance_13b = sqrt((h_13(3,i) - x_s)^2 + (h_13(4,i) - y_s)^2);
    if distance_13a < min_13(3)
        min_13 = [h_13(1,i), h_13(2,i), distance_13a];
    end
    if distance_13b < min_13(3)
        min_13 = [h_13(3,i), h_13(4,i), distance_13b];        
    end
end
if hyp_plot == true
    plot (min_13(1), min_13(2), 'sr', 'markersize', 10, 'markerfacecolor', 'r');
end

%Minimize Hyperbola 1-4
min_14 = [h_14(1,1), h_14(2,1), sqrt((h_14(1,1) - x_s)^2 + (h_14(2,1) - y_s)^2)];
for i = 1:cols                                                              
    distance_14a = sqrt((h_14(1,i) - x_s)^2 + (h_14(2,i) - y_s)^2);
    distance_14b = sqrt((h_14(3,i) - x_s)^2 + (h_14(4,i) - y_s)^2);
   if  distance_14a < min_14(3)                                                
       min_14 = [h_14(1,i), h_14(2,i), distance_14a];
   end
   if distance_14b < min_14(3)
       min_14 = [h_14(3,i), h_14(4,i), distance_14b];
   end
end
if hyp_plot == true
    plot (min_14(1), min_14(2), 'sm', 'markersize', 10, 'markerfacecolor', 'm');
end

% %Minimize Hyperbola 2-3
min_23 = [h_23(1,1), h_23(2,1), sqrt((h_23(1,1) - x_s)^2 + (h_23(2,1) - y_s)^2)];
for i = 1:cols                                                              
    distance_23a = sqrt((h_23(1,i) - x_s)^2 + (h_23(2,i) - y_s)^2);
    distance_23b = sqrt((h_23(3,i) - x_s)^2 + (h_23(4,i) - y_s)^2);
   if  distance_23a < min_23(3)                                                
       min_23 = [h_23(1,i), h_23(2,i), distance_23a];
   end
   if distance_23b < min_23(3)
       min_23 = [h_23(3,i), h_23(4,i), distance_23b];
   end
end
if hyp_plot == true
    plot (min_23(1), min_23(2), 'sy', 'markersize', 10, 'markerfacecolor', 'y');
end
%Minimize Hyperbola 2-4
min_24 = [h_24(1,1), h_24(2,1), sqrt((h_24(1,1) - x_s)^2 + (h_24(2,1) - y_s)^2)];
for i = 1:cols
    distance_24a = sqrt((h_24(1,i) - x_s)^2 + (h_24(2,i) - y_s)^2);
    distance_24b = sqrt((h_24(3,i) - x_s)^2 + (h_24(4,i) - y_s)^2);
     current = [h_24(1,i), h_24(2,i), distance_24a;
                h_24(3,i), h_24(4,i), distance_24b];
    if distance_24a < min_24(3)
        min_24 = [h_24(1,i), h_24(2,i), distance_24a];
    end
    if distance_24b < min_24(3)
        min_24 = [h_24(3,i), h_24(4,i), distance_24b];        
    end
end
if hyp_plot == true
    plot (min_24(1), min_24(2), 'sc', 'markersize', 10, 'markerfacecolor', 'c');
end
% %Minimize Hyperbola 3-4
min_34 = [h_34(1,1), h_34(2,1), sqrt((h_34(1,1) - x_s)^2 + (h_34(2,1) - y_s)^2)];
for i = 1:cols
    distance_34a = sqrt((h_34(1,i) - x_s)^2 + (h_34(2,i) - y_s)^2);
    distance_34b = sqrt((h_34(3,i) - x_s)^2 + (h_34(4,i) - y_s)^2);
     current = [h_34(1,i), h_34(2,i), distance_34a;
                h_34(3,i), h_34(4,i), distance_34b];
    if distance_34a < min_34(3)
        min_34 = [h_34(1,i), h_34(2,i), distance_34a];
    end
    if distance_34b < min_34(3)
        min_34 = [h_34(3,i), h_34(4,i), distance_34b];        
    end
end
if hyp_plot == true
    plot (min_34(1), min_34(2), 'sb', 'markersize', 10, 'markerfacecolor', 'b');
end

min_dist_12 = min_12(3);
min_dist_23 = min_23(3);
min_dist_34 = min_34(3);
min_dist_14 = min_14(3);
min_dist_13 = min_13(3);
min_dist_24 = min_24(3);

%% ************************* SEARCH FOR LOCATION ***************************
% for x_ind = 1:length(x_grid)
%     Error (x_ind) = abs(y_aft(x_ind)-y_starboard_upper(x_ind));
% end
% [~, ind_min] = min(Error);
        

% figure (5)
% hold all
% plot(port_upper(1),port_upper(3),'or','MarkerFaceColor','r');
% % plot(port_lower(1),port_lower(3),'or');
% plot(starboard_upper(1),starboard_upper(3),'ob','MarkerFaceColor','b');
% % plot(starboard_lower(1),starboard_lower(3),'or');
% plot(aft(1),aft(3),'ok','MarkerFaceColor','k');
% legend('Port Upper','Starboard Upper','AFT')
% plot(x_grid,y_starboard_upper1,'--b');plot(x_grid,y_aft1,'--k');
% plot(x_grid,y_starboard_upper2,'--b');plot(x_grid,y_aft2,'--k');
% plot(y_starboard_upper3(1,:),y_starboard_upper3(2,:),'-b')
% plot(y_aft3(1,:),y_aft4(2,:),'-k')
% plot(y_starboard_upper3(3,:),y_starboard_upper3(4,:),'-b')
% plot(y_aft3(3,:),y_aft3(4,:),'-k')
% 
% xlabel('x(m)')
% ylabel('z(m)')