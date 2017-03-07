function [SVMStruct] = designSVM(superClass, classLabels)
    SVMStruct = svmtrain(superClass, classLabels, 'Kernel_Function', 'linear', 'Polyorder', 3, 'Method', 'LS', 'ShowPlot', false);
    %      values for 'Kernel_Function': 'linear', 'quadratic', 'polynomial', 'rbf', 'mlp'
    %        if 'Kernel_Function' is 'polynomial', then values for 'Polyorder': 1,2,3,... (default=3)
    %        if 'Kernel_Function' is 'mlp', then values for 'Mlp_Params': [p1 p2], where p1>0, p2<0 (default p1=1, p2=-2) the parameters of the kernel function: K = tanh(p1*U*V' + p2)
    %      values for 'Method': 'QP', 'LS' that stands for Quadratic Programming (default if Optimization toolbox if installed), and Least Square: it's the method to find the separating hyperplane.
    %        if 'Method' is 'QP', then values for 'QuadProg_Opts': [p1 p2], where p1>0, p2<0 (default p1=1, p2=-2) the parameters of the kernel function: K = tanh(p1*U*V' + p2)
    %      values for 'ShowPlot': true, false: plots (or not) data and separating line (for 2D data only)
end