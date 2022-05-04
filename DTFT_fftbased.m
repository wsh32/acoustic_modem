function [X, O] = DTFT_fftbased(x)
    % plots the magnitude of the Fourier transform of the signal x
    % which is assumed to originate from a Continous-time signal 
    % sampled with frequency fs
    % the function returns X and f.
    % In other words, this function plots the FT of the DT signal x
    % with the frequency axis labeled as if it were the original CT signal
    % 
    % X contains the frequency response
    % O contains the frequency samples 

    N = length(x);

    X = fftshift(fft(x));
    O = linspace(-pi, pi - 2*pi/length(x), length(x));
    subplot(211);
    plot(O, abs(X));
    xlabel('\Omega');
    ylabel('|X(j\Omega)|');
    subplot(212);
    plot(O, unwrap(angle(X)));
    xlabel('\Omega');
    ylabel('\angle X(j\Omega)');
    
end
