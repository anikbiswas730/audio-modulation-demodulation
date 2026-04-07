clc
clear all 
close all

N = 100;
x = randn(1,N);
[Rxx,lags] = xcorr(x,'unbiased');
plot(lags,Rxx)
xlabel('Lag')
ylabel('Autocorrelation')
title('Autocorrelation of a Random Signal')