clear *; clc
close all
%  AN EXAMPLE HOW  YOU CAN  READ AN IMAGE FROM AN IMAGE FILE (board.tif) INTO 
%  AN ARRAY OF REAL NUMBERS IN THE MEMMORY (I64).
I8=imread('picture_with_wrong_illumination_2.bmp');
%    FIRST THE IMAGE IS READ IN I8 ARRAY OF unsigned integers TYPE.
%    No arithmetic operations can be performed with unsigned integers
%    Unsigned Integers can be used to display the histogram of the image:
figure;
imhist(I8); %EXAMPLE HOW YOU CAN DISPLAY THE IMAGE's HISTOGRAM%
%           For to display the image:
figure;
imshow(I8);
%  for this last display do not have any cofidence on the real dimensions of the 
%  displayed picture.
%
%
I64=double(I8);% computes I64 reals with which arithmetic operations can be 
%performed............
%          ...........
%            ............
%
%  After the operations if we want to construct a new image file
%  we work as follows
%  Suppose that by the above operations   a real array 'van' 240X180 has been constructed
%  In place of the constructed array we define an array of random numbers
%  (van)
nline=240;
ncl=180;
van=randn(nline,ncl); 
%We use random numbers with a small corelation to initialise array van.
%
%
% CONSTRUCTION OF THE ARRAY VAN
van1=van;
mask=[1 2 1 3 4 3 1 2 1]';
for ln=2:nline-1
   for cl=2:ncl-1
      scratc=van(ln-1:ln+1,cl-1:cl+1);
      van1(ln,cl)=scratc(:)'*mask;
   end
end
van=van1;
% AN EXAMPLE HOW YOU CAN CONVERT  AN ARRAY (van) OF REAL NUMBERS INTO AN IMAGE
% FILE (random_van.bmp).
%  In order to construct an image from van
%  THE SIGNAL  van IS NORMALISED TO THE [0,255] INTERVAL
ivan=van-min(van(:)); %first the array is transformed to[0,max(van)min(van)]
%after that van is quantised to 255 level
conx=1/max(ivan(:));
ivan=round(ivan*conx*255);
ivan=uint8(ivan);%transform array to unusign integers
imwrite(ivan,'random_van.bmp');%THE IMAGE FILE IS READY!!
% You can see the constructd image in an image tool like paint
% or even you can display it by matlab.
figure 
imshow (ivan)
