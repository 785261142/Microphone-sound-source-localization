function y = my_srp_phat_spaceShrink_method(gcc_all, mic2, v, fs)
% Note:
%       This function is used to realize sound source location by 
%       'space Shrink method'.
% Usage:
%       y = my_srp_phat_spaceShrink_method(gcc_all, mic2, v, fs)
% Input arguments:
%       gcc_all : the SRP response based on GCC-PHAT (6*(frameLen*2-1))
%       mic2    : the spherical coordinates of micphone arrays (4*3)
%       v       : the speed of sound (340m/s)
%       fs      : the sampling rate (48000Hz)
% Output arguments:
%       y       : the spherical coordinates of the sound source
% For example:
%       gcc_all = [xcorr12;xcorr13;xcorr14;xcorr23;xcorr24;xcorr34];
%       mic2    = [0  , 0 , 0;
%                  0.1, 0 , 0;
%                  0.1, 90, 0;
%                  0.1, 90, 90];
%       v       = 340;
%       fs      = 48000;
%       y       = [5.0800, 77.9711, 39.3912];
% ˵����
%       ����������ʵ����Դ��λ���������¿�����������
%       ���룺GCC-PHAT������˷�λ�ã������꣩�����٣�������
%       �������Դλ�ã������꣩
%       ע�⣺��Ҫ˼����ͨ��ͳ�ƹ��ɲ�������ԭʼ��������Դ�ռ�

% --------------------------------------------------------------
% ��һ������������Ƕ�����Ϊ20�ȣ�
a1 = [0.1,10.1;60,90;0,90]; % ��ʼ������Χ
b1 = [1,10,10];
a2 = my_spaceShrinkAngle(a1, b1, gcc_all, mic2, v, fs);

% --------------------------------------------------------------
% �ڶ�������������Ƕ�����Ϊ4�ȣ�
b2 = [1,2,2];
a3 = my_spaceShrinkAngle(a2, b2, gcc_all, mic2, v, fs);

% --------------------------------------------------------------
% ����������������Ƕ�����Ϊ3�ȣ�����Ϊ3�ף�
b3 = [0.5,0.2,0.2];
a4 = my_spaceShrinkDistance(a3, b3, gcc_all, mic2, v, fs);
% ���Կ���������ƵĲ��Ǻ�׼
% ���µü����Ľ��㷨

% --------------------------------------------------------------
% ���Ĵ�������ֱ��������Ƴ�����Դλ�ã� 
% b4 = [0.05,0.08,0.08];
b4 = [0.1,0.2,0.2];
a5 = my_spaceShrinkFinal(a4, b4, gcc_all, mic2, v, fs);

% --------------------------------------------------------------
% ������ 
y = a5;
% y = my_rthetaToXYZ(a5(1),a5(2),a5(3)); % ��������ת��

end