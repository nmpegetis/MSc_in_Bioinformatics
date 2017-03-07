
    clear *; close all; clc;

    % Read the sample image im (grayscale image)
    im = imread('shapessm.jpg');
    
    % Find edges using the Canny operator with hysteresis thresholds of 0.1
    % and 0.2 with smoothing parameter sigma set to 1.
    edgeim = edge(im,'canny', [0.1 0.2], 1);

    figure(1), imshow(edgeim); % truesize(1)
    
    % Link edge pixels together into lists of sequential edge points, one
    % list for each edge contour.  Discard contours less than 10 pixels long.
    [edgelist, labelededgeim] = edgelink(edgeim, 10);
    
    % Display the labeled edge image with random colours for each
    % distinct edge in figure 2
    drawedgelist(edgelist, size(im), 1, 'rand', 2); axis off        
    
