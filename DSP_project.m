[y1, fs]=audioread('01.wav');
[y2, fs]=audioread('01.wav');
y1(:,2)=[];%左音道
y2(:,1)=[];%右音道

Fpass1 = 1;    % First Passband Frequency
Fstop1_1 = 250;    % First Stopband Frequency
Fstop1_2 = 350;    
Fstop2 = 400;   % Second Stopband Frequency
Fpass2 = 10000;   % Second Passband Frequency
Apass1 = 1;     % First Passband Ripple (dB)
Astop  = 60;    % Stopband Attenuation (dB)
Apass2 = 1;     % Second Passband Ripple (dB)
Fs     = 44100;  % Sampling Frequency

h1 = fdesign.bandstop('fp1,fst1,fst2,fp2,ap1,ast,ap2', Fpass1, Fstop1_1, ...
    Fstop2, Fpass2, Apass1, Astop, Apass2, Fs);
h2 = fdesign.bandstop('fp1,fst1,fst2,fp2,ap1,ast,ap2', Fpass1, Fstop1_2, ...
    Fstop2, Fpass2, Apass1, Astop, Apass2, Fs);

Hd1 = design(h1, 'equiripple');
Hd2 = design(h2, 'equiripple');

Bandstop1=filter(Hd1,y1);
Bandstop2=filter(Hd2,y2);

y=Bandstop1+Bandstop2;

n=length(y);   
time=(1:length(y))/fs;	
BandstopNew=fft(y,n);
figure(1);
subplot(2,1,1)
plot(time,y);
xlabel('時間');
ylabel('幅度');
grid on;
subplot(2,1,2)
plot(abs(fftshift(BandstopNew)));
xlabel('頻率');
ylabel('幅度');
grid on;

audioFile='DSP_projectmusic.wav';
audiowrite(audioFile,y,fs)
