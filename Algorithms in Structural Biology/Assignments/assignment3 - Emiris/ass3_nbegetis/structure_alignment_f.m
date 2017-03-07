%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Author: Begetis Nikolaos - Postgraduate Student - Bioinformatics, ITMB
%% Supervisor: Emiris Ioannis - Professor - ITMB
%% Course: Algorithms in Structural Bioinformatics
%% Function: 
%% Task (a): We compute the cRMSD of the x and y pointsets
%% Task (b): We compute the centroids and translate both sets to the
%% origin. Then computes their new cRMSD
%% Task (c): We find the optimal rotation for alignent. Then we apply it to
%% one pointset and afterwards we compute the cRMSD.
%% Task (d): For the input sets, we compute their distance d-RMSD, and by
%% using that we can now infer the final sets in Task (c) without
%% computing any d-RMSD.
%% Task (f): Repeat task (a)-(c) for x and y pointsets amplified by 
%% two eigenvectors 
%% Filename: structure_alignment.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []=structure_alignment()
clc;echo off;close all;clear all;

%% Task (a): We compute the cRMSD of the x and y pointsets

x=[ 0,0,0; 
    2,0,0; 
    1,1,0; 
    0,0,1;
    -1,1,-1];

y=[ 2,0,0; 
    2,-2,0; 
    3,-1,0; 
    2,0,1;
    0,1,1];

lines=size(x,1);
columns=size(x,2);

% assign to x and y, their inverse matrices
x=x';
y=y';
Mf=(x-y)'*(x-y); % Mf = (M^T)*M

% cRMSD computation for atom coordinates
cRMSD = double(1/sqrt(lines))*sqrt(trace(Mf)); % the sum of the diagonal 
% elements of the matrix Mf.

disp('cRMSD output from Task (a):');
cRMSD


%% Task (b): We compute the centroids and translates both sets to the
%% origin. Then computes their new cRMSD

% centroids computation
for i=1:columns
    x_c(i)=double(1/lines)*sum(x(i,:));  % x_c = 1/n *sum_i(x_i)
    y_c(i)=double(1/lines)*sum(y(i,:));  % y_c = 1/n *sum_i(y_i)

    % now translate to common origin
    for j=1:lines
        x_trans(i,j)=x(i,j)-x_c(i)';
        y_trans(i,j)=y(i,j)-y_c(i)';
    end
end

x_trans=x_trans';
y_trans=y_trans';
Mf_new=(x_trans-y_trans)'*(x_trans-y_trans); % Mf = (M^T)*M

% new cRMSD computation for atom coordinates
cRMSD_new = double(1/sqrt(lines))*sqrt(trace(Mf_new));

disp('new cRMSD output from Task (b):');
cRMSD_new


%% Task (c): We find the optimal rotation for alignent. Then we apply it to
%% one pointset and afterwards we compute the cRMSD.

%% Optimal cRMSD computation

% Find Singular Value Decomposition to use it for optimal rotation
[U,S,V] = svd(x_trans'*y_trans); % produces a diagonal matrix S of the same
% dimension as (x_trans^T)*y_trans, with nonnegative diagonal elements in 
% decreasing order, and unitary matrices U and V so that X = U*S*V'.

% Q = U*(V^T)
Q=U*V';

disp('optimal rotation Q output from Task (c):');
Q


Mf_opt=(x_trans*Q-y_trans)'*(x_trans*Q-y_trans);    % Mf = (M^T)*M

cRMSD_opt= double(1/sqrt(lines))*sqrt(trace(Mf_opt));

disp('optimal cRMSD output from Task (c):');
cRMSD_opt


%% Task (d): For the input sets, we compute their distance d-RMSD, and by
%% using that we can now infer the final sets in Task (c) without
%% computing any d-RMSD.

% distance d-RMSD computation for k matched distances 
% suppose k = lines = 4

k = 4
for j=1:4
    for i=1:4
        if (j<i)
            dRMSD = sqrt(2/4*(4-1)*(dist(x(j,i))-dist(y(j,i))).^2); % dist 
            % returns all the distances of x(j,i) matrix, it is equivalent
            % to sum_i=1^k(d_i)
        end
    end
end

disp('distance dRMSD output from Task (d):');
dRMSD


end