close all; clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Naive hard clipper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OS = 12;
Fs = 44100*OS;
T = 10;
t = 0:1/Fs:T;
gain = 10;

input = gain * sin (2 * pi * t .* (t/T) * 22000/2); % Sine sweep to 22kHz

trivial = zeros(1, length(input));
for (i = 3:length(input))
    trivial(i) = HardClip(input(i));
end
trivial = resample(trivial,1,OS,512);
audiowrite('hardclip_trivial.wav', trivial / (max(abs(trivial))),44100);

figure(1);
fontsize = 14;
fontname = 'Times';
NFFT1 = 1024;
win1 = blackman(NFFT1);
hop1 = 8;
[B1,F1,T1] = spectrogram(trivial,win1,NFFT1-hop1,NFFT1,Fs/OS);
B1 = B1./max(max(abs(B1)));  % Scale the maximum to be at 0 dB
B1small = (abs(B1)<0.0001);  % Find values smaller than -80B
B1(B1small) = 0.0001;   % Force no value to be smaller than -80 dB
imagesc(T1,F1/1000,db(B1));
axis xy
colormap(1-gray)
set(gca,'fontsize',fontsize,'fontname',fontname)
xlabel({'Time (s)'}');
ylabel('Freq. (kHz)')
dim = [.6 .175 .3 .05];
str = 'F_s = 529.2kHz, no antialiasing';
annotation('textbox',dim,'String',str,'FitBoxToText','on','fontsize',fontsize,'fontname',fontname,'BackgroundColor','white');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rectangular kernel antialiased hard clipper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OS = 4;
Fs = 44100*OS;
t = 0:1/Fs:T;

input = gain * sin (2 * pi * t .* (t/T) * 22000/2);
output0 = zeros(1, length(input));
for (i = 3:length(input))
    diff1 = (input(i) - input(i-1));
    if (abs(diff1) < 0.0000001)
        output0(i) = HardClip(input(i));
    else
        output0(i) = (HardClip0(input(i)) - HardClip0(input(i-1)))/diff1;
    end
end

output0 = resample(output0,1,OS,512);
audiowrite('hardclip_rectangular.wav', output0 / (max(abs(output0))),44100);

[B2,F2,T2] = spectrogram(output0,win1,NFFT1-hop1,NFFT1,Fs/OS);
B2 = B2./max(max(abs(B2)));  % Scale the maximum to be at 0 dB
B2small = (abs(B2)<0.0001);  % Find values smaller than -80B
B2(B2small) = 0.0001;   % Force no value to be smaller than -80 dB
figure(2);
imagesc(T2,F2/1000,db(B2));
axis xy
colormap(1-gray)
set(gca,'fontsize',fontsize,'fontname',fontname)
xlabel({'Time (s)'}');
ylabel('Freq. (kHz)')
dim = [.6 .175 .3 .05];
str = 'F_s = 176.4kHz, rect. kernel';
annotation('textbox','position',dim,'String',str,'FitBoxToText','on','fontsize',fontsize,'fontname',fontname,'BackgroundColor','white');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Linear kernel antialiased hard clipper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OS = 3;
Fs = 44100*OS;
t = 0:1/Fs:T;

input = gain * sin (2 * pi * t .* (t/T) * 22000/2);
output1 = zeros(1, length(input));
for (i = 3:length(input))
    diff1 = (input(i) - input(i-1));
    diff2 = (input(i-1) - input(i-2));
    if (abs(diff1) < 0.0000001)
        output1(i) = 0.5*HardClip(input(i));
    else
        output1(i) = -(HardClip1(input(i)) - HardClip1(input(i-1)) - input(i) * (HardClip0(input(i)) - HardClip0(input(i-1))))/(diff1*diff1);
    end
    if (abs(diff2) < 0.0000001)
        output1(i) = output1(i) + 0.5*HardClip(input(i-2));
    else
        output1(i) = output1(i) + (HardClip1(input(i-1)) - HardClip1(input(i-2)) - input(i-2) * (HardClip0(input(i-1)) - HardClip0(input(i-2))))/(diff2*diff2);
    end
end

output1 = resample(output1,1,OS,512);
audiowrite('hardclip_linear.wav', output1 / (max(abs(output1))),44100);

figure(3);
set(1, 'Color', 'w');
[B3,F3,T3] = spectrogram(output1,win1,NFFT1-hop1,NFFT1,Fs/OS);
B3 = B3./max(max(abs(B3)));  % Scale the maximum to be at 0 dB
B3small = (abs(B3)<0.0001);  % Find values smaller than -80B
B3(B3small) = 0.0001;   % Force no value to be smaller than -80 dB
imagesc(T3,F3/1000,db(B3));
axis xy
colormap(1-gray)
set(gca,'fontsize',fontsize,'fontname',fontname)
xlabel({'Time (s)'}');
ylabel('Freq. (kHz)')
dim = [.6 .175 .3 .05];
str = 'F_s = 132.3kHz, lin. kernel';
annotation('textbox','position',dim,'String',str,'FitBoxToText','on','fontsize',fontsize,'fontname',fontname,'BackgroundColor','white');
