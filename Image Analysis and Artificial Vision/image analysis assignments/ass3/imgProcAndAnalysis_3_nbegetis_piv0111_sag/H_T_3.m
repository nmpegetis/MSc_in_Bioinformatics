% A program to demonstrate the formation & display of Hough Transform
clc;clear *;close all;
% Input Image from image file
I  = double(imread('monument.tif'));
% Evaluate the edge image (black-white)
ima = edge(I,'canny');
%Evaluate H.T. ofr the constructed black-white image.
[H,T,R] = hough(ima,'RhoResolution',1,'ThetaResolution',0.5);
% display the  black-white edge image
figure;imshow(ima,[]);
title('monument');
% display the  H.T. as an image with pseudocoor.Construct image to have
%the monitor' ratio.  
figure;
imshow(H,[0,0.6*max(H(:))],'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough transform of monument');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal,
hold on;
colormap(hot);