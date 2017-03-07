%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function uses a main program which calls all the
%% functions implementing the CDF method and the histogram equalization 
%% algorithm. For the CDF we have implemented the algorithm shown in page
%% 21 of the class notes, which computes the Cumulative Distribution
%% Function and generates fast and effective results (we have also set a 
%% tic-tac to show the low time complexity of the function). For the
%% histogram equalization, we used what we said in class and the algorithm 
%% analysed in page 19 of the class notes
%% Filename: Program_2_gr.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Program_2_gr_nbegetis: Read image and process by CDF (Graphics version)
function [] = Program_2_gr_nbegetis()
    clc;echo off;close all;
    %Put your images folder into the same folder as your .m program
    A=imread('./images/Pelvis.bmp');    % Pelvis.bmp HEAD6.BMP

    A = double(A);
    x = size(A, 1);
    y = size(A, 2);
    sprintf('x= %f  y= %f',x,y);
    max_A = max(max(A));
    min_A = min(min(A));
    A = (A - min_A) * (255 / (max_A - min_A));  % back to 0-255
    B = A;
    image_depth = 255; tones = 256;
    
    %==========CALL FUNCTIONS=================
    value=0;
    while value < 1 || value > 2 
        value = input('Select the method to use for the image processing\n1. CDF \n2. Histogram Equalization\nType selection (1 or 2):  ');
    end; 
    switch value
        case 1
            B = My_CDF(A, tones);
        case 2
            B = My_histogram_equalization(A, tones);
    end

    max_B = max(max(B));
    min_B = min(min(B));
    B = (B - min_B) * (255 / (max_B - min_B));%back to 0-255
    
    %========= PLOT IMAGES =====================
    colormap('gray');
    subplot(2, 2, 1); imagesc(A); xlabel('Original Image');
    axis equal; axis([1 size(A, 2) 1 size(A, 1)]);

    subplot(2, 2, 2); imagesc(B);
    if (value == 1) 
        xlabel('CDF Processed Image'); 
    elseif (value == 2) 
        xlabel('Equalized Image'); 
    end;
    axis equal; axis([1 size(B, 2) 1 size(B, 1)]);
    
    h = My_hist_A(A, tones);
    maxh = max(h);
    minh = min(h);
    h = (h - minh) * (tones / (maxh - minh));%normalize for plotting;
    subplot(2, 2, 3); plot(h, 'red'); xlabel('Original Image histogram');
    axis equal; axis([1 255 1 max(h)]);

    switch value
        case 1
            eq = My_hist_A(B,tones);		
            maxeq = max(eq);
            mineq = min(eq);
            eq = (eq - mineq) * (tones / (maxeq - mineq));  % normalize for
                                                            % plotting;
            subplot(2, 2, 4); plot(eq, 'blue'); xlabel('CDF histogram');
            axis equal; axis([1 255 1 max(eq)]);
        case 2
            eq = My_hist_A(B, tones);		
            subplot(2, 2, 4); plot(eq, 'blue --'); xlabel('Equalized histogram');
            axis equal; axis([1 512 1 512]);
    end
end


function [h] = My_hist_A(A, tones)
    x=size(A,1);
    y=size(A,2);
    h=zeros(tones, 1);

    maxi=max(max(A));
    if (maxi <= 0) 
        maxi=1; 
    end;
    for i=1:x
      for j=1:y
        p = (tones-1)*A(i,j)/maxi;
        h(round(p+1)) = h(round(p+1))+1;
      end
    end
end



function [cdf] = My_CDF(A, tones)

    tic         % start clock
    x=size(A,1);
    y=size(A,2);
    q=x*y/tones;
    h=zeros(tones,1);
    
    max_A = max(max(A));
    for i=1:x
        for j=1:y
            p(i,j) = (tones-1)*A(i,j)/max_A;
            h(round(p(i,j)+1)) = h(round(p(i,j)+1))+1;
        end
    end
    
    CDFh(1)=h(1);
    for i = 2 : size(h, 1)
        CDFh(i) = CDFh(i - 1) + h(i);
    end
    
    for i=1:x
        for j=1:y
            cdf(i,j) = floor(CDFh(round(p(i,j)+1))/q-1);
            if (cdf(i,j) < 0)
                cdf(i,j)=0;
            end
        end
    end
    toc     % stop clock
end


function [m] = My_histogram_equalization(A,tones)
    tic 
    m=A;
    x=size(A, 1);
    y=size(A, 2);
    max_A=max(max(A));
    hist_eq_h=zeros(tones, 1);
    hist_eq_q=zeros(tones, 1);

    for i=1:x
        for j=1:y
            m(i,j)=-1;
        end
    end
    
    for i=1:x
        for j=1:y
            p = (tones-1)*A(i,j)/max_A;
            A(i,j) = round(p);
            hist_eq_h(round(p+1)) = hist_eq_h(round(p+1))+1;
        end
    end     % get the histogram

    k=0;
    
    he_q = x*y/tones;
    for itr=1:tones     % apply algorithm of page 19 on the histogram
        i=0;
        he_sum=0;
        itone=itr;
        while (i<=tones-1 && he_sum<he_q) 
            i = i + 1;
            he_sum=he_sum+hist_eq_h(i);
            k=i;
            hist_eq_h(i)=0;
        end
        hist_eq_h(k)=he_sum-he_q;
        
        for itr2=1:x
            for itr3=1:y
                p = A(itr2, itr3);
                if (hist_eq_q(itr) < he_q) 
                    if (m(itr2, itr3) == -1 && p <= k)
                        m(itr2, itr3) = itone-1;
                        hist_eq_q(itr) = hist_eq_q(itr)+1;
                    end
                end
            end
        end
        if (hist_eq_q(itr) ~= he_q)
            if (hist_eq_q(itr) < he_q) 
                for itr2=1:x
                    for itr3=1:y
                        p=A(itr2, itr3);
                        if ( m(itr2,itr3)==-1 && p==k) 
                            m(itr2,itr3) = itone-1;
                            hist_eq_q(itr) = hist_eq_q(itr)+1;
                        end
                    end
                end 
            end 
        end 
    end; 
    toc
end
