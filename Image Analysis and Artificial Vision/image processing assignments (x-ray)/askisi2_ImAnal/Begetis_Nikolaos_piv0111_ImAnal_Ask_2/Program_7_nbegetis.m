%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function uses a main program which calls either the
%% Minimum Distance Classifier with more than 2 features, or the knn or pnn
%% classifiers or the bayesian or non-linear bayesian, using switch case
%% statements and being terminated by user.
%% Filename: Program_7_nbegetis.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% 1)Incorporate NN and SVM algorithms in your main program with the rest of
% the classifiers.

% 2)Expand your main program by the following function for loading features
% extracted from actual image data

%------------------------------------------------------------
% Use the data given for training of the classifier. Have to nromalize them
% first, using Matlab's function mapstd. Classify the data (each row is a 
% separate pattern), printing out the correct and false classifications.

% 3)Within Matlab’s  multivariate analysis a section, there is a subsection
% called classification. There, you can find classifiers such the Linear 
% and Quadratic Discriminant Analysis (LDA or QDA) classifiers, and the 
% Decision Tree classifier (DTC). It is required that you use those 
% algorithms (using Matlab’s ready functions) and that you incorporate them 
% as separate functions ( e.g. [classified]=LDA_classifier(unknown_pattern,
% class1,class2) )) into your main program, with the rest of the 
% classifiers.

% 4)Use classifier schemes for various 3 classifiers (from the ones you 
% have already designed) to construct ensemble schemes and classify the 
% provided data.

% 5)Your deliverable for Lab 2 should consist of a)a main program that will 
% work on the above data b) will incorporate all classifiers and one 
% ensemble scheme c)use a suitable menu for choosing type of classification.


% Program_7_nbegetis
function[]=Program_7_nbegetis()
    clc;echo off;close all;clear all;

    [class1, class2] = loadData();

	patterns1 = size(class1, 1);
    patterns2 = size(class2, 1);
    classLabels = [ones(1, size(class1, 1)) 2 * ones(1, size(class2, 1))]'; %puts labels for class1 and 2 as 1 and -1
    superClass = [class1; class2];  %form superclass
    [superClass] = normalize(superClass);
    patternsInBothClasses = size(superClass, 1);
    
    classified=0;
    
    terminate=false;
    while (~terminate)
        choice=0;
        zeros=0;
        while choice<1 || choice>15 
            choice = input('Select the classifier you prefer to use\n1. MDC\n2. k-NN\n3. PNN\n4. Bayesian\n5. Quadratic Bayesian\n6. Perceptron for separable classes\n7. Perceptron for non-separable classes\n8. Matlab Multilayer Perceptron\n9. SVM\n10. Matlab SVM\n11. Matlab LDA\n12. Matlab QDA\n13. Matlab DTC\n14. Scheme\n15. Terminate Program\nType selection (1-15):  ');
        end; 
        
        for i=1:patternsInBothClasses
            unknown_pattern=superClass(i,:);
        
            switch (choice)
                case 1  % MDC
                    classified=MDC_classifier(unknown_pattern,class1,class2);                
                case 2  % k-NN
                    knn_choice=0;
                    while knn_choice < 1 || knn_choice > 4 
                        knn_choice = input('Select how many neighbours you want \n1. 1 - NN\n2. k - NN\n3. k+k - NN\n4. k - NN with weighted votes\nType selection (1-4):  ');
                    end
                    if (knn_choice==1)
                        neighbours=1;
                    elseif (knn_choice==2 || knn_choice==4)
                        neighbours=0
                        while neighbours < 1 || neighbours > (patterns1+patterns2) 
                            fprintf('Enter number of neighbours between 1-%d: ',patterns1+patterns2);
                            neighbours = input(' ');
                        end
                    elseif (knn_choice==3)
                        if (patterns1<patterns2)
                            patt=patterns1;
                        else
                            patt=patterns2;
                        end

                        neighbours=0
                        while neighbours < 1 || neighbours > patt
                            fprintf('Enter number of neighbours between 1-%d: ', patt);
                            neighbours = input(' ');
                        end
                    end
                    classified=KNN_classifier(unknown_pattern,class1,class2,knn_choice,neighbours);                
                case 3  % PNN
                    pnn_choice=0;
                    while pnn_choice < 1 || pnn_choice > 3 
                        pnn_choice = input('Select the function you want for PNN classification\n1. Gaussian\n2. Exponential\n3. Reciprocal\nType selection (1-3):  ');
                    end
                    classified=PNN_classifier(unknown_pattern,class1,class2,pnn_choice);                
                case 4  % Bayesian
                    classified=Bayesian_classifier(unknown_pattern, class1, class2);                
                case 5  % Quadratic Bayesian
                    classified=QuadraticBayesian_classifier(unknown_pattern,class1,class2);                
                case 6  % Perceptron for separable classes
                    classified=Perceptron_classifier_separable_classes(unknown_pattern, class1, class2);
                case 7  % Perceptron for non-separable classes
                    classified=Perceptron_classifier_nonseparable_classes (unknown_pattern, class1, class2);                        
                case 8  % Matlab Multilayer Perceptron
                    classified=ANN_Matlab_classifier(unknown_pattern, class1, class2);
                case 9  % SVM
                    classified=SVM_classifier(unknown_pattern, class1, class2);
                case 10 % Matlab SVM
                    classified=SVM_Matlab_classifier(unknown_pattern, class1, class2);
                case 11 % Matlab LDA
                    classified=LDA_Matlab_classifier(unknown_pattern, class1, class2);
                case 12 % Matlab QDA
                    classified=QDA_Matlab_classifier(unknown_pattern, class1, class2);
                case 13 % Matlab DTC
                    classified = DTC_Matlab_classifier(unknown_pattern, class1, class2);
                case 14 % scheme
                    scheme_choice=0;
                    while scheme_choice < 1 || scheme_choice > 5 
                        scheme_choice = input('Select the function you want for scheme\n1. Majority Vote\n2. Product rule\n3. Sum rule\n4. Max rule\n5. Min rule\nType selection (1-5):  ');
                    end
                    label=classLabels(i);
                    classified=scheme_classifier(unknown_pattern, class1, class2, label, scheme_choice);
                case 15
                    terminate=true;
            end
            if (classified~=classLabels(i)) 
                zeros=zeros+1;
            end;
            
        end
        
        if (classified==0)
            disp('Unknown pattern belongs to no class');
        else
            fprintf(1,'Unknown pattern belongs to class: %4.0f\n\n',classified);
        end
        figure;
        plotScatter(unknown_pattern,class1,class2);
        
        if (terminate==true)
            overallSuccess=100*((patternsInBothClasses-zeros)/patternsInBothClasses);
            fprintf('missClassified: %8.0f \noverAllSuccess: %8.0f %%\n\n', zeros, overallSuccess);
        end

    end

