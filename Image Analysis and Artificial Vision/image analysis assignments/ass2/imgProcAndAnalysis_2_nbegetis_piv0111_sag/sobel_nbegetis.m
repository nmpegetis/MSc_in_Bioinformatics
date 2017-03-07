%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Sangriotis Manolis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Filename: sobel_nbegetis.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []=sobel_nbegetis()

clear *;clc
close all;

A = imread('./Images/AIRPORT.tif'); % you can also select:
%                                   AIRPORT_with_noise_10.tif
%                                   clown.tif
%                                   MONUMENT.tif
%                                   WOMAN_WITH_NOISE.tif
%                                   WOMAN.tif

imshow(A);
imwrite(A,'./Output_images/sobel_AIRPORT.tif'); 

figure;

mask1= [ 0,1,2; 
        -1,0,1; 
        -2,-1,0];
mask2= [-2,-1,0; 
        -1,0,1; 
        0,1,2];

m=size(A,1);
n=size(A,2);
for i=2:m-1
    for j=2:n-1
        B(i,j)=sum(sum(double(A(i-1:i+1,j-1:j+1)) .* mask1)); 	
    end;
end;

B=uint8(B);
imshow(B);
imwrite(B,'./Output_images/sobel_AIRPORT_with_mask1.tif'); 

figure;

for i=2:m-1
    for j=2:n-1
        C(i,j)=sum(sum(double(A(i-1:i+1,j-1:j+1)) .* mask2)); 	
    end;
end;

C=uint8(C);
imshow(C);
imwrite(C,'./Output_images/sobel_AIRPORT_with_mask2.tif'); 

figure;

for i=2:m-1
    for j=2:n-1
        D(i,j)=max([C(i,j),B(i,j),B(i,j)+C(i,j)]);
    end;
end;

D=D-min(D(:));
D=D/max(D(:)) * 255;
D=uint8(round(D));
D=uint8(D);

imshow(D);
imwrite(D,'./Output_images/sobel_AIRPORT_without_threshold.tif'); 

figure;

threshold=0;
while threshold < 1 || threshold > 256 
    threshold = input('Give a threshold to be used with Sobel filtering (1-256):  ');
end;


for i=2:m-1
    for j=2:n-1
        if D(i,j) > threshold
            E(i,j)=255;
        else
            E(i,j)=0;
        end;
    end;
end;

E=uint8(E);
imshow(E);
imwrite(E,'./Output_images/sobel_AIRPORT_with_threshold.tif'); 

end