function []= ass5_1c_nbegetis()
    clc;echo off;close all;clear all;
    
    M= [0,2,1;
        2,0,1;
        1,1,0;
        ];

    G=zeros();
    for i=1:2
        for j=1:2
            G(i,j)=(M(i,1)+M(j,1)-M(i,j));
        end;
    end;

    [U,S,V]=svd(G);
    msgbox(sprintf('U= [%d,%d ; %d,%d] \n S= [%d,%d ; %d,%d]\n V= [%d,%d ; %d,%d]',U,S,V))

    P=sqrt(S)*V';
    msgbox(sprintf('P= [%d,%d ; %d,%d]',P))
end