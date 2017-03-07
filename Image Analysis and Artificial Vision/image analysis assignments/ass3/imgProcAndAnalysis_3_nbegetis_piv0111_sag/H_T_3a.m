clear *;,clc;,close all;
I  =double( imread('monument.tif'));
BW = edge(I,'canny');
[H,T,R] = hough(BW);
Peaks  = houghpeaks(H,2);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(T(Peaks(:,2)),R(Peaks(:,1)),'s','color','white');
