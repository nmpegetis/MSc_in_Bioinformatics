%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function uses a main program which calls all the
%% functions implementing the filters of Generalized Wiener. Then, it calls
%% function to calculate Minimum Square Error (MSE). Finally, 
%% plots are provided of the 1-d and 2-d filters and of the spectra of the
%% original and processed images. Finally, image A is degraded by a 
%% Butterworth low-pass filter and various levels of noise are added 
%% (0.1:0.1:0.5). At each noise level, the Generalized Wiener Filter 
%% Function to apply the Inverse-Wiener-Power restoration filters to filter 
%% the degraded image and by using the MSE across image diagonals plot 
%% the variation of MSE with noise for each one of the filters. 
%% Filename: Program_5c_nbegetis.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lab work 5c:

% 1.Form the Generalized Wiener Filter Function (see relation page 38  of 
% ImProc_Lecture_4)

% 2.Form a function to calculate Minimum Square Error (MSE) (for MSE
% relation go to page 41 of ImProc_Lecture_4)

% 3. Degrade image A by a Butterworth low-pass filter and add various 
% levels of noise (0.1:0.1:0.5).  At each noise level, use the Generalized
% Wiener Filter Function to apply the Inverse-Wiener-Power restoration 
% filters to filter the degraded image and by using the MSE across image 
% diagonals (between the original and filtered images) plot (in one graph) 
% the variation of MSE with noise for each one of the filters.  The plot
% should be created automatically by the program.

function [] = Program_5c_nbegetis()

    clc; echo off; close all;
    %Put your images folder into the same folder as your .m program
    A=imread('./images/Pelvis.bmp');    % Pelvis.bmp HEAD6.BMP

    A = double(A);
    x = size(A, 1);
    y = size(A, 2);
    sprintf('x= %f  y= %f',x,y);

    Normalize_Matrix(A, 255);
            
    filter=0;
    while filter < 1 || filter > 3 
        filter = input('Select the Generalized Wiener filter you want to use\n1. Inverse\n2. Wiener\n3. Power Spectrum\nType selection (1-3):  ');
    end; 


    N=x; %consider square images!!!

    tic
    
    [B, fh] = degradeimage(A, 255);
    switch filter
        case 1         % inverse filter
            a=1; b=0; c=0;
        case 2         % wiener filter         
            a=0; b=1; c=0.22;
        case 3         % power spectrum filter        
            a=0.5; b=1; c=0.172;
    end
    
    fx=GeneralizedWiener(fh,N,a,b,c);
    C=filt_in_freq2(B, fx);

    error=0;
    tempA=diag(A);
    for a=0:0.1:1
        for b=0:0.1:1
            fx = GeneralizedWiener(fh,N,a,b,0.2);
            % D = filt_in_freq2(B,fx);
            tempB = diag(B);
            for i=1:length(tempA)
                error=error+(tempB(i)-tempA(i))^2;
            end
            
            if (a == 0 && b == 0)
                minerror=error;
                optA=0;
                optB=0;
            end
            
            if (error < minerror)
                minerror=error;
                optA=a;
                optB=b;
            end
        end
    end
    
    fprintf('Optimal a = %1.2f\noptimal b = %1.2f\nminerror = %1.2f\n', optA, optB, minerror);
    plotter(A, B, C, fh, fx)
  
    toc

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



function [C,S] = filt_in_freq2(A,fh)
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
            ir = sqrt((x/2-j)^2 + (y/2-i)^2);
            if (ir > x ) ir = x;end;
            if (ir == 0 ) ir = 1;end;
            S(i,j)=fh(round(ir));
        end;
    end;
end


function [fh] = Butterworth(N,type,y) 
    for i=1:N; 
        fh(i)=0; 
    end;
    %//---------Read in filter parameters--------
    
    for k=1:N/2
        if (type == 1) 
            ndegree=2;
            fco=round(y*0.1);
            fh(k)=1.0/(1.0+0.414*(k/fco)^(2*ndegree) );
        end;
        if (type == 2)
            ndegree=2;
            fco=round(y*0.2);
            trans=round(y*0.05);
            fh(k)=1.0/(1.0+0.414*(fco/k)^(2*ndegree) );
        end;
        if (type == 3 || type == 4) 
            ndegree=2;
            fco=round(y*0.3);
            trans=round(y*0.3);
            fh(k)=1.0/(1.0+0.414*(fco/k)^(2*ndegree) );
            FH=[fh fh];
            L=length(FH);
            fh=FH(L/2+trans:(L/2+N/2+trans-1));
            fh=[fh fliplr(fh)];
            fh=fh/max(fh);
        end;
    end

    for k = N/2+1:N
        fh(k)=fh(N+1-k);
    end %//i.e. mirror N/2..N-1
end



function [fh] = GeneralizedWiener(degradefilt,N,a,b,A)
    for i=1:N
		fh(i)=(((degradefilt(i)^2)/(degradefilt(i)^2+b*A))^(1-a))/degradefilt(i);
    end
end



function [B,fh]=degradeimage(A,image_depth)
    x=size(A,1);y=size(A,2);
    %//---------- degrade image --
    B=A;

    type=0;
    while type < 1 || type > 4 
        type = input('Select the type of the Butterworth filter\n1. Low Pass\n2. High Pass\n3. Band Reject\n4. Band Pass\nType selection (1-4):  ');
    end; 

    fh=Butterworth(x,type,y);  % form degradation function
    B=filt_in_freq2(A,fh);
    
    noise=30;    % additive Noise
    R=randint(x,y,[0,noise])-noise/2;

    B=B+(B.*R/100);
    Normalize_Matrix(B,image_depth);
end


function [] = plotter(A, B, C, fh, fx)
    x=size(A,1); y=size(A,2);
    %==============PLOT IMAGES===================================
    colormap('gray');
    subplot(2,3,1); imagesc(A); xlabel('Original Image');
    axis equal; axis([1 size(A,2) 1 size(A,1)]);colorbar

    subplot(2,3,2); plot(y * fh, 'red'); xlabel('degradation filter');
    axis equal; axis([1 x 1 y]);

    subplot(2,3,3); imagesc(B); xlabel('Degraded Image');
    axis equal; axis([1 size(B, 2) 1 size(B, 1)]);

    subplot(2,3,4); imagesc(C); xlabel('Applied Filter');
    axis equal; axis([1 size(C, 2) 1 size(C, 1)]);
    maxh=max(fx); minh=min(fx); fx=(fx-minh)*(1.0/(maxh-minh));
    
    subplot(2,3,5); plot(y * fx, 'red'); xlabel('Applied filter plot');
    axis equal; axis([1 x 1 y]);

end