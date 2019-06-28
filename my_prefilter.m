function y = prefilter(x, lowfre, highfre, fs)
% Note:
%       This function is used to do the 'prefilter', a bandpass filter.
% Usage:
%       y = prefilter(x, lowfre, highfre, fs)
% Input arguments:
%       x       : the input signal (1*N)
%       lowfre  : the lower frequency
%       highfre : the high frequency
%       fs      : the sampling frequency
% Output arguments:
%       y       : the output signal
% For example:
%       x       = randn(1,2000);
%       lowfre  = 50;
%       highfre = 3400;
%       fs      = 48000;
%       y       = %%%;
% ˵����
%       ����������ʵ��Ԥ�˲�����ͨ�˲���
%       ���룺ԭʼ�źţ���Ƶ���ޣ���Ƶ���ޣ�������
%       ������˲����ź�

% --------------------------------------------------------------
% ��ƴ�ͨ�˲���
filterd=fdesign.highpass('N,Fc',50,lowfre,fs);  % 50�׵ĸ�ͨ�˲���
filterd2=fdesign.lowpass('N,Fc',50,highfre,fs); % 50�׵ĵ�ͨ�˲���
Hd=design(filterd);
Hd2=design(filterd2);

% --------------------------------------------------------------
% �����˲�
y = filter(Hd,x);  % ��ͨ�˲�
y = filter(Hd2,x); % ��ͨ�˲�    

end