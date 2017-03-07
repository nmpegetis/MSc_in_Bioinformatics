%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function normalizes and scales all the image values from 
%% the initial range of real values to the normalized and scaled range of 
%% values that exist in an interval set by user
%% Filename: imageIntervalScalling.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []=imageIntervalScalling()
clear all;close all;clc;

A=imread('./images/Pelvis.bmp');    % another image file can also be used
A=double(A);
x=size(A,1);y=size(A,2);


% expand image to (interval_min - interval_max)

% interval min and max initialization
interval_min=-1;interval_max=-1;

% check controls to get the correct values for the interval min and max
while interval_min < 0 || interval_min > 255 
    interval_min = input('Give interval min interval value:  ');
end; 
while (interval_max < 0 || interval_max > 255) || interval_min > interval_max
    interval_max = input('Give interval max interval value:  ');
end; 

max_A=max(max(A));  % maximum element (gray value) of original image A
min_A=min(min(A));  % minimum element (gray value) of original image A

for i=1:x 
    for j=1:y 
        val=A(i,j);   % val takes the real ('double') values of A(i,j)
        tone_ival=(((val-min_A)/(max_A-min_A))*(interval_max-interval_min))+interval_min; 
            % the final addition is done because we want the variation to begin
            % from the min value of the interval and not from 1. 
            % e.g. 200 - 250 is an interval in lighted region. We want our 
            % scalled output to be found between 50 scales and we also want 
            % them to begin from 200, not from 1, to be illuminated (not darkened).

            % B represents the normalized image set by tone_ival
            % tone_ival takes for every pixel of the initial image
            % a normalized value in the interval set by the user, beginning
            % from the min limit of the interval
        B(i,j)=tone_ival;
    end; 
end; 
max_B=max(max(B));min_B=min(min(B));
[min_A max_A min_B max_B]
% %========= PLOT IMAGES =====================
colormap('gray');
 
subplot(2,2,1);imagesc(A, [0 255] );xlabel('Original Image Plot');
axis equal;axis([1 size(A,2) 1 size(A,1)]);
 
subplot(2,2,2);imagesc(B, [0 255]);xlabel('Scalled Image Plot');
axis equal;axis([1 size(B,2) 1 size(B,1)]);

pause(10);  % pause the system before re-running the same execution for 10s
            % so that user can select on any image and the proccess will be
            % terminated

end
