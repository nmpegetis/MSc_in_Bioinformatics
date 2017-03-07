%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function uses a main program which calls all the
%% functions implementing the filters of low-pass, high pass, high emphasis
%% median and sharp. Then it adds signal dependent noise according to the 
%% given (e.g. for 10 level (B(i,j)=A(i,j)+0.1*A(i,j)*randn;). Finally, 
%% we plot the variation of image noise. 
%% Filename: Program_5a_nbegetis.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lab work 5a:

% 1. Process image A by use of mask filters  {choose (switch-case)between
% Low Pass - High Pass - High Emphasis-median-sharp} and plot spectra below 
% the original and processed images.

% 2. Add different levels of signal dependent Noise to image A , e.g. for
% 10 level (i.e. 10%) (B(i,j)=A(i,j)+0.1*A(i,j)*randn;)
% (make sure that the values of noisy image B vary between 0-255).
% Plot the variation of image noise (i.e. the Standard Deviation within a
% 20x20 pixels ROI at the center of B) against the noise level (0% - 50%). 
% The plot should be created automatically by the program.


function [] = Program_5a_nbegetis()

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
    
    filter=0;
    while filter < 1 || filter > 5 
        filter = input('Select the method to use for the image processing\n1. Low Pass\n2. High Pass\n3. High Emphasis\n4. Median Filter\n5. Sharp Filter\nType selection (1-5):  ');
    end; 
    
    sm=0;lm=0;hem=0;
    
    % N is the dimension of the square image matrix
    N = x;

    % fco is the cut-off frequency.
    fco=round(N*0.3);
    
    % needed for the band-reject ideal filter and the band-pass ideal
    % filter
    W=N/4;L=N/4;

    % type=4;%1:LP,2:HP,3:BR, 4:BP
    fh=0;
    
    switch filter
        case 1      % Low Pass filter
            tic
            fh=idealFilters(1,N,fco,L,W); 
            B=filt_in_freq2(A,fh);
        case 2      % High Pass filter
            tic
            fh=idealFilters(2,N,fco,L,W); 
            B=filt_in_freq2(A,fh);
        case 3
            tic
            mask = mask_selection(hem1,hem2,hem3,hem4);
            B=convolve (A,mask);
        case 4
            tic
            B=median_filter(A);
        case 5
            tic               
            selection=0;
            while selection < 1 || selection > 3 
                selection = input('Select the what mask do you want to use for sharp filtering: \n1. Smoothing Mask\n1. Laplacian Mask\n1. High Emphasis Mask\nType selection (e.g. 1 - 3):  ');
            end
            if selection == 1 
                mask = mask_selection(sm1,sm2,sm3,sm4);
            elseif selection == 2 
                mask = mask_selection(lm1,lm2,lm3,lm4);
            else
                mask = mask_selection(hem1,hem2,hem3,hem4);
            end
            threshold = input('Select the threshold you want to use: \nType threshold (e.g. 0.1 - 50):  ');
            B=sharp(A,mask,threshold);
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

    subplot(2,2,4); imagesc(D); xlabel('Processed Image Spectrum');
    axis equal; axis([1 size(D,2) 1 size(D,1)]);

    toc

    % Task 5a_2
    Program_5a_put_noise(A)
end



function [] = Program_5a_put_noise(A)

    A = double(A);
    x = size(A, 1);
    y = size(A, 2);
    sprintf('x= %f  y= %f',x,y);

    Normalize_Matrix(A, 255);
    B=A;
    C=A;
    D=A;
        
%    percentage=-1;
%    while percentage < 0 || percentage > 0.5 
%        percentage = input('Select the noise level you want to apply in the original image\nType selection (0 - 0.5):  ');
%    end; 
    
    itr=1;

    [img_width img_height]=size(A);   % get dimensions of new_img
    width=img_width/2;      % get the width where center is found
    height=img_height/2;    % get the height where center is found

    for percentage=0.0:0.01:0.5
        for i=1:x
            for j=1:y
                B(i,j)=A(i,j)+percentage*A(i,j)*randn;
            end;
        end;

        for i=1:20
            for j=1:20
                roi(i,j) = B(width-10+i, height-10+j);
            end;
        end;
        
        % MatLab Standard Deviation for each percentage 0-0.5
        E(itr)=std(roi(:)); 

        itr=itr+1;
    end;

    C=ampl_fft2(A);
    D=ampl_fft2(B);

    image_depth=255;
    B=Normalize_Matrix(B, image_depth);
    C=Normalize_Matrix(C, image_depth);
    D=Normalize_Matrix(D, image_depth);
    
    %==============PLOT IMAGES======================
    figure;
    colormap('gray');
    subplot(2,3,1); imagesc(A); xlabel('Original Image');
    axis equal; axis([1 size(A,2) 1 size(A,1)]);

    subplot(2,3,2); imagesc(roi); xlabel('Processed ROI Image with noise');
    axis equal; axis([1 size(roi,2) 1 size(roi,1)]);

    subplot(2,3,3); imagesc(B); xlabel('Processed Image with noise');
    axis equal; axis([1 size(B,2) 1 size(B,1)]);

    subplot(2,3,4); imagesc(C); xlabel('Original Image Spectrum');
    axis equal; axis([1 size(C,2) 1 size(C,1)]);

    % plots the variation of ROI 20x20 of noisy image B against the noise
    % level
    subplot(2,3,5); plot(E, 'red'); xlabel('Variation in ROI 20x20 std/noise level');
    axis equal; %axis([0 100 0 size(E)]);

    subplot(2,3,6); imagesc(D); xlabel('Processed Image with noise Spectrum');
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
            filter=0;
            icount=0;
            for ii=i-1:i+1
                icount=icount+1;
                jcount=0;
                for jj=j-1:j+1
                    jcount=jcount+1;
                    filter=filter+A(ii,jj)*mask(icount,jcount);	
                end;
            end;
            if (filter < 0)
                filter=0; 
            end;
            B(i,j)=filter/sum_mask;
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
                    filter(count)=A(ii, jj);
                    count=count+1;
                end
            end
            sm=sort(filter);
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
                filter=0;
                icount=0;
                for ii=i-1:i+1
                    icount=icount+1;
                    jcount=0;
                    for jj=j-1:j+1
                        jcount=jcount+1;
                        filter=filter+A(ii,jj)*C(icount,jcount);	
                    end
                end
                if filter<0 
                    filter=0; 
                end;
                B(i,j)=round(filter/sum_C);
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



function [fh] = idealFilters(type,N,fco,L,W); 

    for k=1:N/2
        if type==1      % Low Pass
            if k<=fco
                fh(k)=1;
            else
                fh(k)=0; 
            end;
        elseif type==2  % High Pass
            if k<=fco 
                fh(k)=0;
            else
                fh(k)=1; 
            end;
        elseif type==3  % Band Pass
            d=0;
            d = input('Select the d distance for the ideal band-reject filter\nType d selection :  ');
            if k<=(d-W/2) || k>=(d-W/2)
                fh(k) = 1;
            else        % Band Reject
                fh(k) = 0; 
            end;
        else
            d=0;
            d = input('Select the d distance for the ideal band-pass filter\nType d selection :  ');
            if k<=(d-W/2) || k>=(d-W/2)
                fh(k) = 0;
            else
                fh(k) = 1; 
            end;
        end
    end
    
    for k=N/2+1:N
        fh(k) = fh(N+1-k);
    end %//i.e. mirror N/2..N-1
end


function [C] = filt_in_freq2(A,fh)
    x=size(A,1);y=size(A,2);
    C=fft2(A);

    for i=1:x
        for j=1:y
            ir = sqrt(j*j + i*i);
            if (ir > x ) ir = x;end;%if
            C(i,j)=C(i,j)*fh(round(ir)); 
        end;
    end;

    C=ifft2(C);

    C=real(C);C=abs(C);
    for i=1:x;
        for j=1:y;
            if(C(i,j)<0) C(i,j)=0;end;
        end;
    end;
end


function [mask] = mask_selection(mask1,mask2,mask3,mask4)
    m_choice=0
    while (m_choice < 1 || m_choice > 4)
    % Selection of the exact mask to be used with the filter
        disp('Select which mask of the four you want to use');
        disp('1. ');disp(mask1);disp('2. ');disp(mask2);disp('3. ');disp(mask3);disp('4. ');disp(mask4);
        m_choice = input('Type selection (1-4):  ');
        if (m_choice == 1) mask=mask1; elseif (m_choice == 2) mask=mask2; elseif (m_choice == 3) mask=mask3; else mask=mask4; end;
    end;
end