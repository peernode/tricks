function ret = getsymtime(g_,BandWidth)

Ts=[];
n = 28/25
Fs=n*BandWidth

N_FFT=[128 256 512 1024 2048]

for i=1:length(N_FFT)
			Ts(i)=(1+g_)*N_FFT(i)/Fs;
			SYMps(i)=1/Ts(i);

end


ret=[Ts;SYMps];

