close all
clear

load short_modem_rx.mat

img_output_dir = "short_plots";
if ~exist(img_output_dir, 'dir')
    mkdir(img_output_dir);
end

%% Plot Signal
figure(1);
t = (0:length(y_r)-1) / Fs;
plot(t,y_r)
title("Received Signal over time")
xlabel("Time (s)")
ylabel("y_r")

saveas(gcf, fullfile(img_output_dir, "signal.png"))

%% Trim message
% The received signal includes a bunch of samples from before the
% transmission started so we need discard these samples that occurred before
% the transmission started. 

start_idx = find_start_of_signal(y_r,x_sync);
% start_idx now contains the location in y_r where x_sync begins
% we need to offset by the length of x_sync to only include the signal
% we are interested in
fs = 100;  % Symbol period
msg_length_samples = msg_length * 8 * fs;
k = (0:msg_length_samples-1)';
t = k / Fs;  % for plotting in seconds

y_t = y_r(start_idx+length(x_sync):end);
y_t = y_t(1:msg_length_samples);

figure(2);
plot(t, y_t);
title("Trimmed signal")
xlabel("Time (s)")
ylabel("y_t")

saveas(gcf, fullfile(img_output_dir, "trimmed.png"))

figure(3);
plot_ft_rad(y_t, Fs);
title("Trimmed signal frequency plot")

saveas(gcf, fullfile(img_output_dir, "trimmed_freq.png"))

%% Convolute with the cosine
c = cos(2*pi*f_c/Fs * k);
y_c = y_t .* c;

figure(4);
plot(t, y_c);
title("Convolved signal");
xlabel("Time (s)");
ylabel("y_c");

saveas(gcf, fullfile(img_output_dir, "convolved.png"))

figure(5);
plot_ft_rad(y_c, Fs);
title("Convolved signal frequency plot")

saveas(gcf, fullfile(img_output_dir, "convolved_freq.png"))

%% Low pass filter
W = 2 * pi * f_c;
t_lpf = (-100:99) * (1/Fs);  % this needs to be an even number for cleanliness
lpf = W/pi * sinc(W/pi .* t_lpf);

figure(6);
plot(t_lpf, lpf);
title("Low pass filter signal");
xlabel("Time (s)");
ylabel("lpf");

saveas(gcf, fullfile(img_output_dir, "lpf.png"))

figure(7);
plot_ft_rad(lpf, Fs);
title("Low pass filter frequency plot")

saveas(gcf, fullfile(img_output_dir, "lpf_freq.png"))

%% Apply filter
y_f = conv(y_c, lpf);

% We want y_f to be the sme length as y_c, so trim the ends off (that get
% added due to the length of the low pass filter
y_f_trimmed = y_f(length(lpf)/2:end-length(lpf)/2);

figure(8);
plot(t,y_f_trimmed);
title("Filtered signal");
xlabel("Time (s)");
ylabel("y_f");

saveas(gcf, fullfile(img_output_dir, "filtered.png"))

figure(9);
plot_ft_rad(y_f_trimmed, Fs);
title("Filtered signal frequency plot")

saveas(gcf, fullfile(img_output_dir, "filtered_freq.png"))

%% Get bits in 0-1 form
y_n = y_f_trimmed ./ abs(y_f_trimmed);
y_n = (y_n + 1) / 2;

figure(10);
plot(t,y_n);
title("Normalized signal");
xlabel("Time (s)");
ylabel("y_n");

saveas(gcf, fullfile(img_output_dir, "norm.png"))

figure(11);
plot_ft_rad(y_n, Fs);
title("Normalized signal frequency plot")

saveas(gcf, fullfile(img_output_dir, "norm_freq.png"))

%% Decode message

% convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits
x_d = downsample(y_n, fs, fs/2);

BitsToString(x_d)