end



%% ------------------Functions---------------------------------------------

function [class1, class2]=loadData()
% data from microscopy images of thyroid, 4 features extracted (mean, std, 
% skewness, curtosis from each ROI (on thyroid nuclei)).

class1=[  % microscopy images of thyroid HighGrade Ca
    1.0140590e+002  2.4890069e+001 -2.3645176e+000  1.1033644e+001
    9.6417234e+001  1.1293169e+001  6.3933109e-001  3.5952700e+000
    1.0177324e+002  1.3331575e+001  3.4772438e-002  2.4784380e+000
    1.0582766e+002  3.2911649e+001 -2.5222501e+000  8.5839875e+000
    9.6609977e+001  2.6311018e+001 -2.5111029e+000  1.0150649e+001
    9.5732426e+001  3.4333446e+001 -2.1224260e+000  6.4232475e+000
    1.0646485e+002  2.6878146e+001 -3.1294014e+000  1.2943794e+001
    1.0084354e+002  2.5160086e+001 -2.4882562e+000  1.0920485e+001
    9.4757370e+001  1.5050259e+001 -1.9093679e+000  1.5656505e+001
    1.0140363e+002  3.2966146e+001 -2.3164752e+000  7.6172933e+000
    9.5011338e+001  3.6435665e+001 -1.8316196e+000  5.4124896e+000
    1.0706349e+002  2.2804613e+001 -3.4189256e+000  1.6718555e+001
    ];

class2 =[ % microscopy images of thyroid LowGrade Ca
    1.3373923e+002  2.7821304e+001 -1.5974506e+000  9.6610652e+000
    1.5941723e+002  1.3909101e+001 -3.5988430e-001  2.8787984e+000
    1.5346939e+002  1.5239869e+001 -5.0287213e-001  2.7473837e+000
    1.3789569e+002  1.9026012e+001 -1.4600956e+000  1.4682993e+001
    1.4867574e+002  1.7888584e+001  2.5696968e-001  2.6647207e+000
    1.3503175e+002  3.0651488e+001 -3.1318618e+000  1.4742417e+001
    1.1824717e+002  1.7126186e+001 -6.2786366e-002  8.7437947e+000
    1.4900000e+002  1.2495804e+001  6.3691434e-002  2.9861096e+000
    ];
end

%--------------------------------------------------------------------------
%-------------------MDC_classifier-----------------------------------------
%--------------------------------------------------------------------------
function [classified]=MDC_classifier(unknown_pattern,class1,class2)
    % // Design Minimum Distance Classifier
    % // Let point X with vector X_patt
    % // and di its distance from class i then
    % // di^2= (X_patt[0]-Mean_Class_i[0])^2 + (X_patt[1]-Mean_Class_i[1])^2=
    % //
    % // =X_patt[0]^2+X_patt[1]^2-2(Mean_Class_i[0]*X_patt[0]+
    % // Mean_Class_i[1]*X_patt[1]
    % // -0.5*(Mean_Class_i[0]^2+Mean_Class_i[1]^2)
    % // Thus Disciminant function is
    % // G_Class_i= Mean_Class_i[0]*X_patt[0]+Mean_Class_i[1]*X_patt[1]
    % // -0.5*(Mean_Class_i[0]^2+Mean_Class_i[1]^2) be maximum

    % Calculate mean vectors for each class
    N_feat=size(unknown_pattern,2);

    for j=1:N_feat
        Mean_Class1(j)=mean(class1(:,j));
        Mean_Class2(j)=mean(class2(:,j));
    end

    % unknown_f1 = unknown_pattern(1);
    % unknown_f2 = unknown_pattern(2);

    G_Class_1=0;
    G_Class_2=0;
    for i=1:N_feat  % G discriminant functions, one for each N_feat class
        G_Class_1 = G_Class_1 + Mean_Class1(i)*unknown_pattern(i) - 0.5*Mean_Class1(i)^2;
        G_Class_2 = G_Class_2 + Mean_Class2(i)*unknown_pattern(i) - 0.5*Mean_Class2(i)^2;
    end
    
    fprintf(1,'\nFor Unknown Pattern: %6.2f, %6.2f \n', unknown_pattern(1), unknown_pattern(2));
    fprintf('Discriminant 1: %6.2f\n', G_Class_1);
    fprintf('Discriminant 2: %6.2f\n', G_Class_2);
    
    % classify
    if (G_Class_1 > G_Class_2) classified = 1; end;
    if (G_Class_1 < G_Class_2) classified = 2; end;
    if (G_Class_1 == G_Class_2) classified=0;fprintf (1,'\n Unknown Pattern Belongs to no class\n');end;
