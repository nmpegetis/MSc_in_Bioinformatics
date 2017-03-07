function [] = Program_8_123_nbegetis()
    clear all; close all; clc;
    %%%%%%%%%%%%%%%%% user input %%%%%%%%%%%%%%%%%
    imFileName1 = {'MIC_Astrocytomas_HighGrade'; 'MIC_Astrocytomas_LowGrade'};
    imFileName = imFileName1; %Choose Project
    % roi dimensions
    dx = 10; dy = 10;
    %%%%%%%%%%%%%%%%% main program %%%%%%%%%%%%%%%%%
    %read image
    for fName = 1 : 2 %for each one of two classes read one image
      im = imread(imFileName{fName}, 'bmp');
      %display image
      colormap('gray'); figure(1); imagesc(im);

      %select and save rois
      roi_central_point = 0;
      k = 0;
      while (prod(size(roi_central_point)) ~= 0) %while at ginput if ENTER is NOT pressed
        figure(1); roi_central_point = ginput(1); % 
        hold on;
        if (prod(size(roi_central_point)) ~= 0) %if ENTER has not been pressed
          selectRois(roi_central_point, dx, dy); %draw square around selected point
          %save ROI in array roi
          clear roi;
          for i = 1 : 2 * dx + 1
            for j = 1 : 2 * dy + 1
              roi(j,i) = im(round(roi_central_point(2) - dy + j), round(roi_central_point(1) - dx + i)); %save in roi
            end
          end

          k = k + 1;
          [features] = createClassFeatureFiles(roi); %calculate features

          %store feature vectors in appropriate classes 
          if (fName == 1) class1(k, :) = features; end;
          if (fName == 2) class2(k, :) = features; end;
        end
      end %of while 
      close all;

      switch (fName)
        case 1
          save('Class_1.dat', 'class1', '-ascii'); 
        case 2
          save('Class_2.dat', 'class2', '-ascii'); 
      end %of switch
    end %fName
    format short g;
      class1
      class2
end