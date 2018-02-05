%%                     Probability Array 
clear all;
close all;
clc;

%% Not working, Dont know why
% 
% %Define Space Dimentions, x, y and z in meters
% x_s = 1; %m
% y_s = 1; %m 
% z_s = 0; %m
% 
% % Receiver Locations
% receivernum = 4; % Number of Recorders
% x_r(1) = 0; x_r(2) = x_s; x_r(3) = 0.0; x_r(4) = x_s;
% y_r(1) = 0; y_r(2) = 0.0; y_r(3) = y_s; y_r(4) = y_s;
% z_r(1:receivernum) = 0;


%Resolution: the size of "blocks" inside the space. Smaller number means
%higher resolution. 
%Amount of calucation run will be equal to 4*res_y*res_x
% resolution = 0.5; %m
% res_x = x_l/resolution;
% res_y = y_s/resolution;
%res_z =                 %Fill in when we move to 3d

%The TDOA is calculated from the center of each sub-square which is kept in
%an array
% space = zeros(res_x,res_y,2); %2 will need to switch to 3 for 3d space!
%Determening the center of each sub-square


%Microphones are theoretically located by 

%     1-------2
%     ---------
%     ---------
%     3-------4
% 
% for x=1:res_x
%     for y=1:res_y
%         space(x,y,1) = (resolution/2)+(x-1)*resolution; %x-location of the 
%                                                     %center of the square
%         space(x,y,2) = (resolution/2)+(y-1)*resolution; %y-location of the c
%                                                     %enter of the square
%     end
% end

%Equation for true TDOA given the location of the source 
%Notation ex) TDOA_1 is the time it takes for the signal to arrive to
%reciever 1

% c = 343; % speed of sound (m/s)
% 
% t_max = zeros(res_x,res_y,receivernum);
% ref = zeros(1,2);
% for y=1:res_y
%     for x=1:res_x
%         for i=1:receivernum
% %             NOTE TDOA calculation changes based on microphone location
%             ref(1,:) = [x_r(i), y_r(i)];
% 
%         t_max(x,y,i) = sqrt((ref(1,1)-space(x,y,1))^2+(ref(1,2)-space(x,y,2))^2)/c;
% 
%         end
%     end
% end

% %Knowing the precisely calculated TDOA's of each section's midpoint we
% %calculate the TDOA's between each recoder. t_12,t_13,t_14,t_24,t_23,t_34
% t_max_xy = zeros(res_x,res_y,6);
% 
% for y=1:res_y
%     for x=1:res_x
%             t_max_xy(x,y,:) = [t_max(x,y,1)-t_max(x,y,2) t_max(x,y,1)-t_max(x,y,3) t_max(x,y,1)-t_max(x,y,4) t_max(x,y,2)-t_max(x,y,4) t_max(x,y,2)-t_max(x,y,3) t_max(x,y,3)-t_max(x,y,4)];
%     end
% end
% 
% 
% %%    Running Localization for each mid-point in the space 
% source_loc = zeros(res_x,res_y,2); %The calulcated location of each midpoint
%                                   %will be saved in source_loc(x,y,:),
%                                   %where source_loc(x,y,1) is the x-cord,
%                                   %and source_loc(x,y,2) is the y-cord of
%                                   %caluclated location
% for y=1:res_y
%     for x=1:res_x
%         %Changing the name of TDOA for the sake of simplicity. 
%         t_12 = t_max_xy(x,y,1);
%         t_13 = t_max_xy(x,y,2);
%         t_14 = t_max_xy(x,y,3);
%         t_34 = t_max_xy(x,y,5);
%         t_24 = t_max_xy(x,y,4);
%         t_23 = t_max_xy(x,y,6);
%         
%         [~, realloc] = Localization_For_Table(c,x_s,y_s,t_12,t_13,t_14,t_34,t_24,t_23,true);
%         source_loc(x,y,1) = realloc(1,1);
%         source_loc(x,y,2) = realloc(1,2);
% 
%     end
% end
%     

%% Using Simluation Approach using Chirp 

%Define Space Dimentions, x, y and z in meters
x_s = 3; %m
y_s = 3; %m 
z_s = 0; %m

% Receiver Locations
receivernum = 4; % Number of Recorders
x_r(1) = 0; x_r(2) = x_s; x_r(3) = 0.0; x_r(4) = x_s;
y_r(1) = 0; y_r(2) = 0.0; y_r(3) = y_s; y_r(4) = y_s;
z_r(1:receivernum) = 0;


%Resolution: the size of "blocks" inside the space. Smaller number means
%higher resolution. 
%Amount of calucation run will be equal to 4*res_y*res_x
resolution = 0.05; %m
res_x = x_s/resolution;
res_y = y_s/resolution;
%res_z =                 %Fill in when we move to 3d

%The TDOA is calculated from the center of each sub-square which is kept in
%an array
space = zeros(res_x,res_y,2); %2 will need to switch to 3 for 3d space!
%Determening the center of each sub-square

%Microphones are theoretically located by 

%     1-------2
%     ---------
%     ---------
%     3-------4
% 
for x=1:res_x
    for y=1:res_y
        space(x,y,1) = (resolution/2)+(x-1)*resolution; %x-location of the 
                                                    %center of the square
        space(x,y,2) = (resolution/2)+(y-1)*resolution; %y-location of the c
                                                    %enter of the square
    end
end



