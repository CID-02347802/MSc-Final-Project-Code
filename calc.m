% --------------------------------------------------------%
% Project Title: Green RFID
% Name: Mark Houlton
% CID: 02347802
% Date last modified 09/09/2023
% SIMULATION MODEL SOLVING FOR CURRENT
% --------------------------------------------------------%

% Importing Data from excel file
Excel_data = readmatrix("Sim Data.xlsx","Sheet","Sheet1");
rel = Excel_data(:,1);
theta = Excel_data(:,2);
V = Excel_data(:,3);


% Defining arrays and variables
I_array = [];
z_array = [];
I1_array = [];
Z_fin_array = [];
S11_array = [];

L_1 = 2.3e-6;
L_2 = 2.3e-6;
C_1 = 60e-12;
C_2 = 51.6e-12;
w_1 = 2*pi*13.56e6;
w_2 = 2*pi*14.61e6;
R_1 = 19.6;
R_2 = 21.1/10;

%Distance variable x is a changable input
x = 40;

% Coupling coefficient and Mutual Inductance calculations
k = ((38.58^2)*(38.58^2))/(sqrt(38.58*38.58)*(sqrt(x^2+38.58^2))^3);
M = k*sqrt(L_1*L_2);

% Thevenin equivalent constants equations
Const_A = (j*w_1*L_1)+(1/(j*w_1*C_1))+R_1;
Const_B = (j*w_2*L_2)+(1/(j*w_2*C_2))+R_2;

% Convert angles to radians
theta2=(pi/180)*(theta);

% Main loop to solve for all currents all 30 voltages
for i = 1:30
    [X,Y]=pol2cart(theta2(i),rel(i));
    I = X + j*Y;
    I_array = [I_array;I];

    Z = V(i)/I;
    z_array = [z_array;Z];

    f=@(I1,I2)...
            [V(i)-Const_A*I1+(j*w_2*M)*I2;
             (Const_B+Z)*I2-(j*w_1*M)*I1;
            ];
        
    fp=@(y) f(y(1),y(2));
    [y, fval, info] = fsolve (fp,[0;0]);
        
    I1=y(1);
    I1_array = [I1_array;I1];

    Z_fin = V(i)/I1;
    Z_fin_array = [Z_fin_array;Z_fin];

    % Converts impedance to S11
    S11 = (Z_fin-50)/(Z_fin+50);
    S11_array = [S11_array;S11];
end

% Creates a linear x axis based on the voltages
XAXIS_Val = 100;
Xstep = 100;
XAXIS = [XAXIS_Val];

for i = 1:29
    XAXIS_Val = XAXIS_Val + Xstep;
    XAXIS = [XAXIS;XAXIS_Val];
end

% Absolute values of S11 conversion
S11_array_abs = 20*log10(abs(S11_array));

% Plots absolute values of S11 against voltage
figure(1);
plot(XAXIS,20*log10(abs(S11_array)))
hold on
title('Minimum values of S11 calculated for each voltage level (40mm)','FontSize',15)
ylabel('S11 [dB]','FontSize',15)
xlabel('Voltage [mV]','FontSize',15)
hold off
