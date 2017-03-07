%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Sangriotis Manolis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Filename: nbegetis_6B.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[] = nbegetis_6B()
    clear *;,clc;,close all;
    I  =double( imread('E2.bmp')); % Input Image from image file

    %computation of the mean value
    pmeso=[mean2(I(:,:,1));mean2(I(:,:,2));mean2(I(:,:,3))];

    % # of x rows and y columns
    x=size(I,1);
    y=size(I,2);
    N=x*y	% image pixels

    Cp=0;
    for i=1:x
        for j=1:y
            p_i=[I(i,j,1);I(i,j,2);I(i,j,3)];
            Cp=Cp+(p_i-pmeso)*(p_i-pmeso)';
        end
    end
    Cov=Cp*(1/N);   % covarience computation

    % eigenvalues and eigenvectors
    [V,D]=eig(Cov);

    maxeig=max(D(:))    %   max eigenvalue

     for i=1:x
       for j=1:y
           p_i=[I(i,j,1);I(i,j,2);I(i,j,3)];
           p_v(i,j)=p_i'*V(:,3); %pixel multiplication with its relevant max eigenvector
       end
    end

    %Canny
    BW1 = edge(p_v,'canny',[0.1,0.2], 2.7); 

    imshow (BW1);
end