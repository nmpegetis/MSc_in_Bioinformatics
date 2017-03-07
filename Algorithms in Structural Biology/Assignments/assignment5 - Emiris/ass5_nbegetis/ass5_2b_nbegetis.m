function []= ass5_2b_nbegetis()
    clc;echo off;close all;clear all;

     c=2.285;
     u=1.526;
     x=4.685396365;
     y=2.63120838;
     z=0.4330644;
     B=[0,1,1,1,1,1,1;1,0,u,c,x,c,u;1,u,0,u,c,y,c;1,c,u,0,u,c,z;1,x,c,u,0,u,c;1,c,y,c,u,0,u;1,u,c,z,c,u,0];
     M=[0,u,c,x,c,u;u,0,u,c,y,c;c,u,0,u,c,z;x,c,u,0,u,c;c,y,c,u,0,u;u,c,z,c,u,0];

    s=svd(B);
    s=round(s*1000)/1000;
    tol=max(size(B))*eps(max(s));
    r = sum (s>tol);
    msgbox(sprintf('r= [%d]',r))

    threshold = 0.001;
    
    for i=1:5
        for j=1:5
            G(i,j)=(M(i,5)+M(j,5)-M(i,j));
        end
    end
    [U,S,V] = svd(G);
    for i=1:5
        for j=1:5
            if U(i,j) < threshold
                U(i,j) = 0;
            end
            if S(i,j) < threshold
                S(i,j) = 0;
            end
            if V(i,j) < threshold
                V(i,j) = 0;
            end
        end
    end
    msgbox(sprintf('U= [%d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d]',U))
    msgbox(sprintf('S= [%d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d]',S))
    msgbox(sprintf('V= [%d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d]',V))

    P=sqrt(S)*V';
    for i=1:5
        for j=1:5
            if P(i,j) < threshold
                P(i,j) = 0;
            end
        end
    end
    msgbox(sprintf('P= [%d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d ;\n %d,%d,%d,%d,%d]',P))
end