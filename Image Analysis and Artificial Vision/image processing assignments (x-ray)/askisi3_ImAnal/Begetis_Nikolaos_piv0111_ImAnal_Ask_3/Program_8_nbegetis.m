%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Filename: Program_8_nbegetis.m
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LABWORK 3:
%
%    Form a function to calculate the 10 Run length features (i.e. 5 RL features but from each feature calculating the mean and range). Check results with included RL_features.pfunction, see how it is called within the provided program ROISAndFeatures.m in the 3rd lecture notes.
%    Form a function to calculate additional features, described in Section 7.2.2, pages 279-281 (in Book by Theodoridis and Koutroubas) under the title Local Linear Transforms for Texture Feature Extraction.
%    Use the provided program (ROISAndFeatures.m) to create your own 2 classes of at least 15 patterns in each class (each pattern consisting of all calculated features). Use as data
%
% imFileName1= {'MIC_Astrocytomas_HighGrade';'MIC_Astrocytomas_LowGrade'};
%
%    Using a fast classifier to begin with, test %accuracies of all possible feature combinations within the total number of features (i.e. combinations of 1s, 2s, 3s, …,up to 5, using Matlab’s nchoosek, see provided code below), by employing  the LOO method and by using a truth table. Retain the highest accuracy achieved with the least number of features. Repeat the experiment for all classifiers you have developed and end up with a PR-system that uses the best fastest classifier and best features combination that provides highest classification accuracy for the particular choice of classes.
%
% function []=Program_nchoosek()
% clc;echo off;close all;clear all;
% M1=3;% #patterns
% N1=5;%  #features
% M2=5;
% class1=rand(M1,N1);class2=rand(M2,N1)*2-0.5;
% class1
% class2
%
% N_feat=size(class1,2);
%
% for numberOfFeatures=1:N_feat
%    FeatsCombs=nchoosek(1:N_feat,numberOfFeatures);%create in cL feature combinations
%    fprintf('For %d feature-combinations\n',numberOfFeatures);
%    FeatsCombs
%    FeatsCombs_height=size(FeatsCombs,1);
%    FeatsCombs_width= size(FeatsCombs,2);
%    for height=1:FeatsCombs_height
%        c_1=class1(:,FeatsCombs(height,:));
%        c_2=class2(:,FeatsCombs(height,:));
%        fprintf('----------------------\n');
%        c_1
%        c_2
%    end
% fprintf('------------------------------------------------------------\n');
% end
%    Develop the feature selection techniques 2,3,4 and repeat step 4.
%    You should provide one final program capable of designing a PR-system to operate on 2 classes (that have been previously created using the ROISAndFeatures.m, provided program), where the choice of classifier, features selection method, and system evaluation method (i.e. self consistency or LOO) would be chosen by means of a MENU. Your deliverable should incorporate the code of your program with appropriate functions, the two classes of data (class1.dat and class2.dat), and a word document to report on your findings in questions 4 and 5 above.


% Program_8_nbegetis
function[]=Program_8_nbegetis()
    terminate=false;
    while (~terminate)
        choice=-1;
        while choice<0 || choice>3
            choice = input('Select the labworktask you want to test.\n1. Tasks 1-3.\n2. Tasks 4-5.\n3. Task 6.\nType selection (1-3). In order to terminate type 0:  ');
        end;
		switch (choice)
			case 0
				terminate=true;
			case 1
				Program_8_123_nbegetis();
			case 2
				Program_8_45_nbegetis();
			case 3
				Program_8_6_nbegetis();
		end
    end
end