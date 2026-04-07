🎙️ Modulation and Demodulation of Audio Signal
> **EEE 212 — Numerical Technique Laboratory | Project 06**  
> Bangladesh University of Engineering and Technology (BUET)  
> Department of Electrical and Electronic Engineering  
---
📋 Overview
This project implements a complete audio modulation–demodulation pipeline inside a MATLAB App Designer graphical interface. The application supports both Amplitude Modulation (AM) and Frequency Modulation (FM), corrupts the modulated signal with Additive White Gaussian Noise (AWGN) at a user-controlled SNR level, then demodulates and recovers the original audio — displaying time-domain and frequency-domain plots at every stage of the signal chain.
---
🔧 Features
Feature	Description
🎤 Record	Capture live microphone audio at 10 kHz, 16-bit mono
📂 Browse	Import any `.mp3` audio file
📻 AM Modulation	Double-sideband full-carrier AM with configurable carrier amplitude
📡 FM Modulation	Wideband FM using MATLAB's `fmmod` / `fmdemod`
🔊 Noise Addition	AWGN injection via a 0–100 dB SNR knob
🔁 Demodulation	Envelope detection (AM) or frequency discriminator (FM)
📊 Visualisation	4×2 subplot figures — time & frequency domain for all four signal stages
▶️ Playback	Listen to the signal at any stage: input, modulated, noisy, demodulated
---
🧮 Theory
Amplitude Modulation (AM)
The AM signal is formed by multiplying the message signal with a carrier:
```
s_AM(t) = [A_c + m(t)] · cos(2π · f_c · t)
```
Carrier frequency: f_c = 4 kHz (4200 Hz for AM)
Sampling frequency: F_s = 10 kHz
A 3rd-order Butterworth band-pass filter (1–4 kHz) is applied before modulation to restrict message bandwidth
AM Demodulation (Envelope Detection):
```
y(t) = LPF{ 2 · r_BPF(t) · cos(2π·f_c·t) }
```
A 2nd-order Butterworth LPF with cut-off f_c/F_s removes the double-frequency term.
---
Frequency Modulation (FM)
FM encodes the message in the instantaneous frequency deviation of the carrier:
```
s_FM(t) = A_c · cos[ 2π·f_c·t + 2π·f_Δ · ∫m(τ)dτ ]
```
Frequency deviation: f_Δ = F_c/2 = 2 kHz
RF bandwidth (Carson's rule): B_T ≈ 2(f_Δ + W) Hz
MATLAB built-ins `fmmod` / `fmdemod` are used
FM is inherently more noise-resistant than AM because noise principally affects amplitude rather than frequency.
---
AWGN Channel
```
SNR_dB = 10 · log₁₀(P_signal / P_noise)
```
MATLAB's `awgn(signal, SNR)` adds noise calibrated to the specified SNR relative to signal power. The knob widget allows SNR variation from 0 to 100 dB.
---
Spectrum Analysis (FFT)
```
|X(f)| = |fftshift(fft(x, N))|,   f ∈ [−F_s/2, F_s/2)
```
---
🗂️ Repository Structure
```
audio-modulation-demodulation/
│
├── app/
│   ├── project_06.mlapp           # MATLAB App Designer source file
│   └── Project-06.mlappinstall    # Packaged app installer
│
├── scripts/
│   └── autocorrelation_demo.m     # Standalone script: autocorrelation of random signal
│
├── docs/
│   └── EEE212_Project06_Report.pdf  # Full project report
│
├── results/
│   └── README.md                  # Placeholder — add your output screenshots here
│
├── .gitignore
└── README.md
```
---
🚀 Getting Started
Requirements
MATLAB R2020b or later (App Designer support)
Signal Processing Toolbox
Audio System Toolbox (for microphone recording)
Running the App
Option A — Open source in App Designer:
```matlab
% In MATLAB Command Window:
open('app/project_06.mlapp')
```
Then click Run in the App Designer toolbar.
Option B — Install the packaged app:
Double-click `app/Project-06.mlappinstall` in MATLAB's Current Folder browser, or
In MATLAB: Apps → Install App → browse to `Project-06.mlappinstall`
The app will appear in your MATLAB Apps gallery.
---
🖥️ App User Guide
Step 1 — Input Audio
Enter a recording duration (seconds) and press Record, or
Press Browse to select an `.mp3` file
Press Play to verify the input signal.
Step 2 — Modulate
Select AM mod or FM mod from the dropdown
For AM: set the Amplitude of the carrier frequency (A_c)
Press Modulate → Press Play to hear the modulated signal
Step 3 — Add Noise
Turn the Knob to the desired SNR level (0 = maximum noise, 100 = nearly noiseless)
The SNR value is shown in the Noise field
Press Add Noise → Press Play
Step 4 — Demodulate
Press Demodulate → Press Play to hear the recovered audio
Step 5 — Visualise
Time Domain Graphs — 4×2 subplot of time-domain waveforms
Frequency Domain Graphs — 4×2 subplot of magnitude spectra
Reset — clears all stored signals and resets the app state
---
📊 Global Variables
Variable	Default	Description
`x`	—	Input audio signal (column vector)
`Fs`	10 000 Hz	Sampling frequency
`Fc`	4 000 Hz	Carrier frequency
`A`	—	Carrier amplitude (AM only)
`fDev`	Fc/2	Frequency deviation (FM only)
`Am_Fm`	0	Flag: 1 = AM, 2 = FM
`rec_brow`	0	Flag: 0 = recorded, 1 = browsed
`noise`	0	SNR level in dB for AWGN
`Modulated_final`	—	Modulated signal (AM or FM)
`noisy_signal`	—	Modulated signal + AWGN
`Demodulated_final`	—	Recovered audio signal
`t`	—	Time axis vector
`f`	—	Frequency axis vector
`x_shift`	—	FFT magnitude of input
`Modulated_shift`	—	FFT magnitude of modulated signal
`noisy_shift`	—	FFT magnitude of noisy signal
`Demodulated_shift`	—	FFT magnitude of demodulated signal
---
📈 Sample Results
Test	Mode	A_c	SNR	Notes
Figure 2	AM	10	93 dB	MP3 input, ~30 s clip — near-noiseless
Figure 3	AM	18	21 dB	Increased noise floor clearly visible
Figure 4	AM	15	98 dB	Near-noiseless demodulation
Figure 5	FM	—	80 dB	3-second recording, MP3 input
Figure 6	AM	10	97 dB	3-second live voice recording
Figure 7	FM	—	79 dB	Same 3-second live voice recording
See the full report in `docs/EEE212_Project06_Report.pdf` for all screenshots.
---
📁 Standalone Scripts
`scripts/autocorrelation_demo.m`
A quick demo that generates a 100-sample white Gaussian noise sequence and plots its unbiased autocorrelation:
```matlab
N = 100;
x = randn(1, N);
[Rxx, lags] = xcorr(x, 'unbiased');
plot(lags, Rxx)
xlabel('Lag')
ylabel('Autocorrelation')
title('Autocorrelation of a Random Signal')
```
Run directly from the MATLAB command window — no toolboxes required.
---
📝 Report
The full technical report is available at `docs/EEE212_Project06_Report.pdf`. It covers:
Introduction & objectives
Theoretical background (AM, FM, AWGN, FFT)
System design & architecture
Implementation details with code excerpts
Results & discussion
Conclusion
---
👤 Author
Field	Detail
Name	Anik Biswas
Student ID	1906125
Level / Term	Level-2, Term-1
Department	Electrical and Electronic Engineering (EEE)
Institution	BUET
Submission Date	22 February 2022
Course	EEE 212 — Numerical Technique Laboratory, Section B2
---
📄 License
This project was submitted as academic coursework at BUET. All rights reserved by the author.
