# DAFX-AntiAliasing
Companion page to the paper "Reducing the aliasing of nonlinear waveshaping using continuous-time convolution" by Julian D. Parker, Vadim Zavalishin and Efflam Le Bivic, presented at the DAFx16 Conference in Brno, Czech Republic, 5th-9th Sept. 2016.

## code/
Contains MATLAB scripts implementing some of the results described in the paper.

__hardClipComparison.m__ - generates sine sweeps processed through hard clipper, with several anti-aliasing kernels and sampling rates.

__hardClipSNR.m__ - Calculates SNR values for the hard clipped sine sweeps.

__HardClip.m__ - Trivial hard clipping function.

__HardClip0.m__ - Antiderivative of hard clipping function.

__HardClip1.m__ - First moment of hard clipping function.

__Tanh0.m__ - Antiderivative of tanh() function.

__Tanh1.m__ - First moment of tanh() function. NOTE: Requires external implementation of dilog() function (not included here, due to licensing).

## sounds/
#### hardClip/
Sine sweeps processed through a hard clipper.
#### tanh/
Sine sweeps processed through tanh() function.
#### moogLadder/
Cutoff sweeps of ladder filter processing 5kHz sinusoidal input.