end % of MDC classifier



%--------------------------------------------------------------------------
%----------------------plotScatter-----------------------------------------
%--------------------------------------------------------------------------
function []=plotScatter(unknown_pattern,class1,class2)
    plot(class1(:,1), class1(:,2), 'gs');
    hold on;
    plot(class2(:,1), class2(:,2), 'bo');
    plot(unknown_pattern(1), unknown_pattern(2), 'r*');
    N_feat=size(unknown_pattern,2);
    % %----------------Plot decision boundary-------------
    % Calculate mean vectors for each class
    for j=1:N_feat 
      Mean_Class1(j)=mean(class1(:,j));
      Mean_Class2(j)=mean(class2(:,j));
    end 
    axis equal;
    v=axis;
    [X,Y]=meshgrid(v(1):v(2),v(3):v(4)); % form grid

    % replace x,y by grid X,Y and calculate Z=G1-G2
    Z=Mean_Class1(1)*X+Mean_Class1(2)*Y-0.5*(Mean_Class1(1)^2+Mean_Class1(2)^2)- ...
        (Mean_Class2(1)*X+Mean_Class2(2)*Y-0.5*(Mean_Class2(1)^2+Mean_Class2(2)^2));
    contour(X,Y,Z,[0,0],'r'); % plot Z=0, i.e. decision boundary
    legend('Class 1','Class 2');
    grid on;
end %od plotScatter



%--------------------------------------------------------------------------
%-------------------KNN_classifier-----------------------------------------
%--------------------------------------------------------------------------
function[classified]=KNN_classifier(unknown_pattern,class1,class2,knn_choice,neighbours)
    features=size(class1,2); %   # features in each class
    N1=size(class1,1);       %   # patterns in class1
    N2=size(class2,1);       %   # patterns in class2

    %1.Find distances of unknown_pattern from patterns of class 1
    for i=1:N1
        d=0;
        for j=1:features
            d=d+sqrt((unknown_pattern(j)-class1(i,j))^2);
        end
        val1(i,1)=d;
        val1(i,2)=1;
    end

    %1.Find distances of unknown_pattern from patterns of class 2
    for i=1:N2
        d=0;
        for j=1:features
            d=d+sqrt((unknown_pattern(j)-class2(i,j))^2);
        end
        val2(i,1)=d;
        val2(i,2)=2;
    end
    
    if (knn_choice==1)
        q1=min(val1);
        q2=min(val2);
    
        if (q1<q2) 
            classified=1; 
        else
            classified=2;
        end
        
    elseif (knn_choice==2)
        val=[val1;val2];
        sort_val=sortrows(val,1); %taksinomisi twn apostasewn se auksousa seira
        counter1=0;
        counter2=0;

        for i=1:neighbours %pairnoume tous k prwtous geitones pou eixe epileksei o xristis na trexei to programma
            if (sort_val(i,2)==1) %an anikei stin 1i klasi auksanetai o metritis tis 1is klasis alliws auksanetai o metritis tis 2is klasis
                counter1=counter1+1; 
            else
                counter2=counter2+1;
            end
        end
        
        if (counter1>counter2) 
            classified=1; 
        end;
        if (counter1<counter2) 
            classified=2; 
        end;
        if (counter1==counter2)
            classified=0; 
        end;
        
    elseif (knn_choice==3)
        sort_val1=sort(val1(:,1)); %taksinomisi twn apostasewn tis klasis1 se auksousa seira
        sort_val2=sort(val2(:,1)); %taksinomisi twn apostasewn tis klasis2 se auksousa seira
        
        d1=mean(sort_val1(1:neighbours));
        d2=mean(sort_val2(1:neighbours));

        if (d1<d2) 
            classified=1; 
        end;
        if (d1>d2) 
            classified=2; 
        end;
        if (d1==d2) 
            classified=0; 
        end
        
    elseif (knn_choice==4)
        val=[val1;val2];
        sort_val=sortrows(val, 1); %taksinomisi twn apostasewn se auksousa seira
        votes1=0;
        votes2=0; %the votes of these records are weighted according to the inverse square of their distances

        for i=1:neighbours %pairnoume tous k prwtous geitones pou eixe epileksei o xristis na trexei to programma
            if (sort_val(i,2)==1)
                votes1=votes1+1/(sort_val(i,1)+1);
            else
                votes2=votes2+1/(sort_val(i,1)+1);
            end
        end
        
        if (votes1>votes2) 
            classified=1; 
        end;
        if (votes1<votes2)
            classified=2;
        end;
        if (votes1==votes2) 
            classified=0;
        end
    end
end



