%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Cavouras Dionisis - Professor - ITMB
%% Course: Image Processing and Analysis
%% Function: This function uses a main program which calls all the
%% functions implementing windows for image processing such as simple
%% window, broken window, double window and non-linear window. For the
%% non-linear window we used the functions of cosine, sine, exponential,
%% quadratic and cubic. For these functions we normalized their values in a
%% range of (0,1) by finding the min-max values of each one and thus we
%% also normalized the resulted values of the above functions in the same
%% range of (0,1). Then we multiplied each function by (tones-1) so that
%% grey tones range in the integral (0,tones-1). This function is applied
%% on image data
%% Filename: Program_1_gr.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function []=Program_1_gr()
clc;echo off;close all;
%Put your images folder into the same folder as your .m program
A=imread('./images/HEAD6.BMP');%Pelvis.bmp HEAD6.BMP

figure
imagesc(A);         % Display the image selected
colormap('gray');

A=double(A);
x=size(A,1);y=size(A,2);
sprintf('x= %f y=%f',x,y);
max_C=max(max(A));min_C=min(min(A));A=(A-min_C)*(255/(max_C-min_C));%back to 0-255
B=A;
image_depth=255;tones=256;
% tic
value=0;
while value < 1 || value > 4 
    value = input('Select the window for the image processing\n1. Simple Window\n2. Broken Window\n3. Double Window\n4. Non-linear Window\nType selection (1-4):  ');
end; 

switch value
    case 1
        disp('simple window');
        WW=100;WL=80;
        tic
        B=My_simple_window(A,image_depth,tones,WW,WL);
        %End of code for simple window here
    case 2
        disp('broken window');
        gray_val=150;im_val=60;
        tic
        B=My_broken_window(A,image_depth,tones,gray_val,im_val);%Have to construct it
        %End of code for simple window here
    case 3
        disp('double window');
        ww1=50;ww2=50;wl1=50;wl2=220;
        tic
        B=My_double_window(A,image_depth,tones,ww1,ww2,wl1,wl2);%Have to construct it
    case 4
        disp('non-linear window');
        funct=0;
        while funct < 1 || funct > 5 
            funct = input('Select the function for the non-linear window\n1. Cosine\n2. Sine\n3. Exponential\n4. Quadratic\n5. Cubic\nType selection (1-5):  ');
        end; 
        tic
        B=My_non_linear_window(A,image_depth,tones,funct);%Have to construct it
end
%========= PLOT IMAGES =====================
figure
colormap('gray');
switch value
    case 1
        subplot(1,2,1);imagesc(A);xlabel('Original Image');%colorbar;
        axis equal;axis([1 size(A,2) 1 size(A,1)]);
        subplot(1,2,2);imagesc(B);xlabel('Single-Window Processed Image');
        axis equal;axis([1 size(B,2) 1 size(B,1)]);
    case 2
        subplot(1,2,1);imagesc(A);xlabel('Original Image');%colorbar;
        axis equal;axis([1 size(A,2) 1 size(A,1)]);
        subplot(1,2,2);imagesc(B);xlabel('Broken-Window Processed Image');
        axis equal;axis([1 size(B,2) 1 size(B,1)]);
    case 3
        subplot(1,2,1);imagesc(A);xlabel('Original Image');%colorbar;
        axis equal;axis([1 size(A,2) 1 size(A,1)]);
        subplot(1,2,2);imagesc(B);xlabel('Double-Window Processed Image');
        axis equal;axis([1 size(B,2) 1 size(B,1)]);
    case 4
        subplot(1,2,1);imagesc(A);xlabel('Original Image');%colorbar;
        axis equal;axis([1 size(A,2) 1 size(A,1)]);
        subplot(1,2,2);imagesc(B);xlabel('Double-Window Processed Image');
        axis equal;axis([1 size(B,2) 1 size(B,1)]);
end

toc
%========================================================
function [C]=My_simple_window(A,image_depth,tones,WW,WL)
C=A;

% Formulas:
% 1. WW = Vb - Va
% 2. WC = (Vb+Va)/2

x=size(C,1);
y=size(C,2);
Vb=(2.0*WL+WW)/2.0; % Formula 2 solving to find Vb, by substituting Va from
                    % Formula 1
if(Vb>image_depth)  % if Vb exceeds image depth then set it to image depth
    Vb=image_depth;
end;

Va=Vb-WW; % use of Formula 1 to find Va

if(Va<0) % if Va outreaches image depth minimum=0 then set to 0
    Va=0;
end;

% make the simple window tone function
for i=1:x 
    for j=1:y 
        ival=C(i,j);    % initial tone value of C(i,j).Takes elements in a uint8 format
        if (ival>=Va & ival<=Vb)  
            tone=(tones-1)*(double(ival)-Va)/(Vb-Va);
        end;
        if (ival<Va) 
            tone=0; 
        end;
        if (ival>Vb) 
            tone=tones-1;
        end;
        
        C(i,j)=tone; % final tone value of C(i,j)
    end; 
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [C]=My_broken_window(A,image_depth,tones,gray_val,im_val)
C=A;

