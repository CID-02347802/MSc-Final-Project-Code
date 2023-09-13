% --------------------------------------------------------%
% Project Title: Green RFID
% Name: Mark Houlton
% CID: 02347802
% Date last modified 09/09/2023
% MAIN PROGRAM FOR EXPERIMENT S11 MEASUREMENTS
% --------------------------------------------------------%

array = [];

% Frequency range 12.5MHz to 14.5MHz with 4000Hz steps
fstart = 12.5e6;
fstop = 14.5e6;
npoints = 500;
freq = linspace(fstart,fstop,npoints);
     
% Measures S11 and stores values in array, iterates for set number of times
for f = 1:100     
    s11 = S11(fstart,fstop,npoints);
    array = [array,s11];
end

% Averages all S11 profiles
array_2 = mean(array,2);

% Absolute value of average S11 profile
array_3 = abs(array_2);

% Importing Excel file to save data externally
DATA_table = readmatrix("Full_range_30mm_v2.xlsx","Sheet","Sheet 1");
DATA_table = [DATA_table,array_3];
%Saving data to excel file
writematrix(DATA_table,"Full_range_30mm_v2.xlsx")

% Plots the absolute S11 profile against frequency
figure;
hold on
for i = 1:100
    plot(20*log10(abs(array(:,i))))
end
plot(freq,20*log10(abs(array_2)),'r--','linewidth',2)
hold off

