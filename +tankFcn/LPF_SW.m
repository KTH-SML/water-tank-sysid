% --- AVERAGE THE LAST 5 DATA POINTS --- %
% INPUT
% 1. hisotry: 5x1 vector storing the last 5 data point information
% 2. in: 1x1 scalar, real time reading data

function y = LPF_SW(u)
    persistent x1 x2
    if isempty(x1)
        x1 = 0;
        x2 = 0;
    end
    A1 = 0.3679;
    B1 = 1;
    C1 = 0.6321;
    D1 = 0;
%     A1 = 0.8607;
%     B1 = 1;
%     C1 = 0.1393;
%     D1 = 0;
    x1 = A1*x1 + B1*u(1,1);
    y1 = C1*x1 + D1*u(1,1);
    
    A2 = 0.3679;
    B2 = 1;
    C2 = 0.6321;
    D2 = 0;
    x2 = A2*x2 + B2*u(1,2);
    y2 = C2*x2 + D2*u(1,2);
    
    y = [y1,y2];
end