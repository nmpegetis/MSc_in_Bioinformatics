function ass1_4()
    x_north=[3.33 0.84 3.95 4.16 2.99 4.86 2.15 2.78 2.84 2.21 2.89 2.56 3.68 2.16 3.15];
    x_south=[5.87 6.31 1.98 2.65 6.78 4.23 0.45 1.51 0.56 2.65 1.54 0.98 0.87];

    qqplot(x_north,x_south)
    title('qqplot')
    [h,p,ksstat] = kstest2(x_north,x_south) % a=0.05
    [h,p,ci,stats] = ttest2(x_north,x_south)
    
    if(mean(x_north)>mean(x_south))
        disp('The average mean height is taller in North Greece')
    else
        disp('The average mean height is shorter in North Greece')
    end
    if(var(x_north)>var(x_south))
        disp('The variance in heights is bigger in North Greece')
    else
        disp('The variance in heights is smaller in North Greece')
    end
end