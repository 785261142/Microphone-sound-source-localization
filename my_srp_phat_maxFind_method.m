function y = my_srp_phat_maxFind_method(gcc_all, mic, v, fs)
% Note:
%       This function is used to realize sound source location by looking 
%       for the point with the max SRP response.
% Usage:
%       y = my_srp_phat_maxFind_method(gcc_all, mic, v, fs)
% Input arguments:
%       gcc_all : the SRP response based on GCC-PHAT (6*(frameLen*2-1))
%       mic     : the cartesian coordinates of micphone arrays (4*3)
%       v       : the speed of sound (340m/s)
%       fs      : the sampling rate (48000Hz)
% Output arguments:
%       y       : the cartesian coordinates of the sound source
% For example:
%       gcc_all = [xcorr12;xcorr13;xcorr14;xcorr23;xcorr24;xcorr34];
%       mic     = [0  , 0  , 0  ;
%                  0  , 0  , 0.1;
%                  0.1, 0  , 0  ;
%                  0  , 0.1, 0  ];
%       v       = 340;
%       fs      = 48000;
%       y       = [7.8000, 6.7000, 1.9000];
% ˵����
%       ����������ʵ����Դ��λ��ֱ������Ѱ�����ֵ����
%       ���룺GCC-PHAT������˷�λ�ã�ֱ�����꣩�����٣�������
%       �������Դλ�ã�ֱ�����꣩
%       ע�⣺������Ҫʹ��ֱ����������+SRP-PHAT������ֱ���������ֵ�ķ���

% --------------------------------------------------------------
% ������ʼ��
xmax = 8;           % xά�������߽�
ymax = 8;           % yά�������߽�
zmax = 2;           % zά�������߽�
dr = 0.12;          % ÿ��ά���������� ������ط��������Ϊ0.1m�������׼����Ϊɨ�赽����ʵֵ��
energycac = 0;      % �����о�����ֵ
frameLen = (size(gcc_all,2)+1)/2; % ֡������������SRP��

% --------------------------------------------------------------
% ��������ѭ��
for kx = 0:dr:xmax
    for ky = 0:dr:ymax
        for kz = 0:dr:zmax
            
            obj = [kx,ky,kz]; % Ŀ��λ��
            
            % ���������Դ��4����˷�ľ��룩
            discac = abs(obj-mic(1,:));
            distance1 = sqrt(sum(discac.^2)); % Ŀ�굽1����˷����
            discac = abs(obj-mic(2,:));
            distance2 = sqrt(sum(discac.^2)); % Ŀ�굽2����˷����
            discac = abs(obj-mic(3,:));
            distance3 = sqrt(sum(discac.^2)); % Ŀ�굽3����˷����
            discac = abs(obj-mic(4,:));
            distance4 = sqrt(sum(discac.^2)); % Ŀ�굽4����˷���� 
            
            % ����ʱ�ӵ�������
            delaycac = [2*(distance1-distance2)/v*fs;
                        2*(distance1-distance3)/v*fs;
                        2*(distance1-distance4)/v*fs;
                        2*(distance2-distance3)/v*fs;
                        2*(distance2-distance4)/v*fs;
                        2*(distance3-distance4)/v*fs];
            
            % ����sinc��ֵ��Ȩ����SRP
            energy_xx_cac = zeros(1,6);
            for zz = 1:6
                index = frameLen+floor(delaycac(zz))+(-3:4);
                energy_xx_cac(zz) = my_sinc(gcc_all(zz,index),index,frameLen+delaycac(zz));
            end
            energysum = sum(energy_xx_cac);
            
            % ֱ��Ѱ�����ֵ
            if(energysum>energycac) % ����ҵ������ֵ
                energycac = energysum;
                y = obj;
            end  
            
        end
    end
end

end