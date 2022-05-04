close all
clear

load short_modem_rx.mat

%% Plot Signal
figure(1);
t = (0:length(y_r)-1) / Fs;
plot(t,y_r)
title("Transmission over time")
xlabel("Time (s)")
ylabel("Magnitude")

%%
% The received signal includes a bunch of samples from before the
% transmission started so we need discard these samples that occurred before
% the transmission started. 

start_idx = find_start_of_signal(y_r,x_sync);
% start_idx now contains the location in y_r where x_sync begins
% we need to offset by the length of x_sync to only include the signal
% we are interested in
y_t = y_r(start_idx+length(x_sync):end); % y_t is the signal which starts at the beginning of the transmission



% convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits
% BitsToString(x_d)

