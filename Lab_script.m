%clearvars
%close all
clc

CASE = 1;       % 0 for minimum phase case, 1 for non minimum phase case

%% Parameters
A = 15.52;      %cm^2
u_max = 15;     %V
g = 981;        %cm/s^2

if CASE == 0
    gamma1 = 0.625;
    gamma2 = 0.625;
elseif CASE == 1
    gamma1 = 0.375;
    gamma2 = 0.375;
end

h10 = 17;      % i cm (nedre vänstra tanken)
h20 = 20.2;      % i cm (nedre högra tanken)
h30 = 1.5;       % i cm (övre vänstra tanken)
h40 = 2.7;       % i cm (övre högra tanken)

% Operating voltage of pumps
u10 = 6.75;     % i V
u20 = 6.75;     % i V

% Operating actuator proportional constants
k1 = 6.5572;     % i cm^3/(Vs)
k2 = 6.0356;     % i cm^3/(Vs)

% Outlet areas
a1 = 0.22;   % i cm^2
a2 = 0.22;   % i cm^2
a3 = 0.36;  % i cm^2
a4 = 0.32;  % i cm^2

% Valve settings
gam1 = 1-0.625;
gam2 = 1-0.625;
% Change the parameter inside file minphase.m and nonminphase.m
% 3.1.1 
%% Decentralized controller
if (CASE == 0)      % MINIMUM PHASE SYSTEM
    sys = minphase;
    wc = 0.1
elseif (CASE == 1)  % NON-MINIMUM PHASE SYSTEM
    sys = nonminphase;
    wc = 0.02
