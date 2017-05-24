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

num_trials = 50;
sec1_mean = 0; sec2_mean = 0; sec3_mean = 0;
sec4_mean = 0; sec5_mean = 0; sec6_mean = 0;
sec7_mean = 0; sec8_mean = 0; sec9_mean = 0;
mean_rms = zeros(3);

tic;
parfor i = 1:num_trials
    %section 1
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation(mod(randn, 1/3), mod(randn, 1/3), 0, false);
    sec1_mean = sec1_mean + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    %mean_rms(1,1) = mean_rms(1,1) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    %section 2
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation(mod(randn, 1/3) + 1/3, mod(randn, 1/3), 0, false);
    sec2_mean = sec2_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(1,2) = mean_rms(1,2) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    %section 3
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation(mod(randn, 1/3) + 2/3, mod(randn, 1/3), 0, false);
    sec3_mean = sec3_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(1,3) = mean_rms(1,3) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    %section 4
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation(mod(randn, 1/3), mod(randn, 1/3) + 1/3, 0, false);
    sec4_mean = sec4_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(2,1) = mean_rms(2,1) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    %section 5
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation(mod(randn, 1/3) + 1/3, mod(randn, 1/3) + 1/3, 0, false);
    sec5_mean = sec5_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(2,2) = mean_rms(2,2) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    %section 6
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation(mod(randn, 1/3) + 2/3, mod(randn, 1/3) + 1/3, 0, false);
    sec6_mean = sec6_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(2,3) = mean_rms(2,3) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    %section 7
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation(mod(randn, 1/3), mod(randn, 1/3) + 2/3, 0, false);
    sec7_mean = sec7_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(3,1) = mean_rms(3,1) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    %section 8
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation(mod(randn, 1/3) + 1/3, mod(randn, 1/3) + 2/3, 0, false);
    sec8_mean = sec8_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(3,2) = mean_rms(3,2) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
    
    %section 9
    [error_12, error_13, error_14, error_23, error_24, error_34] = Crow_2D_Simulation(mod(randn, 1/3) + 2/3, mod(randn, 1/3) + 2/3, 0, false);
    sec9_mean = sec9_mean + rms([error_12, error_13, error_14, error_23, error_24, error_34]);
    %mean_rms(3,3) = mean_rms(1,1) + rms([error_12 error_13 error_14 error_23 error_24 error_34]);
end
toc;

mean_rms = (1/num_trials) .* mean_rms;

contourf(mean_rms);
colorbar;


