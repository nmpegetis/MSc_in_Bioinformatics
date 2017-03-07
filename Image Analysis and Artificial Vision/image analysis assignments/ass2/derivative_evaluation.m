% This program describes by example:
%        1. how to convolve a mask with an image
%        2. how to construct an image file (true gray scale) with 8 bit data 
%         (true gray scale) is used to distinguish from index gray scale which is constructed 
%          when colormap is used. 
% The Sobel masks are used to evaluate  the 2-D signals x-derinatine, y-derivative
% and the sum of them and construct image files for the presentation of these three 2D dignals 

clear;


I8=imread('AIRPORT.tif');% Be caruful the file  AIRPORT.tif to be in working 
%                           directory or else write explicitely the whole path
%                         (i,e  'C:\data\...\project\AIRPORT.TIF')in a directory of the MATLAB-path
I64=double(I8);
%Sobel operators
masky=[-1 -2 -1;
   0 0 0;
   1 2 1];
maskx=[-1 0 1;
   -2 0 2;
   -1 0 1];
Gx=conv2(I64,maskx,'same');%conv2 runs cnvolution. Use help for more details
Gy=conv2(I64,masky,'same');
Gxy=Gx+Gy;
%
%Construct image files for the 3D signals Gx and Gy
% 
%first the signals are normalised in the  [0,255] INTERVAL (double precision)
Gx=Gx-min(Gx(:));Gx=Gx/max(Gx(:))*255;
Gy=Gy-min(Gy(:));Gy=Gy/max(Gy(:))*255;
Gxy=Gxy-min(Gxy(:));Gxy=Gxy/max(Gxy(:))*255;
%second quantise the signals transform to int8. 
Gx=uint8(round(Gx));
Gy=uint8(round(Gy));
Gxy=uint8(round(Gxy));
%Finaly write the image file
imwrite(Gx,'AIRPORT_x-der.tif');%The image is written in th workin directory. 
%                                Give full path if you wish image to be written in another directory.
imwrite(Gy,'AIRPORT_y-der.tif');
imwrite(Gxy,'AIRPORT_xy-der.tif');
