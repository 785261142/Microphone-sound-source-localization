function y = my_srp_phat(gcc_all, obj, mic, v, fs)
% Note:
%       This function is used to calculate the SRP of one point.
% Usage:
%       y = my_srp_phat(gcc_all, obj, mic, v, fs)
% Input arguments:
%       gcc_all : the SRP response based on GCC-PHAT (6*(frameLen*2-1))
%       obj     : the cartesian coordinates of one point [x,y,z]
%       mic     : the cartesian coordinates of micphone arrays (4*3)
%       v       : the speed of sound (340m/s)
%       fs      : the sampling rate (48000Hz)
% Output arguments:
%       y       : the SRP of the 'obj' point
% For example:
%       gcc_all = [xcorr12;xcorr13;xcorr14;xcorr23;xcorr24;xcorr34];
%       obj     = [6,5,1.6];
%       mic     = [0  , 0 , 0  ;
%                  0  , 0 , 0.1;
%                  0.1, 0 , 0  ;
%                  0  , 0 , 0.1];
%       t = 7.5;
%       y = 0.8960;
% ˵����
%       ��������������ĳһ���SRP��Ӧ���ݶ�Ϊֱ������
%       ���룺GCC-PHAT����Ŀ���λ�ã���˷�λ�ã����٣�������
%       �����srp��Ӧ

% --------------------------------------------------------------
% ��ʼ��
frameLen = (size(gcc_all,2)+1)/2;       

% --------------------------------------------------------------
% ��������
discac = abs(obj-mic(1,:));
distance1 = sqrt(sum(discac.^2)); % Ŀ�굽1����˷����
discac = abs(obj-mic(2,:));
distance2 = sqrt(sum(discac.^2)); % Ŀ�굽2����˷����
discac = abs(obj-mic(3,:));
distance3 = sqrt(sum(discac.^2)); % Ŀ�굽3����˷����
discac = abs(obj-mic(4,:));
distance4 = sqrt(sum(discac.^2)); % Ŀ�굽4����˷���� 

% --------------------------------------------------------------
% ����ʱ�ӵ�������
delaycac = [2*(distance1-distance2)/v*fs;
            2*(distance1-distance3)/v*fs;
            2*(distance1-distance4)/v*fs;
            2*(distance2-distance3)/v*fs;
            2*(distance2-distance4)/v*fs;
            2*(distance3-distance4)/v*fs];
       
% --------------------------------------------------------------
% ����sinc��Ȩ����SRP
energy_xx_cac = zeros(1,6);
for zz = 1:6
    index = frameLen+floor(delaycac(zz))+(-3:4);
    energy_xx_cac(zz) = my_sinc(gcc_all(zz,index),index,frameLen+delaycac(zz));
end

% --------------------------------------------------------------
% ���
y = sum(energy_xx_cac);
            
end