x=size(C,1);
y=size(C,2);
for i=1:x 
    for j=1:y 
        ival=C(i,j);    % initial tone value of C(i,j)
        if (ival>=0 && ival<im_val) % then use the first triangle
            tone=(gray_val)*(double(ival)-0)/(im_val-0);
        elseif(ival == im_val) 
            tone=gray_val;
        elseif (ival>im_val && ival<=image_depth) % then use the second triangle
            tone=(tones-1)*(double(ival)-(im_val))/(image_depth-(im_val)); 
        elseif (ival<0) 
            tone=0; 
        elseif (ival>image_depth) 
            tone=image_depth; 
        end;
        
        C(i,j)=tone;    % final tone value of C(i,j)
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [C]=My_double_window(A,image_depth,tones,ww1,ww2,wl1,wl2)
C=A;

x=size(C,1);
y=size(C,2);

% Formulas:
% 1. WWx = Vbx - Vax
% 2. WCx = (Vbx+Vax)/2

Vb1=(2.0*wl1+ww1)/2.0;
Va1=Vb1-ww1;
Vb2=(2.0*wl2+ww2)/2.0;
Va2=Vb2-ww2; 

if(Vb2>image_depth)     % set the Vb2 max limit
    Vb2=image_depth;
end;
if(Va1<0)               % set the Va1 min limit
    Va1=0;
end; 
for i=1:x
    for j=1:y
        ival=C(i,j);    % initial tone value of C(i,j)
        if (ival>=Va1 && ival<=Vb1)  
            tone=(tones-1)*(double(ival)-Va1)/(Vb1-Va1);    % 1st window
        elseif (ival>Vb1 && ival<Va2)
            tone=floor((tones-1)/2);        % round down the tone value
        elseif (ival>=Va2 && ival<=Vb2)  
            tone=(tones-1)*(double(ival)-Va2)/(Vb2-Va2);    % 2nd window
        elseif (ival<Va1)
            tone=0; 
        elseif (ival>Vb2) 
            tone=tones-1;
        end;
        
        C(i,j)=tone;    % final tone value of C(i,j)
    end; 
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [C]=My_non_linear_window(A,image_depth,tones,funct)
C=A;

x=size(C,1);
y=size(C,2);

min_C = min(min(C));
max_C = max(max(C));

switch funct
    case 1  % use of cosine function
            % interval for non-linear function window is set to (0,pi/2)
        for i=1:x
            for j=1:y
                ival=(C(i,j)-min_C)*((pi/2)/(max_C-min_C));     % initial tone value of C(i,j) normalized in (0,1)
                tone=cos(ival)*(tones-1);
 
                C(i,j)=tone;    % final tone value of C(i,j)
            end;
        end;
        
    case 2  % use of sine function
            % interval for non-linear function window is set to (0,pi/2)
        for i=1:x
            for j=1:y
                ival=(C(i,j)-min_C)*((pi/2)/(max_C-min_C));     % initial tone value of C(i,j) normalized in (0,1)
                tone=sin(ival)*(tones-1);
               
                C(i,j)=tone;    % final tone value of C(i,j)
            end;
        end;
        
    case 3  % use of exponential function
            % interval for non-linear function window is set to (0,3)
        for i=1:x,
            for j=1:y,
                ival=(C(i,j)-min_C)*(3/(max_C-min_C));      % initial tone value of C(i,j)
                tone=exp(ival);        
                
                C(i,j)=tone;
            end;
        end;    
        
        max_C=max(max(C));
        min_C=min(min(C));
        
        % C(i,j) normalized in the (0,1) interval  
        for i=1:x
            for j=1:y
                tone=(C(i,j)-min_C)*(1/(max_C-min_C));      
                C(i,j)=tone*(tones-1);  % final tone value of C(i,j)
            end;
        end;         
        
    case 4  % use of quadratic function
        for i=1:x
            for j=1:y
                tone=C(i,j)^2;
                C(i,j)=tone;
            end;
        end;
        
        max_C=max(max(C));
        min_C=min(min(C));        
        
        % C(i,j) normalized in the (0,1) interval  
        for i=1:x
            for j=1:y
                tone=(C(i,j)-min_C)*(1/(max_C-min_C));      
                C(i,j)=tone*(tones-1);
            end;
        end;
    case 5  % use of cubic function
        for i=1:x
            for j=1:y
                tone=C(i,j)^3;
                C(i,j)=tone;
            end;
        end;
        
        max_C=max(max(C));
        min_C=min(min(C));        
        
        % C(i,j) normalized in the (0,1) interval  
        for i=1:x
            for j=1:y
                tone=(C(i,j)-min_C)*(1/(max_C-min_C));      
                C(i,j)=tone*(tones-1);
            end;
        end;            
end;



