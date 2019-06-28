function c = my_spaceShrinkAngle(a, b, gcc_all, mic2, v, fs)
% Note:
%       This function is used to realize��space Shrink' from angle.
% Usage:
%       c = my_spaceShrinkAngle(a, b, gcc_all, mic2, v, fs)
% Input arguments:
%       a       : the original angle/distance range
%       b       : the original resolution
%       gcc_all : the SRP response based on GCC-PHAT (6*(frameLen*2-1))
%       mic2    : the spherical coordinates of micphone arrays (4*3)
%       v       : the speed of sound (340m/s)
%       fs      : the sampling rate (48000Hz)
% Output arguments:
%       c       : the angle angle/distance after shrinking (it size relates to b)
% For example:
%       a       = [0.1, 10.1;  % r
%                  60 , 90  ;  % theta
%                  0,   90;]   % phi
%       b       = [1, 10, 10]; % r/theta/phi
%       gcc_all = [xcorr12;xcorr13;xcorr14;xcorr23;xcorr24;xcorr34];
%       mic2    = [0  , 0 , 0;
%                  0.1, 0 , 0;
%                  0.1, 90, 0;
%                  0.1, 90, 90];
%       v       = 340;
%       fs      = 48000;
%       c       = [0.1, 10.1;  % r
%                  30 ,   50;  % theta
%                  70 ,   90]; % phi
% ˵����
%       ����������ʵ�ֿ�����������������ԽǶȶ��ԣ������Ǽ�����
%       ���룺ԭʼ�߽磬�ֱ���
%       ����������߽�
%       ע�⣺���ַ�ʽֻ�ǶԽǶȽ�������

% --------------------------------------------------------------
% ��ʼ��
frameLen = (size(gcc_all,2)+1)/2; % ֡��
index_theta = a(2,1):b(2):a(2,2); % ����������
index_phi = a(3,1):b(3):a(3,2);   % ��λ������
index_r = a(1,1):b(1):a(1,2);     % ������
% ��������ľ���
srpangle = zeros(length(index_theta)*length(index_phi),3);  % ȫ�ֻ�������ԽǶȸ���Ϊ�У�
number_srpangle = 0;                                        % �������洢����

% --------------------------------------------------------------
% ��������ѭ��
for theta = index_theta     % ������
    for phi = index_phi     % ��λ��    
        response_cac = 0;   % ��������ÿ�������ϵĻ������
        for r = index_r     % ��
            % �������
            distance1 = my_distancediff([r,theta,phi],mic2(1,:)); % Ŀ�굽1����˷����
            distance2 = my_distancediff([r,theta,phi],mic2(2,:)); % Ŀ�굽2����˷����
            distance3 = my_distancediff([r,theta,phi],mic2(3,:)); % Ŀ�굽3����˷����
            distance4 = my_distancediff([r,theta,phi],mic2(4,:)); % Ŀ�굽4����˷����           
            % ����ʱ�ӵ�������
            delaycac = [2*(distance1-distance2)/v*fs;
                        2*(distance1-distance3)/v*fs;
                        2*(distance1-distance4)/v*fs;
                        2*(distance2-distance3)/v*fs;
                        2*(distance2-distance4)/v*fs;
                        2*(distance3-distance4)/v*fs
                       ];            
            % ����sinc��Ȩ����SRP
            energy_xx_cac = zeros(1,6);
            for zz = 1:6
                index = frameLen+floor(delaycac(zz))+(-3:4);
                energy_xx_cac(zz) = my_sinc(gcc_all(zz,index),index,frameLen+delaycac(zz));
            end
            energysum = sum(energy_xx_cac);
            % �洢�÷����10��SRP����Ӧ��
            response_cac = response_cac+energysum;
        end
        % ���д洢
        number_srpangle = number_srpangle+1;
        srpangle(number_srpangle,:) = [theta,phi,response_cac];
    end
end

% --------------------------------------------------------------
% ����������Ľ��
srpangle = sortrows(srpangle,3); % ����SRP����
number_cac = size(srpangle,1);   % ����
number = round(number_cac*0.1);  % ��ȡǰ10%���м�Ȩ
% weight_cac = srpangle(end-number:end,3)/sum(srpangle(end-number:end,3));
% ��һ��Ȩ�ط�ʽ�����ֵ0.5Ȩ�أ�ʣ�µ�0.5�ٷ���������ǰ10%������ֵ����ϵ����Ȩ��
weight_cac = [srpangle(end-number:end-1,3)/sum(srpangle(end-number:end-1,3))*0.5;0.5]; % ��ȡȨ������
theta_ave = sum(srpangle((end-number):end,1).*weight_cac);                             % ��Ȩ���theta
phi_ave = sum(srpangle((end-number):end,2).*weight_cac);                               % ��Ȩ���phi

% --------------------------------------------------------------
% ���
c = [a(1,1),a(1,2);                   % r
     theta_ave-b(2),theta_ave+b(2);   % theta
     phi_ave-b(3),phi_ave+b(3)];      % phi

end