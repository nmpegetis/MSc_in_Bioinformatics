%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function uses a main program which calls all the
%% functions implementing the filters of Butterworth, Gaussian, and 
%% Exponential (HP,LP,BR,BP) to process the provided images. Finally, 
%% plots are provided of the 1-d and 2-d filters and of the spectra of the
%% original and processed images.
%% Filename: Program_5b_nbegetis.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lab work 5b:

% Form the Ideal_filter for high-pass, low-pass, band-pass and band-reject
% versions as well as the Butterworth, Gaussian, and Exponential (HP, LP,
% BR, BP ) filtering functions to process the provided images. The program
% should work using “switch-case” for choosing the desired filtering 
% function, it should provide plots of the 1-d and 2-d filters and of the 
% spectra of the original and processed images.


function [] = Program_5b_nbegetis()

    clc; echo off; close all;
    %Put your images folder into the same folder as your .m program
    A=imread('./images/Pelvis.bmp');    % Pelvis.bmp HEAD6.BMP

    A = double(A);
    x = size(A, 1);
    y = size(A, 2);
    sprintf('x= %f  y= %f',x,y);

    Normalize_Matrix(A, 255);
    
    
    filter=0;
    while filter < 1 || filter > 4 
        filter = input('Select the method to use for the image processing\n1. Ideal\n2. Butterworth\n3. Gaussian\n4. Exponential\nType selection (1-4):  ');
    end; 
        
    type=0;
    while type < 1 || type > 4 
        type = input('Select the type of the above filter\n1. Low Pass\n2. High Pass\n3. Band Reject\n4. Band Pass\nType selection (1-4):  ');
    end; 

    N=x; %consider square images!!!

    tic
            
    switch filter
        case 1      % Ideal filter
            fco=round(N*0.3);   % fco is the cut-off frequency.
            % W and L are needed for the band-reject ideal filter and the 
            % band-pass ideal filter
            W=N/4;L=N/4;
            fh=idealFilters(type,N,fco,L,W); 
            [B,Spectrum]=filt_in_freq2(A,fh);
            plotter1(A, B, Spectrum, fh);
        case 2      % Butterworth filter
            fh = Butterworth(N,type,y);
            [B,Spectrum]=filt_in_freq2(A,fh);
            plotter1(A, B, Spectrum, fh);
        case 3      % Gaussian filter
            fco = round(y * 0.2);
            d = 20;
            fh = Gaussian(x, type, fco, d);
            [B,Spectrum]=filt_in_freq2(A,fh);
            plotter1(A, B, Spectrum, fh);
        case 4      % Exponential filter
            fco = round(y*0.2);
            ndegree = 1;
            d = 30;
            fh = Exponential(x, type, ndegree, fco, d);
            [B,Spectrum]=filt_in_freq2(A,fh);
            plotter1(A, B, Spectrum, fh);
    end

    C=ampl_fft2(A);
    D=ampl_fft2(B);

    image_depth=255;
    B=Normalize_Matrix(B, image_depth);
    C=Normalize_Matrix(C, image_depth);
    D=Normalize_Matrix(D, image_depth);
    
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



function [fh] = idealFilters(type,N,fco,L,W); 

    for k=1:N/2
        if type==1      % Low Pass
            if k<=fco
%                ifco1 = round(y * 0.3); %cut-off frequency
%                ifco2 = 0;
                fh(k)=1;
            else
                fh(k)=0; 
            end;
        elseif type==2  % High Pass
            if k<=fco 
%                ifco1 = round(y * 0.3); %cut-off frequency
%                ifco2 = 0;
                fh(k)=0;
            else
                fh(k)=1; 
            end;
        elseif type==3  % Band Pass
            d=0;
%            d = input('Select the d distance for the ideal band-reject filter\nType d selection :  ');
            if k<=(d-W/2) || k>=(d+W/2)
                fh(k) = 1;
            else        % Band Reject
                fh(k) = 0; 
            end;
        else
            d=0;
%            d = input('Select the d distance for the ideal band-pass filter\nType d selection :  ');
            if k<=(d-W/2) || k>=(d+W/2)
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


function [fh] = Gaussian(N,type,fco,d)
    for i=1:N; 
        fh(i)=0; 
    end;
    %//---------Read in filter parameters--------
    
    for k=1:N/2
        if (type == 1) 
            fh(k)=k/fco; 
        end;
        if (type == 2) 
            fh(k)=fco/k; 
        end;
        if (type == 3) 
            fh(k)=fco/(k-d); 
        end;
        if (type == 4) 
            fh(k)=(k-d)/fco; 
        end;
    end
    
    for k=N/2+1:N
        fh(k)=fh(N+1-k);
    end %//i.e. mirror N/2..N-1

    for k=1:N
        val=fh(k)*fh(k);
        fh(k) = exp(-1*fh(k)/2);
    end
end


function [fh] = Exponential(N,choice,ndegree,fco,d)
    for i=1:N 
        fh(i)=0; 
    end;
    %//---------Read in filter parameters--------
    for k=1:N/2
        if (choice == 1) 
            fh(k)=k/fco; 
        end;
        if (choice == 2) 
            fh(k)=fco/k; 
        end;
        if (choice == 3) 
            fh(k)=fco/(k-d); 
        end;
        if (choice == 4) 
            fh(k)=(k-d)/fco; 
        end;
    end
    for k = N/2+1:N, 
        fh(k) = fh(N+1-k);
    end %//i.e. mirror N/2..N-1
    for k=1:N
        fh(k)=exp(-log10(2)*ndegree*fh(k));
    end
end


function [] = plotter1(A, B, Spectrum, fh)
    x = size(A, 1); y = size(A, 2);
    %==============PLOT IMAGES===================================
    colormap('gray');
    subplot(2,3,1); imagesc(A); xlabel('Original Image');
    axis equal; axis([1 size(A,2) 1 size(A,1)]);

    subplot(2,3,2); plot(y*fh, 'red'); xlabel('Filter Function');
    axis equal; axis([1 x 1 y]);grid on;

    subplot(2,3,3); imagesc(B); xlabel('Processed Image');
    axis equal; axis([1 size(B,2) 1 size(B,1)]);

    A = ampl_fft2(A);
    subplot(2,3,4); imagesc(A); xlabel('Or. Im. Spectrum');
    axis equal; axis([1 size(A,2) 1 size(A,1)]);

    subplot(2,3,5);imagesc(Spectrum);xlabel('2-D Filter');
    axis equal;axis([1 size(Spectrum,2) 1 size(Spectrum,1)]);

    B = ampl_fft2(B);
    subplot(2,3,6); imagesc(B); xlabel('Processed Im. Spectrum');
    axis equal; axis([1 size(B,2) 1 size(B,1)]);
end