%--------------------------------------------------------------------------
%-------------------PNN_classifier-----------------------------------------
%--------------------------------------------------------------------------
function [classified]=PNN_classifier(X_patt,class1,class2,pnn_choice)
% //--------------------------PNN-------------------------------------
% //Class1
    N_feat=size(X_patt,2);							
    N_patt_C1=size(class1,1);
    N_patt_C2=size(class2,1);

    PI=3.14159;sigma=0.24;

    %find exponential distaces of X_patt from class1 patterns
    val1=(2*PI)^(N_feat/2)*(sigma^N_feat)*N_patt_C1;
    val2=(2*PI)^(N_feat/2)*(sigma^N_feat)*N_patt_C2;
    
    if (pnn_choice==1) % Gaussian function
        sumi=0;
        for i=1:N_patt_C1
            sumj=0;
            for j=1:N_feat
                sumj=sumj+(class1(i,j)-X_patt(j))^2;
            end % //j
            sumi=sumi+exp(-sumj/(2*sigma^2));
        end % //i
        G_Class_1=sumi/val1;


        val2=(2*PI)^(N_feat/2)*(sigma^N_feat)*N_patt_C2;
        sumi=0;
        for i=1:N_patt_C2
            sumj=0;
            for j=1:N_feat
                sumj=sumj+(class2(i,j)-X_patt(j))^2;
            end % //j
            sumi=sumi+exp(-sumj/(2*sigma^2));
        end % //i
        G_Class_2=sumi/val2;
        
    elseif (pnn_choice==2)  % Exponential function
        sumi=0;
        for i=1:N_patt_C1
            sumj=0;
            for j=1:N_feat
                sumj=sumj+abs(class1(i,j)-X_patt(j));
            end % //j
            sumi=sumi+exp(-sumj/sigma);
        end % //i
        G_Class_1=sumi/val1;


        val2=(2*PI)^(N_feat/2)*(sigma^N_feat)*N_patt_C2;
        sumi=0;
        for i=1:N_patt_C2
            sumj=0;
            for j=1:N_feat
                sumj=sumj+abs(class2(i,j)-X_patt(j));
            end % //j
            sumi=sumi+exp(-sumj/sigma);
        end % //i
        G_Class_2=sumi/val2;
        
    elseif (pnn_choice==3) % Reciprocal function
        sumi=0;
        for i=1:N_patt_C1
            sumj=0;
            for j=1:N_feat
                sumj=sumj+(class1(i,j)-X_patt(j))^2;
            end % //j
            sumi=sumi+1/(1+sumj/(sigma^2));
        end % //i
        G_Class_1=sumi/val1;


        val2=(2*PI)^(N_feat/2)*(sigma^N_feat)*N_patt_C2;
        sumi=0;
        for i=1:N_patt_C2
            sumj=0;
            for j=1:N_feat
                sumj=sumj+(class2(i,j)-X_patt(j))^2;
            end % //j
            sumi=sumi+1/(1+sumj/(sigma^2));
        end % //i
        G_Class_2=sumi/val2;
    end
    
    fprintf('Discriminant 1: %6.2f\n',G_Class_1);
    fprintf('Discriminant 2: %6.2f\n',G_Class_2);
    
    if (G_Class_1 > G_Class_2) classified=1; end;
    if (G_Class_1 < G_Class_2) classified=2; end;
    if (G_Class_1 == G_Class_2) fprintf(1,'\n Unknown Pattern Belongs to no class\n');classified=0; end;
end


%--------------------------------------------------------------------------
%-------------------Bayesian_classifier------------------------------------
%--------------------------------------------------------------------------
function [classified]=Bayesian_classifier(X_patt,class_a,class_b)
    [inv_mean_covariance]=BC_inverse_covariance(class_a,class_b); % C^-1
    G_Class_1=computeDiscrValue(X_patt,class_a,inv_mean_covariance);
    G_Class_2=computeDiscrValue(X_patt,class_b,inv_mean_covariance);
    
    
    if (G_Class_1 > G_Class_2) classified=1;end;
    if (G_Class_1 < G_Class_2) classified=2;end;
    if (G_Class_1 == G_Class_2) 
        fprintf (1,'\n Unknown Pattern Belongs to no class\n');
        classified=0; 
    end;
end

%==========================================================================
function [d]=computeDiscrValue (X_patt,class,inv_mean_covariance)
    Mean_Class=mean(class); % m
    G1=(X_patt*inv_mean_covariance)*Mean_Class'; % x^T*C^-1*m
    G2=(Mean_Class*inv_mean_covariance)*Mean_Class'; % m^T*C^-1*m
    d=G1-0.5*G2; %x^T*C^-1*m-0.5*m^T*C^-1*m
end
%==========================================================================
function [inv_m_covar]=BC_inverse_covariance(class1,class2)
    covar1=cov(class1,1);   % covariance of class1
    covar2=cov(class2,1);   % covariance of class2
    m_covar=(covar1+covar2)/2;  % mean covariance
    inv_m_covar=inv(m_covar);   % inverse of mean covariance
end


