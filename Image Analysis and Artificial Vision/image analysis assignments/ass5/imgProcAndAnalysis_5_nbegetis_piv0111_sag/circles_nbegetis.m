%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Sangriotis Manolis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Filename: cirlces_nbegetis.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A program which uses three functions, according to the user selection. At
% first, if user selects the first choice, then the circle disks of the
% image given are admeasured. Else if the user selects the second choice,
% the dark circles of Image_2 are isolated and admeasured. And finally, if
% user selects the third choice, then the program separates the large
% circles from the minor and isolates them differently and at last
% admeasures them.

function []=circles_nbegetis()
%% first part of the program
    clear *;clc;
    close all; 
    
    im1=imread('./Image_1.tif');
    im2=imread('./Image_2.tif');
    im3=imread('./Image_3.tif');

    % Plot images
    colormap('gray');
    subplot(1, 3, 1); imagesc(im1); xlabel('Image_1');
    axis equal; axis([1 size(im1, 2) 1 size(im1, 1)]);

    subplot(1, 3, 2); imagesc(im2); xlabel('Image_2');
    axis equal; axis([1 size(im2, 2) 1 size(im2, 1)]);

    subplot(1, 3, 3); imagesc(im3); xlabel('Image_3');
    axis equal; axis([1 size(im3, 2) 1 size(im3, 1)]);
        
    
    choice=menu('Choose the image of cyclic disk you want to admeasure', 'Image_1', 'Image_2', 'Image_3');
    
    switch choice
        case 1
            im=imread('./Image_1.tif');
            func_1(im);
        case 2
            im=imread('./Image_2.tif');
            func_2(im);
         case 3
            im=imread('./Image_3.tif');
            func_3(im);
    end
end


%% function 1: the circle disks of the Image_1 are admeasured
function []=func_1(im)
    se=strel('disk',5,0);
    imshow(im);
    im=imerode(im,se);
    figure;
    imshow(im);
    imwrite(im,'Image_1_circles.bmp');
    [L,num]=bwlabel(im);
    msgbox(sprintf('Total circles in image are: %d',num))
end


%% function 2: the dark circles of Image_2 are isolated and admeasured
function []=func_2(im)
    figure;
    imshow(im)
    figure;
    imhist(im)
    imwrite(im,'Image_2_hist.bmp');
    % Threshold thresh=100 is used to distinguish the circles from the
    % background
    thresh=100;

    % The threshold procedure
    bw=ones(size(im))*255;
    for line=1:size(bw,1)
        for clmn=1:size(bw,2)
            if double(im(line,clmn)>thresh)
                bw(line,clmn)=0;
            end
        end
    end
    figure;imshow(bw,[])
    imwrite(bw,'Image_2_circles.bmp');

    % Selection of element structure.
    se=strel('disk',10,0);
    bw=imerode(bw,se);
    figure;
    imshow(bw,[]);
    imwrite(bw,'Image_2_circles_final.bmp');
    [L,num]=bwlabel(bw);
    msgbox(sprintf('Total circles in image are: %d',num));
end


%% function 3: the program separates the large circles from the minor and 
% isolates them differently and at last admeasures them.
function []=func_3(im)
    figure;
    imshow(im)
    % remove cyclic black line between the two white regions
    se=strel('disk',5,0);
    im=imclose(im,se);

    % find the complement of the image
    im=imcomplement(im);
    figure;
    imshow(im);
    imwrite(im,'Image_3_complement.bmp');
    [L,num1]=bwlabel(im);   % num1=big_circles_num+small_circles_num+1

    % erode to remove small cycles
    se=strel('disk',10,0);
    im=imerode(im,se);
    figure;
    imshow(im)
    imwrite(im,'Image_3_big_circles.bmp');
    [L,num2]=bwlabel(im);   % num1=big_circles_num+1

    big_circles_num=num2-1;
    small_circles_num=num1-big_circles_num-1;
    msgbox(sprintf('Total big circles in image are: %d \n and total small circles in image are: %d',big_circles_num,small_circles_num))
end
