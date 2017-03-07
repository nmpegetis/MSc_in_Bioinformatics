%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function intitially uses all the previous task's 
%% normalization and scalling to the initial image. Then it constructs a
%% 20x20 pixels ROI at the center of the image and subsequently it
%% calculates the mean value and the standared deviation by using our own
%% functions and then by verifying them with the matlab's respective
%% functions. Finally it draws an histogram of both the original and the 
%% scaled image. The histogram contains in the y-axis the number of the 
%% pixel and in the x-axis the gray-value.
%% Filename: imageHistogram.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []=imageHistogram()
clear all;close all;clc;


A=imread('./images/Pelvis.bmp');    % another image file can also be used
A=double(A);
x=size(A,1);y=size(A,2);
 

% *** task 1 ***
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
figure 
subplot(2,2,1);imagesc(A, [0 255] );xlabel('Original Image Plot');
axis equal;axis([1 size(A,2) 1 size(A,1)]);
 
subplot(2,2,2);imagesc(B, [0 255]);xlabel('Scalled Image Plot');
axis equal;axis([1 size(B,2) 1 size(B,1)]);
 
% end of *** task 1 ***

% *** task 2 ***

x_dist = 20;
y_dist = 20;

% set the ROI on the new image that we scalled earlier -matrix B-
colormap('gray'); 
figure              % creates a new figure object to be displayed in a new 
                    % window for the image below, and not overwrite the
                    % previous
new_img=B;                    
imagesc(new_img);   % display B matrix as an image, from whose center we will extract roi 20x20
colormap('gray');
  
[img_width img_height]=size(new_img);   % get dimensions of new_img
width=img_width/2;      % get the width where center is found
height=img_height/2;    % get the height where center is found

% set in 'roi' matrix the default values taken from a 20x20 rectangle in
% the center of the scaled image
for i=1:x_dist
    for j=1:y_dist
        roi(i,j) = new_img(width-10+i, height-10+j);
    end;
end;

figure
imagesc(roi);   % display roi 20x20 of B image's center
colormap('gray');


sum=0;  % initialization of the variable we are going to use for finding Mean and Standard Deviation

for i=1:x_dist
    for j=1:y_dist
        sum=sum+roi(i,j);   % find the sum of all pixels in the rectangle in order to find the mean value
    end
end
dimensions=x_dist*y_dist;
myMean=sum/dimensions     % my Mean: finds the mean value of roi values
matlabMean=mean(roi(:))   % MatLab Mean: default function for finding the mean value. We use it to verify 'myMean'
  
sum=0;
for i=1:x_dist
    for j=1:y_dist
        d=roi(i,j)-myMean;  % find difference of each cell with the 'mean' value
        sum=sum+(d*d);      % find the square value and add all these values for all cells of roi
    end
end
myStandardDeviation=sqrt(sum/(dimensions-1))    % my Standard Deviation: the st.dev. equals the foreword
matlabStandardDeviation=std(roi(:))             % MatLab Standard Deviation: in order to verify the above

% *** end of task 2 ***



% *** task 3 ***

figure;      % creates a new figure object to be displayed in a new       
             % window for the image below, and not overwrite the 
             % previous
subplot(2,2,1);imagesc(A, [0 255]);xlabel('Original Image');
axis equal;axis([1 size(A,2) 1 size(A,1)]);
subplot(2,2,2);imagesc(B, [0 255]);xlabel('Scaled Image');
axis equal;axis([1 size(B,2) 1 size(B,1)]);
colormap('gray');

round(A);
round(B);
figure;      % creates a new figure object for the original image histogram
x = 1:1:256;  % x takes all the gray values from 1 to 256 with accession 
              % number +1 of the original image. We could also set the
              % limits of the A region to make a histogram

% reshape image A to alter the two axes x-axis and y-axis
reshape_A = reshape(A, size(A,1)*size(A,2), 1);

% original image histogram plotting (x-axis=grey values, y-axis=number of 
% pixels)
hist(reshape_A, x);

figure;      % creates a new figure object for the scaled image histogram
y = 1:1:256;    % y takes all the gray values from 1 to 256 with accession
                % number +1 of the scalled image. We could also set the
                % limits of the B region to make a histogram


% reshape scalled image B to alter the two axes x-axis and y-axis
reshape_B = reshape(B, size(B,1)*size(B,2), 1);

hist(reshape_B, y);
 
pause

end