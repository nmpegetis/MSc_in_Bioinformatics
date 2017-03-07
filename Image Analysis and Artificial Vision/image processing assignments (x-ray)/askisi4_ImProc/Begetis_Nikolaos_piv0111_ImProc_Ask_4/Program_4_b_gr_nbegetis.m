%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function uses a main program which calls all the
%% functions implementing the convolve, the median filter (p.11, class 
%% notes) and the sharp filter (p.15, class notes) functions. More 
%% specifically, we included these functions in the same program with the 
%% low pass of smoothing smoothing mask, and what is more, in this version 
%% of the program we involved also three more smoothing masks, four 
%% laplacian masks and four high emphasis masks. When running the program
%% user is asked to select a filter and one of each kind of masks to apply
%% for the image processing.
%% Filename: Program_4_b_gr.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Program_4_gr_nbegetis: Read image and process with convolution, median 
% filter or sharp filter (Graphics version). In this version of program we
% use all the masks we were taught in class.
function [] = Program_4_b_gr_nbegetis()
    clc; echo off; close all;
    %Put your images folder into the same folder as your .m program
    A=imread('./images/Pelvis.bmp');    % Pelvis.bmp HEAD6.BMP

    A = double(A);
    x = size(A, 1);
    y = size(A, 2);
    sprintf('x= %f  y= %f',x,y);

    Normalize_Matrix(A, 255);
    
%% Definitions of all the masks applied

% Low pass or smoothing masks in a 2D case, counted in the same order as in 
% class notes (pp. 06-07).
    sm1 = [ 1, 1, 1; 
            1, 1, 1; 
            1, 1, 1];       % Low pass or smoothing Mask 1
    sm2 = [ 1, 1, 1; 
            1, 2, 1; 
            1, 1, 1];       % Low pass or smoothing Mask 2
    sm3 = [ 1, 2, 1; 
            2, 4, 2;   
            1, 2, 1];       % Low pass or smoothing Mask 3
    sm4 = [ 0, 1, 0; 
            1, 1, 1; 
            0, 1, 0];       % Low pass or smoothing Mask 4

        
% Laplacian filter masks in a 2D case, counted in the same order as in 
% class notes (pp. 17-18).
    lm1 = [ 0, 1, 0; 
            1,-4, 1; 
            0, 1, 0];       % Laplacian Mask 1
    lm2 = [ 1, 1, 1; 
            1, -8, 1; 
            1, 1, 1];       % Laplacian Mask 2
    lm3 = [ 1, 2, 1; 
            2,-12, 2; 
            1, 2, 1];       % Laplacian Mask 3
    lm4 = [ -1, 2, -1; 
            2, -4, 2; 
            -1, 2, -1];     % Laplacian Mask 4
    
        
