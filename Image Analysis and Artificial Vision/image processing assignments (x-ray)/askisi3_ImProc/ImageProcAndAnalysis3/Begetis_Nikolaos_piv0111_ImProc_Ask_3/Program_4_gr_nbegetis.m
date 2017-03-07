%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function uses a main program which calls all the
%% functions implementing the median filter (p.11, class notes) and the
%% sharp filter (p.15, class notes) functions. More specifically, we
%% included these functions in the same program with the low pass or 
%% smoothing smoothing mask.
%% Filename: Program_4_gr.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Program_4_gr_nbegetis: Read image and process with convolution, median 
% filter or sharp filter (Graphics version)
function [] = Program_4_gr_nbegetis()
    clc; echo off; close all;
    %Put your images folder into the same folder as your .m program
    A=imread('./images/Pelvis.bmp');    % Pelvis.bmp HEAD6.BMP

    A = double(A);
    x = size(A, 1);
    y = size(A, 2);
    sprintf('x= %f  y= %f',x,y);

    Normalize_Matrix(A, 255);
    
    % Form of the low pass or smoothing mask
    sm1 = [ 1, 1, 1; 
            1, 1, 1; 
            1, 1, 1];      % Low pass or smoothing

    tic
    B=A;
    C=A;
    D=A;

    value=0;
    while value < 1 || value > 3 
        value = input('Select the method to use for the image processing\n1. Convolution\n2. Median Filter\n3. Sharp Filter\nType selection (1-3):  ');
    end; 
    switch value
        case 1
            B=convolve (A,sm1);
        case 2
            B=median_filter(A);
        case 3
            threshold = input('Select the threshold you want to use: \nType threshold (e.g. 0.1 - 50):  ');
            B=sharp(A,sm1,threshold);
    end

    C=ampl_fft2(A);
    D=ampl_fft2(B);
    image_depth=255;
    B=Normalize_Matrix(B, image_depth);
    C=Normalize_Matrix(C, image_depth);
    D=Normalize_Matrix(D, image_depth);
    
    %==============PLOT IMAGES======================
    colormap('gray');
    subplot(2,2,1); imagesc(A); xlabel('Original Image');
    axis equal; axis([1 size(A,2) 1 size(A,1)]);
    subplot(2,2,2); imagesc(B); xlabel('Processed Image');
    axis equal; axis([1 size(B,2) 1 size(B,1)]);

    subplot(2,2,3); imagesc(C); xlabel('Original Image Spectrum');
    axis equal; axis([1 size(C,2) 1 size(C,1)]);

    subplot(2, 2, 4); imagesc(D); xlabel('Processed Image Spectrum');
    axis equal; axis([1 size(D,2) 1 size(D,1)]);
    toc
end


function [B]=convolve (A, sm)
% ---------------------------------------------
% convolution

    x = size(A,1);
    y = size(A,2);
    B = A;  % important for frame
    
    % Initialize
    mask=sm;
    mask=double(mask);
    sum_mask=sum(sum(mask));
    if sum_mask <=0 
        sum_mask=1; 
    end;
    
    %filter image
    for i=2:x-1
        for j=2:y-1
            value=0;
            icount=0;
            for ii=i-1:i+1
                icount=icount+1;
                jcount=0;
                for jj=j-1:j+1
                    jcount=jcount+1;
                    value=value+A(ii,jj)*mask(icount,jcount);	
                end;
            end;
            if (value < 0)
                value=0; 
            end;
            B(i,j)=value/sum_mask;
        end;
    end;
end


function [B]=median_filter(A)
% ---------------------------------------------
% median filter

    x=size(A,1);
    y=size(A,2);
    B=A;
    
    for i=2:x-1
        for j=2:y-1
            count=1;
            for ii=i-1:i+1
                for jj=j-1:j+1
                    value(count)=A(ii, jj);
                    count=count+1;
                end
            end
            sm=sort(value);
            B(i,j)=sm(round(size(sm,2)/2));
        end
    end
end



function [B]=sharp(A,sm,threshold)
% ---------------------------------------------
% sharpening filter

    x=size(A,1);
    y=size(A,2);
    B=A;
    
    % Initialize
    C=sm;       % represents the mask of the filter
    C=double(C);
    sum_C=sum(sum(C));
    
    if sum_C <=0 
        sum_C = 1; 
    end;
    
    for i=2:x-1
        for j=2:y-1
            mi=0;           % local_mean as given for email
            for ii=i-1:i+1
                for jj=j-1:j+1
                    if (ii~=i || jj~=j)
                        mi=mi+A(ii,jj);
                    end
                end
            end
            mi=mi/8;

            if ( A(i,j)>mi && abs(A(i,j)-mi)>threshold )
                B(i,j)=A(i,j)+A(i,j)*threshold;
            elseif (abs(A(i,j) - mi) < threshold)
                value=0;
                icount=0;
                for ii=i-1:i+1
                    icount=icount+1;
                    jcount=0;
                    for jj=j-1:j+1
                        jcount=jcount+1;
                        value=value+A(ii,jj)*C(icount,jcount);	
                    end
                end
                if value<0 
                    value=0; 
                end;
                B(i,j)=round(value/sum_C);
            end  
        end
    end
end


function [C]=ampl_fft2(A)
    x=size(A,1);
    y=size(A,2);

    %/*--------   2D - FFT  ---------*/
    for i=1:x
        for j=1:y
            if (rem((i+j),2) == 1) 
                A(i,j)=-A(i,j);
            else
                A(i,j)= A(i,j);
            end;
        end;
    end;
    C=fft2(A);
    C=round(10.0 * log(abs(C)+1));
end


function [C]=Normalize_Matrix(A,tones)
    max_A=max(max(A));
    min_A=min(min(A));
    min_A=0;
    C=(A-min_A)*(tones)/(max_A-min_A); %back to 0-(tones)
end
