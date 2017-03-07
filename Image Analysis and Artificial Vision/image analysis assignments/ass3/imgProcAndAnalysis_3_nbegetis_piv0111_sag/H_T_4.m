%A Program to ilusrate the H.T construction and the line detection of an
%image.
clear *;close all;,clc;
I  = imread('circuit.tif');%circuit.tif is an image of the MATLAB
rotI = imrotate(I,33,'crop'); % Rotate image so that the lines will not be paralel to the axis
BW = edge(rotI,'canny');
% Construct and display HT 
[H,T,R] = hough(BW);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
% Locate at most 3 points of HT greater than the threshold 
P  = houghpeaks(H,3,'threshold',0.3*max(H(:))); % It searches for 3 peak-points of H-T
%Plot  the points on the HT image.
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
% Find lines and plot them
lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
figure, imshow(BW), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');


end

