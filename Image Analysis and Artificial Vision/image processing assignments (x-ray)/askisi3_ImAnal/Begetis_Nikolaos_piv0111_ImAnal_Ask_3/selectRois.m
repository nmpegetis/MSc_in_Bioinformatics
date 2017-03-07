function [] = selectRois(roi_central_point, dx, dy)
    plot([roi_central_point(1) - dx roi_central_point(1) + dx], [roi_central_point(2) - dy roi_central_point(2) - dy], 'r');
    plot([roi_central_point(1) + dx roi_central_point(1) + dx], [roi_central_point(2) - dy roi_central_point(2) + dy], 'r');
    plot([roi_central_point(1) - dx roi_central_point(1) + dx], [roi_central_point(2) + dy roi_central_point(2) + dy], 'r');
    plot([roi_central_point(1) - dx roi_central_point(1) - dx], [roi_central_point(2) - dy roi_central_point(2) + dy], 'r');
end