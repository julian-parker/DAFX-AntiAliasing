%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Antialiased hard clipper SNR comparison
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reference output at very high sample rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OS = 256;
Fs = 44100*OS;
T = 10;
t = 0:1/Fs:T;
gain = 10;


input = gain * sin (2 * pi * t .* (t/T) * 22000/2);

reference = zeros(1, length(input));
for (i = 3:length(input))
    reference(i) = HardClip(input(i));
end

reference = resample(reference,1,OS,512);
NFFT1 = 1024;
win1 = blackman(NFFT1);
hop1 = 8;
[Bref,Fref,Tref] = spectrogram(reference,win1,NFFT1-hop1,NFFT1,Fs/OS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Trivial hard clipping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OS = 12;
Fs = 44100*OS;
t = 0:1/Fs:T;

input = gain * sin (2 * pi * t .* (t/T) * 22000/2);

trivial = zeros(1, length(input));
for (i = 3:length(input))
    trivial(i) = HardClip(input(i));
end

trivial = resample(trivial,1,OS,512);
[Btrivial,Ftrivial,Ttrivial] = spectrogram(trivial,win1,NFFT1-hop1,NFFT1,Fs/OS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Antialiased hard clipping with rectangual kernel
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
[B0,F0,T0] = spectrogram(output0,win1,NFFT1-hop1,NFFT1,Fs/OS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Antialiased hard clipping with linear kernel
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
        output1(i) = (HardClip1(input(i)) - HardClip1(input(i-1)) - input(i) * (HardClip0(input(i)) - HardClip0(input(i-1))))/(diff1*diff1);
    end
    if (abs(diff2) < 0.0000001)
        output1(i) = output1(i) + 0.5*HardClip(input(i-2));
    else
        output1(i) = output1(i) - (HardClip1(input(i-1)) - HardClip1(input(i-2)) - input(i-2) * (HardClip0(input(i-1)) - HardClip0(input(i-2))))/(diff2*diff2);
    end
end

output1 = resample(output1,1,OS,512);
[B1,F1,T1] = spectrogram(output1,win1,NFFT1-hop1,NFFT1,Fs/OS);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comparison
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = db(abs(Bref)) > -30; % Calculate mask to identify 'signal' from reference output

%% Compare power inside and outside the mask for the three approaches
snrTrivial = db(sum(abs(Btrivial(mask)).^2) / sum(abs(Btrivial(not(mask))).^2),'power')
snr0 = db(sum(abs(B0(mask)).^2) / sum(abs(B0(not(mask))).^2),'power')
snr1 = db(sum(abs(B1(mask)).^2) / sum(abs(B1(not(mask))).^2),'power')


