%% FUNCTIONS
function [X, w] = plot_ft_rad(x, fs)
    % Plots the magnitude of the Fourier transform of the signal x
    % that is assumed to originate from a Continous-time signal 
    % sampled with frequency fs.
    % The function returns X and f.
    % In other words, this function plots the FT of the DT signal x
    % with the frequency axis labeled as if it were the original CT signal.
    % 
    % X contains the frequency response
    % w contains the frequency samples


    N = length(x);

    X = fftshift(fft(x));
    
    % Note that the frequency range here is from -fs/2*2*pi until something
    % just a bit less than fs/2*2*pi.
    % This is an artifact of the fact that we're actually computing a 
    % Discrete-Fourier-Transform (DFT) when we call FFT (which is a
    % numerical method to efficiently compute the DFT).
    
    w = linspace(-fs/2*2*pi, 2*pi*fs/2- 2*pi*fs/length(x), length(x));
    plot(w, abs(X));
    xlabel('Frequency (rad/s)');
    ylabel('|X(j\omega)|');
end