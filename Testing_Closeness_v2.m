%Benjamin Walzer - Crow Localization Research @UW Bothell
%Divided the array within the 4 microphones into 9 sections
%  _____ _____ _____
% |     |     |     |
% |  7  |  8  |  9  |
% |_____|_____|_____|
% |     |     |     |
% |  4  |  5  |  6  |
% |_____|_____|_____|
% |     |     |     |
% |  1  |  2  |  3  |
% |_____|_____|_____|

num_trials = 10;
sec1_mean = 0; sec2_mean = 0; sec3_mean = 0;
sec4_mean = 0; sec5_mean = 0; sec6_mean = 0;
sec7_mean = 0; sec8_mean = 0; sec9_mean = 0;
mean_rms = zeros(3);

%Gathering error data and average of errors in each section

tableSection1 = zeros(num_trials,6);
tableSection2 = zeros(num_trials,6);
tableSection3 = zeros(num_trials,6);
tableSection4 = zeros(num_trials,6);
tableSection5 = zeros(num_trials,6);
tableSection6 = zeros(num_trials,6);
tableSection7 = zeros(num_trials,6);
tableSection8 = zeros(num_trials,6);
tableSection9 = zeros(num_trials,6);


Master_error_avg = zeros(9,6);

tic;
for i = 1:num_trials
    %section 1
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation_Two_Removed(mod(randn, 1/3), mod(randn, 1/3), 0, false);
    sec1_mean = sec1_mean + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    %mean_rms(1,1) = mean_rms(1,1) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    tableSection1(i,:) = [error_12 error_13 error_14 error_23 error_24 error_34];
    Master_error_avg(1,:) = mean(tableSection1, 1); %Mean of the errors in each each collumn 
    
    %section 2
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation_Two_Removed(mod(randn, 1/3) + 1/3, mod(randn, 1/3), 0, false);
    sec2_mean = sec2_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(1,2) = mean_rms(1,2) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    tableSection2(i,:) = [error_12 error_13 error_14 error_23 error_24 error_34];
    Master_error_avg(2,:) = mean(tableSection2, 1); %Mean of the errors in each each collumn 
    
    %section 3
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation_Two_Removed(mod(randn, 1/3) + 2/3, mod(randn, 1/3), 0, false);
    sec3_mean = sec3_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(1,3) = mean_rms(1,3) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    tableSection3(i,:) = [error_12 error_13 error_14 error_23 error_24 error_34];
    Master_error_avg(3,:) = mean(tableSection3, 1); %Mean of the errors in each each collumn 
    
    %section 4
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation_Two_Removed(mod(randn, 1/3), mod(randn, 1/3) + 1/3, 0, false);
    sec4_mean = sec4_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(2,1) = mean_rms(2,1) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);

    tableSection4(i,:) = [error_12 error_13 error_14 error_23 error_24 error_34];
    Master_error_avg(4,:) = mean(tableSection4, 1); %Mean of the errors in each each collumn 
    
    
    %section 5
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation_Two_Removed(mod(randn, 1/3) + 1/3, mod(randn, 1/3) + 1/3, 0, false);
    sec5_mean = sec5_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(2,2) = mean_rms(2,2) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    tableSection5(i,:) = [error_12 error_13 error_14 error_23 error_24 error_34];
    Master_error_avg(5,:) = mean(tableSection5, 1); %Mean of the errors in each each collumn 
    
    %section 6
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation_Two_Removed(mod(randn, 1/3) + 2/3, mod(randn, 1/3) + 1/3, 0, false);
    sec6_mean = sec6_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(2,3) = mean_rms(2,3) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    tableSection6(i,:) = [error_12 error_13 error_14 error_23 error_24 error_34];
    Master_error_avg(6,:) = mean(tableSection6, 1); %Mean of the errors in each each collumn 
    
    %section 7
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation_Two_Removed(mod(randn, 1/3), mod(randn, 1/3) + 2/3, 0, false);
    sec7_mean = sec7_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(3,1) = mean_rms(3,1) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    tableSection7(i,:) = [error_12 error_13 error_14 error_23 error_24 error_34];
    Master_error_avg(7,:) = mean(tableSection7, 1); %Mean of the errors in each each collumn 
    
    %section 8
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation_Two_Removed(mod(randn, 1/3) + 1/3, mod(randn, 1/3) + 2/3, 0, false);
    sec8_mean = sec8_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(3,2) = mean_rms(3,2) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    tableSection8(i,:) = [error_12 error_13 error_14 error_23 error_24 error_34];
    Master_error_avg(8,:) = mean(tableSection8, 1); %Mean of the errors in each each collumn 
    
    
    %section 9
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation_Two_Removed(mod(randn, 1/3) + 2/3, mod(randn, 1/3) + 2/3, 0, false);
    sec9_mean = sec9_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(3,3) = mean_rms(1,1) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    tableSection9(i,:) = [error_12 error_13 error_14 error_23 error_24 error_34];
    Master_error_avg(9,:) = mean(tableSection9, 1); %Mean of the errors in each each collumn 
end
toc;

mean_rms = [sec1_mean/num_trials sec2_mean/num_trials sec3_mean/num_trials;
            sec4_mean/num_trials sec5_mean/num_trials sec6_mean/num_trials;
            sec7_mean/num_trials sec8_mean/num_trials sec9_mean/num_trials];


contourf(mean_rms, 25);
title ('Error Original')
xlabel('x axis') % x-axis label
ylabel('y axis') % y-axis label  
pbaspect([1 1 1])
colorbar;

rows = {'Sec1','Sec2','Sec3','Sec4','Sec5','Sec6','Sec7','Sec8','Sec9'};
Title = {'Error_12','Error_13','Error_14','Error_23',' Error_24','Error_34'};
array2table( Master_error_avg, 'VariableNames', Title, 'RowNames', rows)



