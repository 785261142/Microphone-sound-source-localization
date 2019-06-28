function y = my_gcc_phat(x1, x2)
% Note:
%       This function is used to calculate the GCC-PHAT function.
% Usage:
%       y = my_gcc_phat(x1, x2)
% Input arguments:
%       x1 : the input signal of first channel (1*N)
%       x2 : the input signal of second channel (1*N)
% Output arguments:
%       y  : the GCC-PHAT function (1*(2*N-1))
% For example:
%       x1 = randn(1,2000);
%       x2 = delayseq(x1, 5e-3, 8000); % ��x1����ƽ��5ms��������Ϊ8kHz
%       y  = %%%;
% ˵����
%       ����������ʵ����·�źŵ�GCC-PHAT�ļ���
%       ���룺��·����ʱ�ӹ�ϵ���źţ�Ҫ�����źŵȳ���
%       �����GCC-PHAT

% --------------------------------------------------------------
% ��ʼ��
Ncorr = 2*length(x1)-1;   % ���Ի���س���
NFFT = 2^nextpow2(Ncorr); % ����FFT����

% --------------------------------------------------------------
% ����GCC-PAHT
Gss = fft(x1, NFFT).*conj(fft(x2, NFFT));                 % ���㻥������
% xcorr_cac = fftshift(ifft(Gss));
xcorr_cac = fftshift(ifft(exp(1i*angle(Gss))));           % ֱ��GCC-PHAT
y = xcorr_cac(NFFT/2+1-(Ncorr-1)/2:NFFT/2+1+(Ncorr-1)/2); % ȷ������

end