L = 1024; % length of signal in time
Fs = 48000; % Hz
c = 343; % speed of sound (m/s)
NFFT = 2^nextpow2(L); % Length of the FFT
t = (0:L-1)/Fs;    % Time vector (s)
F = ((0:NFFT-1)/(NFFT))*Fs;   % Frequency vector (Hz)
k = 2*pi*F/c;                                                              % Wave number
Fmin = 500;                                                               % Minimum Frequency (Hz)
Fmax = 3500;                                                               % Maximum Frequency (Hz)
[~,Imin] = min(abs(F-Fmin));                                               % Minimum Frequency Index
[~,Imax] = min(abs(F-Fmax));  % Maximum Frequency Index


source_loc = zeros(res_x,res_y,2); %The calulcated location of each midpoint
                                  %will be saved in source_loc(x,y,:),
                                  %where source_loc(x,y,1) is the x-cord,
                                  %and source_loc(x,y,2) is the y-cord of
                                  %caluclated location
original_loc = zeros(res_x,res_y,2);

TDOA = zeros(res_x,res_y,6); %Saving the calculated TDOA's in this matrix
progressbar % Create figure and set starting time         

hyp_intersect_orig = zeros(res_x,res_y,13,2); 
hyp_intersect_revised = zeros(res_x,res_y,13,2); 
                                  
for y=1:res_y
    for x=1:res_x


% Create the crow signal. If the function was called without values for
% x_s, y_s or z_s, default values will be assigned.

x_l = space(x,y,1);

y_l = space(x,y,2);


   % Creating the source signal
for u = 1:receivernum
    r(u) = sqrt((x_r(u)-x_l)^2+(y_r(u)-y_l)^2);
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

%% ********************* Localization ***********************
% ************************* CROSS CORRELATION *****************************
x_grid = (-1:0.001:2);
y_grid = (-1:0.001:2);

cor_12 = xcorr(data1,data2,'coef');
cor_13 = xcorr(data1,data3,'coef');
cor_14 = xcorr(data1,data4,'coef');
cor_34 = xcorr(data3,data4,'coef');
cor_24 = xcorr(data2,data4, 'coeff');
cor_23 = xcorr(data2,data3, 'coeff');

[~, max_ind_12] = max(cor_12);
[~, max_ind_13] = max(cor_13);
[~, max_ind_14] = max(cor_14);
[~, max_ind_34] = max(cor_34);
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
    t_max_34 = t(max_ind_34-L+1) ;
else
    t_max_34 = -t(L-max_ind_34+1);
end   

% time delay between element 2 and 4
if max_ind_24 >= L    
    t_max_24 = t(max_ind_24-L+1);
else
    t_max_24 = -t(L-max_ind_24+1);
end

% time delay between element 2 and 3
if max_ind_23 >= L    
    t_max_23 = t(max_ind_23-L+1);
else
    t_max_23 = -t(L-max_ind_23+1);
end   



% %Knowing the precisely calculated TDOA's of each section's midpoint we
% %calculate the TDOA's between each recoder. t_12,t_13,t_14,t_24,t_23,t_34
% t_max_xy = zeros(res_x,res_y,6);


%%    Running Localization for each mid-point in the space 

%Changing the name of TDOA for the sake of simplicity. 
t_12 = t_max_12;
t_13 = t_max_13;
t_14 = t_max_14;
t_34 = t_max_34;
t_24 = t_max_24;
t_23 = t_max_23;

TDOA(x,y,:) = [t_12 t_13 t_14 t_34 t_23 t_34];



[preloc, realloc, qmin, IntersectionList] = Localization_For_Table(c,x_s,y_s,t_12,t_13,t_14,t_34,t_24,t_23,false);
source_loc(x,y,1) = realloc(1,1);
source_loc(x,y,2) = realloc(1,2);
original_loc(x,y,1) = preloc(1,1);
original_loc(x,y,2) = preloc(1,2);
hyp_intersect_orig(x,y,:,:) = qmin; 

hyp_intersect_revised(x,y,:,1) = qmin(1,1) * IntersectionList;
hyp_intersect_revised(x,y,:,2) = qmin(1,2) * IntersectionList;



progressbar(y/res_y) % Update figure 

    end
end

%% Now onto some sick probabilty shenanigans




%Distance (magnidude) from the known point to the 
Distance_error_real = zeros(res_x,res_y);
for y = 1:res_y
    for x = 1:res_x
        Distance_error_real(x,y) = (sqrt((space(x,y,1) - source_loc(x,y,1))^2 + (space(x,y,2) - source_loc(x,y,2))^2));
    end 
end


Distance_error_orig = zeros(res_x,res_y);
for y = 1:res_y
    for x = 1:res_x
        Distance_error_orig(x,y) = (sqrt((space(x,y,1) - original_loc(x,y,1))^2 + (space(x,y,2) - original_loc(x,y,2))^2));
    end 
end



figure(1) 
contourf(Distance_error_real,15);
title ('Error of Experimental Data - Hyperbolas Removed')
xlabel('x axis') % x-axis label
ylabel('y axis') % y-axis label  
pbaspect([1 1 1])
colorbar;


figure(2)
contourf(Distance_error_orig,15);
title ('Error of Experimental Data - Original')
xlabel('x axis') % x-axis label
ylabel('y axis') % y-axis label  
pbaspect([1 1 1])
colorbar;

figure(3)
histogram(Distance_error_real)
title ('Histogram of Error of Experimental Data - Hyperbolas Removed')
xlabel('Error in m') % x-axis label
ylabel('Occurances') % y-axis label 

figure(4)
histogram(Distance_error_orig)
title ('Histogram of Error of Experimental Data - orig')
xlabel('Error in m') % x-axis label
ylabel('Occurances') % y-axis label 
% 
save('hyp_intersect_orig.mat','hyp_intersect_orig')
save('hyp_intersect_revised.mat','hyp_intersect_revised')

% save('Distance_Error.mat','Distance_error')