%--------------------------------------------------------------------------
%-------------------Bayesian_classifier------------------------------------
%--------------------------------------------------------------------------
function [classified]=QuadraticBayesian_classifier(X_patt,class_a,class_b)
    p1=0.5;
    p2=0.5;
    [mean_covariance]=BC_covariance(class_a,class_b); % C
    [inv_mean_covariance]=BC_inverse_covariance(class_a,class_b); % C^-1

    G_Class_1=computeQuadrDiscrValue(X_patt,class_a,p1,mean_covariance,inv_mean_covariance);
    G_Class_2=computeQuadrDiscrValue(X_patt,class_b,p2,mean_covariance,inv_mean_covariance);
    
    if (G_Class_1 > G_Class_2) classified=1;end;
    if (G_Class_1 < G_Class_2) classified=2;end;
    if (G_Class_1 == G_Class_2) 
        fprintf (1,'\n Unknown Pattern Belongs to no class\n');
        classified=0; 
    end;
end

%==========================================================================
function [d] = computeQuadrDiscrValue (X_patt, class, p, mean_covariance, inv_mean_covariance)
    Mean_Class=mean(class); % m
    G=(X_patt-Mean_Class)*inv_mean_covariance*(X_patt-Mean_Class)'; % (x-m)^T*C^-1*(x-m)
    d=log(p)-0.5*log(det(mean_covariance))-0.5*G; % ln(p)-0.5*ln(C)-0.5*(x-m)^T*C^-1*(x-m)