end
pm = pi/3
G = tf(sys);
RGA_G0 = freqresp(G, 0) .* freqresp(inv(G).', 0)
RGA_GWc = freqresp(G, wc) .* freqresp(inv(G).', wc)
pair11 = sqrt((real(RGA_GWc(1,1)) - 1)^2 + imag(RGA_GWc(1,1))^2)
pair12 = sqrt((real(RGA_GWc(1,2)) - 1)^2 + imag(RGA_GWc(1,2))^2)
% CHECK THE PAIRINGS:
% - MP: best pairs {u1,y1} and {u2,y2}.
% - NMP: best pairs {u1,y2} and {u1,y2}.
if (CASE == 0)
    G1 = G(1,1);
    G2 = G(2,2);
elseif (CASE == 1)
    G1 = G(2,1);
    G2 = G(1,2);   
end
% F1 
[m_G1, p_G1] = bode(G1, wc);
p_G1 = deg2rad(p_G1);
T1 = tan(-pi/2 + pm - p_G1) / wc;
L1 = G1 * tf([T1 1], [T1 0]);
[m_L1, p_L1] = bode(L1, wc);
K1 = 1 / m_L1;
F1 = K1 * tf([T1 1], [T1 0]);
% F2
[m_G2, p_G2] = bode(G2, wc);
p_G2 = deg2rad(p_G2);
T2 = tan(-pi/2 + pm - p_G2) / wc;
L2 = G2 * tf([T2 1], [T2 0]);
[m_L2, p_L2] = bode(L2, wc);
K2 = 1 / m_L2;
F2 = K2 * tf([T2 1], [T2 0]);
%F
if (CASE == 0)
    F = [F1,  0;
          0, F2]
elseif (CASE == 1)
    F = [0, F1;
        F2,  0]
end
% Save the controller
F = ss(F,'min');
[A,B,C,D] = ssdata(F)
if CASE == 0
    save reg_dec_MP.MAT A B C D
elseif CASE == 1
    save reg_dec_NMP.MAT A B C D
end

%% Simulation
% CHECK if small step response causes control signal saturation (-0.5, 0.5)
% sim('closedloop')
% figure; subplot 211
% plot(yout, 'linewidth', 1); title("Outputs response for step in r1 (at 100s) and in r2 (at 500s)");
% ylabel("y(t)"); legend("y1(t)", "y2(t)"); set(gca, 'fontsize', 12);
% subplot 212
% plot(uout, 'linewidth', 1); title("Inputs response for step in r1 (at 100s) and in r2 (at 500s)");
% ylabel("u(t)"); legend("u1(t)", "u2(t)"); set(gca, 'fontsize', 12);

%% Robustified Glover-McFarlane controller
%Dynamical decoupling
if CASE == 0      % MINIMUM PHASE SYSTEM
    sys = minphase;
    wc = 0.1
elseif CASE == 1  % NON-MINIMUM PHASE SYSTEM
    sys = nonminphase;
    wc = 0.02
end
pm = pi/3
G = tf(sys);
RGA_G0 = freqresp(G, 0) .* freqresp(inv(G).', 0)
RGA_GWc = freqresp(G, wc) .* freqresp(inv(G).', wc)
pair11 = sqrt((real(RGA_GWc(1,1)) - 1)^2 + imag(RGA_GWc(1,1))^2)
pair12 = sqrt((real(RGA_GWc(1,2)) - 1)^2 + imag(RGA_GWc(1,2))^2)
% CHECK THE PAIRINGS:
% - MP: best pairs {u1,y1} and {u2,y2}.
% - NMP: best pairs {u1,y2} and {u1,y2}.
if CASE == 0
    w11 = 1;
    w22 = 1;
    w12 = -G(1,2) / G(1,1);
    w21 = -G(2,1) / G(2,2);
    % -MP: W1 is already proper.
elseif CASE == 1
    w12 = 1;
    w21 = 1;
    w11 = -G(2,2) / G(2,1);
    w22 = -G(1,1) / G(1,2);
    % -NMP: W1 is not proper, we need a pole in W11 and W22.
    w11 = w11 * tf(10*wc, [1 10*wc]);
    w22 = w22 * tf(10*wc, [1 10*wc]);
end
W1 = [w11  w12;
      w21  w22]
W2 = eye(size(G));
G_tilde = minreal(W2 * G * W1);
% -MP: G_tilde has positive static gain
% -NMP: G_tilde has positive static gain
% Design of PI-controllers
G1 = G_tilde(1,1);
G2 = G_tilde(2,2);
% F1_tilde
[m_G1, p_G1] = bode(G1, wc);
p_G1 = deg2rad(p_G1);
T1 = tan(-pi/2 + pm - p_G1) / wc;
L1 = G1 * tf([T1 1], [T1 0]);
[m_L1, p_L1] = bode(L1, wc);
K1 = 1 / m_L1;
F1_tilde = K1 * tf([T1 1], [T1 0]);
% F2_tilde
[m_G2, p_G2] = bode(G2, wc);
p_G2 = deg2rad(p_G2);
T2 = tan(-pi/2 + pm - p_G2) / wc;
L2 = G2 * tf([T2 1], [T2 0]);
[m_L2, p_L2] = bode(L2, wc);
K2 = 1 / m_L2;
F2_tilde = K2 * tf([T2 1], [T2 0]);
%F
F_tilde = [F1_tilde,  0;
           0,         F2_tilde];
F = minreal(W1 * F_tilde * W2);
% Glover-McFarlane controller
L0 = minreal(G * F);
alpha = 1.1;        % Suitable choice
[Fr, gamma] = rloop(L0, alpha);
disp(gamma);
% -MP: gamma =  --> ok
% -NMP: gamma =  --> ok
F = minreal(F * Fr)
% Save the controller
F = ss(F,'min');
[A,B,C,D] = ssdata(F)
if CASE == 0
    save reg_GMc_MP.MAT A B C D
elseif CASE == 1
    save reg_GMc_NMP.MAT A B C D
end

%% Simulation
% CHECK if small step response causes control signal saturation (-0.5, 0.5)
sim('closedloop')
figure; subplot 211
plot(yout, 'linewidth', 1); title("Outputs response for step in r1 (at 100s) and in r2 (at 500s)");
ylabel("y(t)"); legend("y1(t)", "y2(t)"); set(gca, 'fontsize', 12);
subplot 212
plot(uout, 'linewidth', 1); title("Inputs response for step in r1 (at 100s) and in r2 (at 500s)");
ylabel("u(t)"); legend("u1(t)", "u2(t)"); set(gca, 'fontsize', 12);