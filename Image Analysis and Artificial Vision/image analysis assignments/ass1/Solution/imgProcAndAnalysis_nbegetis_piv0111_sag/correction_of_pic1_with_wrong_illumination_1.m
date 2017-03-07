%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Sangriotis Manolis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function initially reads the wrong illuminated picture
%% and the illumination profile that exists in this picture, it corrects it
%% by removing the noise-illumination profile on the background and then by
%% thresholding it clears it. 
%% Filename: correction_of_pic1_with_wrong_illumination_1.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []=correction_of_pic1_with_wrong_illumination_1()

clear *; clc
close all

I8=imread('picture_with_wrong_illumination_1.bmp');
I8_profile=imread('source_illumination_profile_of_picture_1.bmp');

% imread reads an image of 8 bit per pixel assigning them to unsigned
% integers. But to perform operations on images' data, we firstly have to
% assign these 8 bpp pictures to 64 bpp.
% Later, we will round down again these 64 bpp to 8 bpp pictures, so as to
% construct the histograms.

I64=double(I8);
I64_profile=double(I8_profile);

% show initial images
figure;
imshow(I8);
figure;
imshow(I8_profile);


% find the illumination ratio between these two images 
ratio = I64./I64_profile; 


% We assume a real array 'van' where we place the ratio array, we found
% above, between the two pictures' illuminations
van = ratio;

% For the histogram construction from 'van' we normalize the signal 'van'
% to the [0,255] interval
ivan=van-min(van(:)); % first the array is transformed to [0,max(van)min(van)]
% after that van is quantised to 255 level

conx=1/max(ivan(:));
ivan=round(ivan*conx*255);

% round down real numbers to interers
ivan=uint8(ivan);   % transform array to unsigned integers

figure;
imshow (ivan); % correctly illuminated input image
imwrite(ivan,'picture_with_right_illumination_1.bmp'); % write picture in 
% bmp file

figure
imhist(ivan); % histogram of correctly illuminated input image

% now that the input picture is correctly illuminated we are going to place
% a threshold to make it clear

% do threshold operations using real numbers
I64_correctly_illuminated=double(ivan);


lines=size(I64_correctly_illuminated,1);
columns=size(I64_correctly_illuminated,2);

% for every pixel in array-picture if less than the threshold make it black
% else make it white.

for i=1:lines
    for j=1:columns
        if I64_correctly_illuminated(i,j) < 142     % 142 = threshold after 
% observation of the above histogram, see also threshold_placed_pic1.bmp
            I64_correctly_illuminated(i,j) = 0;
        else
            I64_correctly_illuminated(i,j) = 255;
        end
    end
end

% now the picture is cleared and illuminated
I64_final_picture_cleared_and_illuminated=I64_correctly_illuminated;
figure;
imshow(I64_final_picture_cleared_and_illuminated);
imwrite(I64_final_picture_cleared_and_illuminated,'picture_1_cleared.bmp'); 
% write in bmp file

end