% High Emphasis filter masks in a 2D case, counted in the same order as in 
% class notes (pp. 20-21).
    hem1 = [0, -1, 0; 
            -1, 5, -1; 
            0, -1, 0];      % HEM1 (High Emphasis Mask 1)
    hem2 = [-1, -1, -1; 
            -1, 9, -1; 
            -1, -1, -1];    % HEM1 (High Emphasis Mask 2)
    hem3 = [-1, -2, -1; 
            -2, 13, -2; 
            -1, -2, -1];    % HEM1 (High Emphasis Mask 3)
    hem4 = [1, -2, 1; 
            -2, 5, -2; 
            1, -2, 1];      % HEM1 (High Emphasis Mask 4)

    B=A;
    C=A;
    D=A;
    
    E=A;
    F=A;
    G=A;
    H=A;
    
    value=0;
    while value < 1 || value > 3 
        value = input('Select the method to use for the image processing\n1. Convolution\n2. Median Filter\n3. Sharp Filter\nType selection (1-3):  ');
    end; 
    
    sm=0;lm=0;hem=0;
    switch value
        case 1
            [sm,lm,hem] = mask_selection(sm1,sm2,sm3,sm4,lm1,lm2,lm3,lm4,hem1,hem2,hem3,hem4);
            tic
            B=convolve (A,sm);
            C=convolve (A,lm);
            D=convolve (A,hem);
        case 2
            tic
            B=median_filter(A);
        case 3
            [sm,lm,hem] = mask_selection(sm1,sm2,sm3,sm4,lm1,lm2,lm3,lm4,hem1,hem2,hem3,hem4);
            tic
            threshold = input('Select the threshold you want to use: \nType threshold (e.g. 0.1 - 50):  ');
            B=sharp(A,sm,threshold);
            C=sharp(A,lm,threshold);
            D=sharp(A,hem,threshold);
    end

    E=ampl_fft2(A);
    F=ampl_fft2(B);
    G=ampl_fft2(C);
    H=ampl_fft2(D);

    image_depth=255;
    B=Normalize_Matrix(B, image_depth);
    C=Normalize_Matrix(C, image_depth);
    D=Normalize_Matrix(D, image_depth);
    E=Normalize_Matrix(E, image_depth);
    F=Normalize_Matrix(F, image_depth);
    G=Normalize_Matrix(G, image_depth);
    H=Normalize_Matrix(H, image_depth);
    
    %==============PLOT IMAGES======================
    colormap('gray');
    subplot(2,2,1); imagesc(A); xlabel('Original Image');
    axis equal; axis([1 size(A,2) 1 size(A,1)]);

    subplot(2,2,2); imagesc(B); xlabel('Processed Image - Smoothing Mask');
    axis equal; axis([1 size(B,2) 1 size(B,1)]);

    subplot(2,2,3); imagesc(C); xlabel('Processed Image - Laplacian Mask');
    axis equal; axis([1 size(C,2) 1 size(C,1)]);

    subplot(2,2,4); imagesc(D); xlabel('Processed Image - High Emphasis Mask');
    axis equal; axis([1 size(D,2) 1 size(D,1)]);

    
    figure;
    
    colormap('gray');
    subplot(2,2,1); imagesc(E); xlabel('Original Image Spectrum');
    axis equal; axis([1 size(E,2) 1 size(E,1)]);

    subplot(2,2,2); imagesc(F); xlabel('Processed Image Spectrum - Smoothing Mask');
    axis equal; axis([1 size(F,2) 1 size(F,1)]);

    subplot(2,2,3); imagesc(G); xlabel('Original Image Spectrum - Laplacian Mask');
    axis equal; axis([1 size(G,2) 1 size(G,1)]);

    subplot(2,2,4); imagesc(H); xlabel('Processed Image Spectrum - High Emphasis Mask');
    axis equal; axis([1 size(H,2) 1 size(H,1)]);

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


function [sm,lm,hem] = mask_selection(sm1,sm2,sm3,sm4,lm1,lm2,lm3,lm4,hem1,hem2,hem3,hem4)
    sm=0;lm=0;hem=0;sm_choice=0;lm_choice=0;hem_choice=0;
    while (sm_choice < 1 || sm_choice > 4)
    % Selection of the exact smoothing mask to be used with the filter
        disp('Select the Low Pass or SMOOTHING MASK you want to use with the above method');
        disp('1. ');disp(sm1);disp('2. ');disp(sm2);disp('3. ');disp(sm3);disp('4. ');disp(sm4);
        sm_choice = input('Type selection (1-4):  ');
        if (sm_choice == 1) sm=sm1; elseif (sm_choice == 2) sm=sm2; elseif (sm_choice == 3) sm=sm3; else sm=sm4; end;
    end;
    while (lm_choice < 1 || lm_choice > 4)
    % Selection of the exact laplacian mask to be used with the filter
        disp('Select the LAPLACIAN MASK you want to use with the above method');
        disp('1. ');disp(lm1);disp('2. ');disp(lm2);disp('3. ');disp(lm3);disp('4. ');disp(lm4);
        lm_choice = input('Type selection (1-4):  ');
        if (lm_choice == 1) lm=lm1; elseif (lm_choice == 2) lm=lm2; elseif (lm_choice == 3) lm=lm3; else lm=lm4; end;
    end;
    while (hem_choice < 1 || hem_choice > 4)
    % Selection of the exact high emphasis mask to be used with the filter
        disp('Select the HIGH EMPHASIS MASK you want to use with the above method');
        disp('1. ');disp(hem1);disp('2. ');disp(hem2);disp('3. ');disp(hem3);disp('4. ');disp(hem4);
        hem_choice = input('Type selection (1-4):  ');
        if (hem_choice == 1) hem=hem1; elseif (hem_choice == 2) hem=hem2; elseif (hem_choice == 3) hem=hem3; else hem=hem4; end;
    end; 
end