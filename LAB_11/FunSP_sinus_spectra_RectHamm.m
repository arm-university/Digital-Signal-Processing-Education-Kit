%
% Fundamentals of Signal Processing
%
% L.EEC025             2021/2022
% U.Porto-DEEC
%
% Author: Prof. Aníbal Ferreira (AJF)
% Week 12 lab work (any other utilization requires prior written
% consent by Prof. Aníbal Ferreira)
%
%

FS=8000;
N=64; N2=N/2;
n=[0:N-1]; k=n;
npts=3000;

alfa=0.54; % Hanning: alfa=0.5  Hamming: alfa=0.54;

%
% unselect ONLY one of the following: RECTANGULAR or HAMMING window
%
window='Rect';
% window='Hamm';

switch (window)
    case ('Rect')
        selwin=rectwin(N);
    case ('Hamm')
        selwin=hamming(N);
    otherwise
        selwin=rectwin(N);
end


resolution=FS/N;

for freq=500:2.5:1600
    
    OMEGA0=2*pi*freq;
    omega0=OMEGA0/FS;
    % x=sin(OMEGA0*n/FS);
    x=0.5*exp(1j*OMEGA0*n/FS);
    
    % x=sawtooth(2*pi*freq*n/FS);
    % x=square(2*pi*freq*n/FS);

    % reference (i.e. "non-sampled") spectrum (half part only)
    w=[0:npts-1]/npts-omega0/pi;
    
    switch (window)
    case ('Rect')
        H=N/2*abs(sinc(w*N/2)./sinc(w/2));
    case ('Hamm')
        H=N/2*(abs(alfa*sinc(w*N/2)./sinc(w/2)+...
            (1-alfa)/2*sinc((w-2/(N-1))*N/2)./sinc((w-2/(N-1))/2)+...
            (1-alfa)/2*sinc((w+2/(N-1))*N/2)./sinc((w+2/(N-1))/2)));
    otherwise
        H=N/2*abs(sinc(w*N/2)./sinc(w/2));
    end

    % compute spectrum
    X=fft(x.*selwin.');
    MAG=abs(X);
    

    subplot(1,2,1);
    plot(n/FS*1000,x)
    axis([0 N/FS*1000 -1.2 1.2]);
    title('Sinusoid');
    xlabel('Time (ms)');
    ylabel('Amplitude');
    
    subplot(1,2,2);
    stem([0:N2-1]*FS/N/1000, MAG(1:N2),'filled');
    switch (window)
    case ('Rect')
        axis([-0.1 N2*FS/N/1000 0 35]), title('Spectrum analysis (Rect)');
    case ('Hamm')
        axis([-0.1 N2*FS/N/1000 0 20]); title('Spectrum analysis (Hamm)');
    otherwise
        axis([-0.1 N2*FS/N/1000 0 35]); title('Spectrum analysis (Rect)');
    end
    xlabel('Frequency (kHz)');
    ylabel('|H[k]|');
    hold on
    plot(FS*[0:npts-1]/npts/2/1000,H,'m')
    hold off
    
    pause;
end



