%%                     Probability Array 

%Define Space Dimentions, x, y and z in meters
x_s = 1; %m
y_s = 1; %m 
z_s = 0; %m

% Receiver Locations
receivernum = 4; % Number of Recorders
x_r(1) = 0; x_r(2) = x_s; x_r(3) = 0.0; x_r(4) = x_s;
y_r(1) = 0; y_r(2) = 0.0; y_r(3) = y_s; y_r(4) = y_s;
z_r(1:receivernum) = 0;


%Resolution: the size of "blocks" inside the space. Smaller number means
%higher resolution. 
%Amount of calucation run will be equal to 4*res_y*res_x
resolution = 0.5; %m
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

for x=1:res_x
    for y=1:res_y
        space(x,y,1) = (resolution/2)+(x-1)*resolution; %x-location of the 
                                                    %center of the square
        space(x,y,2) = (resolution/2)+(y-1)*resolution; %y-location of the c
                                                    %enter of the square
    end
end

%Equation for true TDOA given the location of the source 
%Notation ex) TDOA_1 is the time it takes for the signal to arrive to
%reciever 1

c = 343; % speed of sound (m/s)

t_max = zeros(res_x,res_y,receivernum);
ref = zeros(1,2);
for y=1:res_y
    for x=1:res_x
        for i=1:receivernum
            %NOTE TDOA calculation changes based on microphone location
            ref(1,:) = [x_r(i), y_r(i)];

        t_max(x,y,i) = sqrt((ref(1,1)-space(x,y,1))^2+(ref(1,2)-space(x,y,2))^2)/c;
        end
    end
end

%Knowing the precisely calculated TDOA's of each section's midpoint we
%calculate the TDOA's between each recoder. t_12,t_13,t_14,t_24,t_23,t_34
t_max_xy = zeros(res_x,res_y,6);

for y=1:res_y
    for x=1:res_x
            t_max_xy(x,y,:) = [t_max(x,y,1)-t_max(x,y,2) t_max(x,y,1)-t_max(x,y,3) t_max(x,y,1)-t_max(x,y,4) t_max(x,y,2)-t_max(x,y,4) t_max(x,y,2)-t_max(x,y,3) t_max(x,y,3)-t_max(x,y,4)];
    end
end


%%    Running Localization for each mid-point in the space 
source_loc = zeros(res_x,res_y,2); %The calulcated location of each midpoint
                                  %will be saved in source_loc(x,y,:),
                                  %where source_loc(x,y,1) is the x-cord,
                                  %and source_loc(x,y,2) is the y-cord of
                                  %caluclated location
for y=1:res_y
    for x=1:res_x
        %Changing the name of TDOA for the sake of simplicity. 
        t_12 = t_max_xy(x,y,1);
        t_13 = t_max_xy(x,y,2);
        t_14 = t_max_xy(x,y,3);
        t_34 = t_max_xy(x,y,5);
        t_24 = t_max_xy(x,y,4);
        t_23 = t_max_xy(x,y,6);
        
        [~, realloc] = Localization_For_Table(c,x_s,y_s,t_12,t_13,t_14,t_34,t_24,t_23,true);
        source_loc(x,y,1) = realloc(1,1);
        source_loc(x,y,2) = realloc(1,2);

    end
end
    