end
%==========================================================================
function [m_covar] = BC_covariance(class1, class2)
    covar1=cov(class1,1); %covariance of class1
    covar2=cov(class2,1); %covariance of class2
    m_covar=(covar1+covar2)/2; %mean covariance
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [classified]=Perceptron_classifier_separable_classes (unknown_pattern,class1,class2)
    %label patterns in class1 and class2 2 as 1 and -1 resp
    classLabels =[ones(1,size(class1,1)) (-1)*ones(1,size(class2,1))]';
    superClass=[class1;class2];%form superclass
    assist=ones(1,size(superClass,1));%for adding 1 at end of features
    superClass=[superClass assist'];%extend features by 0
    NNweights=designNN(superClass, classLabels);%calculate weights
    classified= Final_classification(unknown_pattern,NNweights);
end


%=====================functions ======================================
function [wend]=designNN(superClass, classLabels)
    [initialW]=initWeights(superClass);
    c=1;%c>0;
    w=initialW;
    % count=0;
    numberOfAllPatterns=size(superClass,1);
    wstart=initialW;
    for periods =1:500
        wstart=w;
        for i=1:numberOfAllPatterns
            y=superClass(i,:);
            value=w*y';
            if (classLabels(i)==1 && value<=0)%i.e missclassified
                w=w+c*y;%equation 9.3.34 Conzalez or relation 2.2 above
            elseif (classLabels(i)==-1 && value>=0)%i.e missclassified
                w=w-c*y;%equation 9.3.35 Conzalez or relation 2.3 above
            else
                w=w;%equation 9.3.36 Conzalez or relation 2.4 above
            end;
            wend=w;
        end
    end
end

%-----------------------------------------------------------------------
function [initialW]=initWeights(superClass)
    %initialize randomly weights between -1 and 1
    L=size(superClass,2);
    for j=1:L
        sign=rand(1);if(sign<0.5) sign=-1;else sign=1;end;
        initialW(j)=sign*rand(1);
    end
end

%-----------------------------------------------------------------------
function [classified]= Final_classification(unknown_pattern,NNweights)
    value=0;
    N_feat=size(unknown_pattern,2);
    for j=1:N_feat
        value=value+unknown_pattern(j)*NNweights(j); %equation 2.1 above
    end
    if (value>=0) classified=1;
    elseif (value<=0)classified=2;
    end
end


function [classified]=Perceptron_classifier_nonseparable_classes (unknown_pattern,class1,class2)
    %label patterns in class1 and class2 2 as 1 and -1 resp
    classLabels =[ones(1,size(class1,1)) (-1)*ones(1,size(class2,1))]';
    superClass=[class1;class2];%form superclass
    assist=ones(1,size(superClass,1));%for adding 1 at end of features
    superClass=[superClass assist'];%extend features by 1
    
    % we change the below two calls in functions from the originals given
    % in class notes due to redefinition for some other functions defined 
    % above
    
    NNweights=designNN2(superClass, classLabels);%calculate weights
    classified= Final_classification2(unknown_pattern,NNweights);
end

%=====================functions ==========================================
function [wend]=designNN2(superClass, classLabels)
    [initialW]=initWeights(superClass);
    alpha=0.1;%0.1<alpha<1.0
    w=initialW;
    numberOfAllPatterns=size(superClass,1);
    for periods =1:1000
        wstart=w;
        for i=1:numberOfAllPatterns
            y=superClass(i,:);%for each pattern
            classified= classify_X(y,classLabels(i),w);%classify pattern
            if (classLabels(i)==1 && classified~=1)%i.e. misclassification
                w=w+alpha*(classLabels(i)-w*y')*y;%equation 9.3-40 in Conzalez or relation 2.12 above
            elseif (classLabels(i)==-1 && classified~=2)%i.e. misclassification
                w=w+alpha*(classLabels(i)-w*y')*y;%equation 9.3-40 in Conzalez or relation 2.13 above
            else
                w=w;% relation 2.14 above
            end;
            wend=w;
        end
    end
end

function [classified]= classify_X(X_patt,X_patt_label,NNweights)
    value=0;
    N_feat=size(X_patt,2);
    for j=1:N_feat
        value=value+X_patt(j)*NNweights(j);
    end
    if (X_patt_label>0 && value>=0) classified=1;
    elseif (X_patt_label<0 && value<=0)classified=2;
    else classified=0;
    end
end

%-----------------------------------------------------------------------
function [classified]= Final_classification2(unknown_pattern,NNweights)
    value=0;
    N_feat=size(unknown_pattern,2);
    value=0;
    for j=1:N_feat
        value=value+unknown_pattern(j)*NNweights(j);
    end
    valueC1=0.5*(1.0-value)^2;%Evaluate eq 9.3.37 for class1 or relation 2.11a above
    valueC2=0.5*(-1.0-value)^2;%Evaluate eq 9.3.37 for class2 or relation 2.11b above
    if (valueC1<valueC2) classified=1;%i.e. to class1
    elseif ( valueC2<=valueC1) classified=2;%i.e. to class2
    end
end



function [classified]= ANN_Matlab_classifier (unknown_pattern,class1,class2)
    %Using Matlab routines
    classLabels =[ones(1,size(class1,1)) (-1)*ones(1,size(class2,1))]';
    superClass=[class1;class2];%form superclass
    % superClass=mapstd(superClass')';%Normalize data to 0 mean
    [net]=designNN(superClass, classLabels);
    [classified]= classify_X2(unknown_pattern,net);
end

%======================FUNCTIONS============================================
function [classified]= classify_X2(X_patt,net)
    % 4. TEST ANN
    G_class = sim(net,X_patt'); % the sign of sim is the classification result,
    % e.g. positive result means that the the test pattern classified to the class
    % with y=1, and negative result to the class with y=-1
    %classify pattern
    if (G_class>0) classified=1;
    %i.e. correctly classified
    elseif (G_class<0)classified=2;%i.e. correctly classified
    else classified=0;%i.e. incorrectly classified
    end
end

%----------------------------------------------------------------------------
function [net]=designNN3(superClass,classLabels)
    % node structure
    nodes = [8,8,1]; % ATTENTION! The number of layers must match the number of function labels in transNodeFunction
    % transfer function between layers
    transNodeFunction = {'logsig','logsig','purelin'}; % logsig = logarithmic sigmoidal, purelin = linear
    % training method
    trainingMethod = 'trainlm'; % training Resilient Backpropagation % trainlm = fast, trainrp = previous 'default'
    % create net
    net = newff(minmax(superClass'),nodes,transNodeFunction,trainingMethod);
    net = init(net); % initialize net
    % training parameters
    net.trainParam.show = NaN;
    net.trainParam.lr = 0.005;
    net.trainParam.epochs = 500;
    net.trainParam.goal = 1e-3;
    % train net
    net.trainParam.showWindow = 0;
    [net,tr]=train(net,superClass',classLabels');
end



function [classified]=SVM_classifier(unknown_pattern,class1,class2)
    classLabels =[ones(1,size(class1,1)) (-1)*ones(1,size(class2,1))]';%puts labels to belonging to class1 and 2 as 1 and -1 resp
    superClass=[class1;class2];%form superclass
    DataUpperBound=max(max(superClass));%Kecman page 157
    [a]=designSVM(superClass, classLabels,DataUpperBound);%calculate Langrangians
    [classified]= classify_X3(unknown_pattern,superClass, classLabels,a);%using Langrangians previously calculated, classify data
end

%==================Functions===========================
function [a]=designSVM(TrainData,TrainLabels,DataUpperBound)
    % SOLVE OPTIMIZATION AND FIND LANGRANGE MULTIPLIERS
    % KERNEL MAPPING FOR TRAINING DATA in the case of LOO
    for j=1:size(TrainData,1)
        for i=1:size(TrainData,1)
            %prior to calling quadprog have to insert Hessian:
            % From theory Hessian matrix H=yiyjk(xixj)
            % y(i)*y(j)*(x(i).x(j));%!!!!!!!!!!!!!!! %page 157 Kecman
            kx=TrainLabels(j)*TrainLabels(i)*TrainData(j,:)*TrainData(i,:)';
            HessianMatrix(j,i)=kx; %store in kernel matrix
        end
    end
    f=-ones(size(TrainData,1),1);%%page 157 Kecman
    %Aeq(of quadpro)->TrainLabels->y^T%page 157 Kecman eq 2.56b
    %beq(of quadpro)->0--->0 page 157 Kecman eq 2.56b
    %lb(of quadpro)-->zeros(size(TrainData,1),1)-->a>=0 page 157 Kecman eq 2.56c
    %ub(of quadpro)-->the max of normalized training data i.e.
    %DataUpperBound*ones(size(TrainData,1),1)
    a = quadprog (HessianMatrix,f,[],[],TrainLabels',0,...
    zeros(size(TrainData,1),1), DataUpperBound*ones(size(TrainData,1),1));
    %Lagrangians a are calculated using the kernel formed by the Training Dataset
end
%================================================================

function [classified]= classify_X3(TestData,TrainData, TrainLabels, a)
    %%KERNEL MAPPING FOR TEST DATA. Form new kernel matrix for each one of the TEST data
    size(TestData)
    size(TrainData)
    for i=1:size(TrainData,1)
        kx=TestData*TrainData(i,:)';% KERNEL %The linear kernel: k(xi,xj) = x.xi
        TestDataKernel_matrix(i)=kx;
	end
    %form discriminant function, see relation 3.8 above
    % , here b=0, i.e. hyper-plane through 0,0 axis
    temp=0;
    for i=1:size(TrainData,1)
        temp=temp+TrainLabels(i)*a(i)*TestDataKernel_matrix(i);
    end
    %classify pattern
    if (temp>=0) classified=1;%i.e. correctly classified
    elseif (temp<=0)classified=2;%i.e. correctly classified
    else classified=0;%i.e. incorrectly classified
    end
end


function [classified]=SVM_Matlab_classifier(unknown_pattern,class1,class2)
    warning off all
    classified=0;
    classLabels =[ones(1,size(class1,1)) (-1)*ones(1,size(class2,1))]';
    %puts labels to class1 and 2 as 1 and -1 resp
    superClass=[class1;class2];%form superclass
    [SVMStruct]=designSVM2(superClass,classLabels);
    [classified]= classify_X4(unknown_pattern,SVMStruct);
end

%======================FUNCTIONS============================================
function [classified]= classify_X4(X_patt,SVMStruct)
    G_class = svmclassify(SVMStruct, X_patt, 'Showplot', false);
    %classify pattern
    if (G_class>=0) classified=1;%i.e. correctly classified
    elseif (G_class<=0)classified=2;%i.e. correctly classified
    else classified=0;%i.e. incorrectly classified
    end
end
%----------------------------------------------------------------------------
function [SVMStruct]=designSVM2(superClass,classLabels);
    SVMStruct = svmtrain(superClass, classLabels, 'Kernel_Function', 'linear', 'Polyorder', 3, 'Method', 'LS', 'ShowPlot', false);
    % values for 'Kernel_Function': 'linear', 'quadratic', 'polynomial', 'rbf', 'mlp'
    % if 'Kernel_Function' is 'polynomial', then values for 'Polyorder': 1,2,3,... (default=3)
    % if 'Kernel_Function' is 'mlp', then values for 'Mlp_Params': [p1 p2], where p1>0, p2<0 (default p1=1, p2=-2) the parameters of the kernel function: K = tanh(p1*U*V'+ p2)
    % values for 'Method': 'QP', 'LS' that stands for Quadratic Programming (default if Optimization toolbox if installed), and Least Square: it's the method to find the separating hyperplane.
    % if 'Method' is 'QP', then values for 'QuadProg_Opts': [p1 p2], where p1>0, p2<0 (default p1=1, p2=-2) the parameters of the kernel function: K = tanh(p1*U*V' + p2)
    % values for 'ShowPlot': true, false: plots (or not) data and separating
    % line (for 2D data only)
end


%% My functions

function [classified]=LDA_Matlab_classifier(unknown_pattern,class1,class2)
    classLabels=[ones(1,size(class1,1)) 2 * ones(1,size(class2,1))]';
    superClass=[class1;class2]; %form superclass
    [classified]=classify(unknown_pattern,superClass,classLabels,'linear');
end

function [classified]=QDA_Matlab_classifier(unknown_pattern,class1,class2)
    classLabels=[ones(1,size(class1,1)) 2 * ones(1,size(class2,1))]';
    superClass=[class1;class2]; %form superclass
    [classified]=classify(unknown_pattern,superClass,classLabels,'quadratic');
end

function [classified]=DTC_Matlab_classifier(unknown_pattern,class1,class2)
    classLabels=[ones(1,size(class1,1)) 2 * ones(1,size(class2,1))]';
    superClass=[class1;class2]; %form superclass
    tree=treefit(superClass, classLabels);
    [classified]=eval(tree,unknown_pattern);
end



function [temp_classified]=scheme_classifier(unknown_pattern,class1,class2,label,scheme)
    classLabels=[ones(1,size(class1,1)) 2 * ones(1,size(class2,1))]';
    superClass=[class1;class2];  %form superclass

    d1 = zeros(1,3);  
    d2 = zeros(1,3);
    
    for i=1:3
        if (i==1)
            g=scheme_MDC_classifier(unknown_pattern,class1,class2);
        elseif (i == 2)
            neighbours=5;
            g=scheme_KNN_classifier(unknown_pattern,class1,class2,neighbours);
        else
            PNN_function=2;
            g=scheme_PNN_classifier(unknown_pattern,class1,class2,PNN_function);
        end
        
        if (g(1)>g(2)) temp_classified=1; end;
        if (g(1)<g(2)) temp_classified=2; end;
        if (g(1)==g(2)) temp_classified=0; end;
        
        if (temp_classified==label) && (temp_classified==1)
            d1(i)=1;
        end
        
        if (temp_classified==label) && (temp_classified==2) 
            d2(i)=1;
        end
        
        g_matrix(i,1)=g(1);
        g_matrix(i,2)=g(2);
    end
    
    g11=g_matrix(1,1); g12=g_matrix(1,2); 
    g21=g_matrix(2,1); g22=g_matrix(2,2);
    g31=g_matrix(3,1); g32=g_matrix(3,2);

    p11=exp(g11)/(exp(g11)+exp(g12));
    p12=exp(g12)/(exp(g11)+exp(g12));

    p21=exp(g21)/(exp(g21)+exp(g22));
    p22=exp(g22)/(exp(g21)+exp(g22));

    p31=exp(g31)/(exp(g31)+exp(g32));
    p32=exp(g32)/(exp(g31)+exp(g32));

    
    %-------------------RULES---------------
    switch (scheme)
        case 1 %Majority Vote
            G1=0; G2=0;
            for i=1:3
                G1=G1+d1(i);
                G2=G2+d2(i);
            end
        case 2 %Product rule
            G1=p11*p21*p31;
            G2=p12*p22*p32;
        case 3 %Sum rule
            G1=p11+p21+p31;
            G2=p12+p22+p32;
        case 4 %Max rule
            G1=max([p11 p21 p31]);
            G2=max([p12 p22 p32]);
        case 5 %Min rule
            G1=min([p11 p21 p31]);
            G2=min([p12 p22 p32]);
    end
    if (G1>G2) classified=1; end;
    if (G1<G2) classified=2; end;
    if (G1==G2) classified=0; end;
end


function [g]=scheme_KNN_classifier(unknown_pattern,class1,class2,neighbours)
    features=size(class1,2); %features in each class
    N1=size(class1,1); %patterns in class1
    N2=size(class2,1); %patterns in class2

    %find distances of unknown_pattern from patterns of class 1
    for i=1:N1
        d=0;
        for j=1:features
            d=d+sqrt((unknown_pattern(j)-class1(i,j))^2);
        end
        val1(i,1)=d;
        val1(i,2)=1;
    end

    %find distances of unknown_pattern from patterns of class 2
    for i=1:N2
        d=0;
        for j=1:features
            d=d+sqrt((unknown_pattern(j)-class2(i,j))^2);
        end
        val2(i,1)=d;
        val2(i,2)=2;
    end

    val=[val1;val2];
    sort_val=sortrows(val,1);
    counter1=0; counter2=0;

    for i=1:neighbours 
        if (sort_val(i,2)==1) 
            counter1=counter1+1; 
        else
            counter2=counter2+1;
        end
    end

    g=[counter1 counter2];
end

function [g] = scheme_MDC_classifier(unknown_pattern,class1,class2)
    N_feat = size(unknown_pattern, 2);

    for i = 1 : N_feat
        Mean_Class1(i) = mean(class1(:, i));
        Mean_Class2(i) = mean(class2(:, i));
    end

    G_Class_1 = 0;
    G_Class_2 = 0;
    for i = 1 : N_feat
        G_Class_1 = G_Class_1 + Mean_Class1(i) * unknown_pattern(i) - 0.5 * Mean_Class1(i) ^ 2;
        G_Class_2 = G_Class_2 + Mean_Class2(i) * unknown_pattern(i) - 0.5 * Mean_Class2(i) ^ 2;
    end
    
    g = [G_Class_1 G_Class_2];
end

function [g] = scheme_PNN_classifier(unknown_pattern, class1, class2, PNN_function)
    N_feat = size(unknown_pattern, 2);							
    N_patt_C1 = size(class1, 1);
    N_patt_C2 = size(class2, 1);
    sigma = 0.24;

    val1=(2*pi)^(N_feat/2)*(sigma^N_feat)*N_patt_C1;
    val2=(2*pi)^(N_feat/2)*(sigma^N_feat)*N_patt_C2;
    
    if (PNN_function == 1) %Gaussian
        sumi=0;
        for i=1:N_patt_C1
            sumj=0;
            for j=1:N_feat
                sumj=sumj+(class1(i,j)-unknown_pattern(j))^2;
            end
            sumi=sumi+exp(-sumj/(2*sigma^2));
        end
        G_Class_1=sumi/val1;


        val2=(2*pi)^(N_feat/2)*(sigma^N_feat)*N_patt_C2;
        sumi=0;
        for i=1:N_patt_C2
            sumj=0;
            for j=1:N_feat
                sumj=sumj+(class2(i,j)-unknown_pattern(j))^2;
            end
            sumi=sumi+exp(-sumj/(2*sigma^2));
        end
        G_Class_2 = sumi / val2;
    elseif (PNN_function == 2)
        sumi = 0;
        for i=1:N_patt_C1
            sumj = 0;
            for j=1:N_feat
                sumj=sumj+abs(class1(i,j)-unknown_pattern(j));
            end
            sumi=sumi+exp(-sumj/sigma);
        end
        G_Class_1=sumi/val1;


        val2=(2*pi)^(N_feat/2)*(sigma^N_feat)*N_patt_C2;
        sumi = 0;
        for i=1:N_patt_C2
            sumj = 0;
            for j=1:N_feat
                sumj=sumj+abs(class2(i,j)-unknown_pattern(j));
            end
            sumi=sumi+exp(-sumj/sigma);
        end
        G_Class_2=sumi/val2;
    elseif (PNN_function == 3)
        sumi = 0;
        for i=1:N_patt_C1
            sumj = 0;
            for j=1:N_feat
                sumj = sumj + (class1(i, j) - unknown_pattern(j)) ^ 2;
            end
            sumi=sumi+1/(1+sumj/(sigma^2));
        end
        G_Class_1 = sumi / val1;


        val2=(2*pi)^(N_feat/2)*(sigma^N_feat)*N_patt_C2;
        sumi = 0;
        for i=1:N_patt_C2
            sumj = 0;
            for j=1:N_feat
                sumj=sumj+(class2(i, j)-unknown_pattern(j))^2;
            end
            sumi=sumi+1/(1+sumj/(sigma^2));
        end
        G_Class_2 = sumi / val2;
    end
    
    g = [G_Class_1 G_Class_2];
end

function [superClass]=normalize(superClass)
    superClass=superClass';
    superClass=mapstd(superClass);
    superClass=superClass';
end