function ass1_5()
% question a
    x=[3.2 3.7 4.2 4.7 5.2 5.7 6.2 6.7 7.2 7.7 8.2 8.7];
    fx=[2 15 33 38 51 47 37 16 15 3 1 3];
    x_new=[];       % including all x values with their frequency
    n=length(x);
    for i=1:n
        x_new=[x_new x(i)*ones(1,fx(i))];
    end;
    mean_x = mean(x_new) % mean_x holds the mean of all x values
    median_x = median(x_new) % median_x holds the meadian of all x values
    mode_x = mode(x_new) % mode_x holds the prevailing value of all x values
    var_x = var(x_new) % var_x holds the variance of all x values
    dispFactor_x = (std(x_new)/mean_x) % dispFactor_x holds the dispersion factor of all x values

% question b
%    boxplot(x_new)
    s(1) = subplot(1,2,1); % left subplot
    s(2) = subplot(1,2,2); % right subplot
    boxplot(s(1),x_new)
    title(s(1),'x new')
    ylabel(s(1),'values')
% question c
    y=[3.45 4.45 5.45 6.45 7.45 8.45];
    fy=[17 71 98 53 18 4];
    y_new=[];       % including all x values with their frequency
    n=length(y);
    for i=1:n
        y_new=[y_new y(i)*ones(1,fy(i))];
    end;
    mean_y = mean(y_new) % mean_y holds the mean of all y values
    median_y = median(y_new) % median_y holds the meadian of all y values
    mode_y = mode(y_new) % mode_y holds the prevailing value of all y values
    var_y = var(y_new) % var_y holds the variance of all y values
    dispFactor_y = (std(y_new)/mean_y) % dispFactor_y holds the dispersion factor of all y values

%    figure;
%    boxplot(y_new)
    boxplot(s(2),y_new)
    title(s(2),'y new')
    ylabel(s(2),'values')


end