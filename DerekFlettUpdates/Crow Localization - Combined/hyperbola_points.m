function [xvalue, yvalue] = hyperbola_points( a, b, xmid, ymid, lower_x, upper_x, lower_y, upper_y, density, type)
% Creates as set of x and y values corresponding to the specified
% parameters for the hyperbola
%
% INPUT
%=======================================
% a .......... the a value for the hyperbola
% b .......... the b value for the hyperbola
% xmid ....... the x value for center of hyperbola
% ymid ....... the y value for center of hyperbola
% lower_x .... the lowest x limit used for hyperbola
% upper_x .... the highest x limit used for hyperbola
% lower_y .... the lowest y limit used for hyperbola
% upper_y .... the highest y limit used for hyperbola
% density .... the total number of values taken betweent limits 
%              (if lower_x = -1, upper_x = 2, density = 2000, this function 
%              takes 2*2000 + 1 points in between -1 and 2 as x values)
% type ....... the type for hyperbola to be made (1 for horizontal and 2 for vertical)
%
% OUTPUT
%=======================================
% xvalue ..... the x value of the hyperbola
% yvalue ..... the y value of the hyperbola

x = linspace(lower_x,upper_x,density);
y = linspace(lower_y,upper_y,density);

if type == 1 % if using a horizontal hyperbola
    if a == 0
        xdata_1(1:length(y)) = xmid;
        xdata_2 = xdata_1;
    else
    A = (1/a^2);
    
    B = -((2 * xmid)/a^2);
    
    C = ((xmid^2)/a^2 - ((y - ymid).^2) ./ (b^2) - 1);
    % solve regular quadratic equation
    dicriminant = B.^2 - 4*A.*C;
    
    xdata_1 = (-B - sqrt(dicriminant))./(2*A);
    xdata_2 = (-B + sqrt(dicriminant))./(2*A);
%         xdata_1(dicriminant < 0) = nan;
%         xdata_2(dicriminant < 0) = nan;
    end
%     y(dicriminant < 0) = nan;
    yvalue = [y,nan,y];
    xvalue = [xdata_1,nan,xdata_2]; 
    
    
else % if using a vertical hyperbola
    if a == 0
        
        xdata_2(1:length(x)) = ymid;
        xdata_1 = xdata_2;
    else
        A = (1/a^2);
        
        B = -((2 * ymid)/a^2);
        
        C = ((ymid^2)/a^2 - ((x - xmid).^2) ./ (b^2) - 1);
        % solve regular quadratic equation
        dicriminant = B.^2 - 4*A.*C;

        xdata_1 = (-B - sqrt(dicriminant))./(2*A);
        xdata_2 = (-B + sqrt(dicriminant))./(2*A);
%         xdata_1(dicriminant < 0) = nan;
%         xdata_2(dicriminant < 0) = nan;
    end
%     x(dicriminant < 0) = nan;
    xvalue = [x,nan,x];
    yvalue = [xdata_1,nan,xdata_2];
end

