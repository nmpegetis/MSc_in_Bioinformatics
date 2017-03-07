function ass1_2()

% question 2a
    x_before=[185 110 100 150 170 125 160 110];
%    normplot(x_before)
%    title('x_{before}')
    
    x_after=[170 114 90 130 177 122 140 110];
%    figure
%    normplot(x_after)
%    title('x_{after}')
    
    n=length(x_before);
    x_diff=x_before-x_after
%    x_diff=zeros()
%    for i=1:n
%        x_diff(i)=x_before(i)-x_after(i)
%    end;
%    figure
    normplot(x_diff)
    title('x_{diff}')

    
% question 2b
    [h,p,lstat,cv] = lillietest(x_diff)   

    x_comparisons=[
        185 170; 
        110 114; 
        100 90; 
        150 130; 
        170 177; 
        125 122; 
        160 140; 
        110 110];
    [p,table,stat]=anova1(x_comparisons); 
	c=multcompare(stat) 

end