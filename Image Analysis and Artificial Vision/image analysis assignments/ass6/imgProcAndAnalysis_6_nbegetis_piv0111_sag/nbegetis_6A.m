%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Sangriotis Manolis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Filename: nbegetis_6A.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[] = nbegetis_6A()
    clear *;clc;close all;
    I  =double( imread('E1.jpg')); % Input Image from image file

    R=I(:,:,1);
    BW1 = edge(R,'canny',[0.1,0.2], 2.7); % Apply Canny for colour red
    G=I(:,:,2);
    BW2 = edge(G,'canny',[0.1,0.2], 2.7); %  Apply Canny for colour green

    B=I(:,:,3);
    BW3 = edge(B,'canny',[0.1,0.2], 2.7); %  Apply Canny for colour blue

    S=BW1+BW2+BW3; %sum the above computations
    imshow(S);
end
