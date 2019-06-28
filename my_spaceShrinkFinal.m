function c = my_spaceShrinkFinal(a, b, gcc_all, mic2, v, fs)
% Note:
%       This function is used to realize��space Shrink' to get the sound source location.
% Usage:
%       c = my_spaceShrinkFinal(a, b, gcc_all, mic2, v, fs)
% Input arguments:
%       a       : the original angle/distance range
%       b       : the original resolution
%       gcc_all : the SRP response based on GCC-PHAT (6*(frameLen*2-1))
%       mic2    : the spherical coordinates of micphone arrays (4*3)
%       v       : the speed of sound (340m/s)
%       fs      : the sampling rate (48000Hz)
% Output arguments:
%       c       : the sound source location
% For example:
%       a       = [4.6    , 8.6    ;   % r
%                  76.4251, 78.4137;   % theta
%                  39.3472, 41.3472;]  % phi
%       b       = [0.1, 0.2, 0.2];     % r/theta/phi
%       gcc_all = [xcorr12;xcorr13;xcorr14;xcorr23;xcorr24;xcorr34];
%       mic2    = [0  , 0 , 0;
%                  0.1, 0 , 0;
%                  0.1, 90, 0;
%                  0.1, 90, 90];
%       v       = 340;
%       fs      = 48000;
%       c       = [5.08, 77.9711, 39.3912]; % r/theta/phi
% ˵����
%       ����������ʵ�ֿ����������������Ҫ�Ծ�����ԣ��Ƕ�Ҳ�ʵ������ˣ�
%       ���룺ԭʼ�߽磬�ֱ���
%       ��������Ƴ�����Դλ��
%       ע�⣺���ַ�ʽ�ص��ǶԵ�ǰ�������ɨ��������Դλ��

% --------------------------------------------------------------
% ��ʼ��
frameLen = (size(gcc_all,2)+1)/2;   % ֡��
index_theta = a(2,1):b(2):a(2,2);   % ������
index_phi = a(3,1):b(3):a(3,2);     % ��λ��
index_r = a(1,1):b(1):a(1,2);       % ��
% �����������
num_r = length(index_r);            % r������С
num_theta = length(index_theta);    % theta������С
num_phi = length(index_phi);        % phi������С
num_all = num_theta*num_phi*num_r;  % ȫ��ɨ�����
srpfinal = zeros(num_all,6);        % ȫ�ִ洢����

% --------------------------------------------------------------
% ֱ�ӷ���ʽ������ά����
for kr = 2:num_r-1
    for ktheta = 2:num_theta-1
        for kphi = 2:num_phi-1
            % ��ʼ��
            index_cac = [0 0 1;
                         0 0 -1;
                         1 0 0;
                         -1 0 0;
                         0 1 0;
                         0 -1 0;
                         0 0 0];                                % �������Ƽ�Ȩ��7������
            index_cac2 = ones(7,1)*[kr,ktheta,kphi]-index_cac;  % ����7��λ�õ���������
            % ȷ���Ƿ���ɼ���
            data_temp = zeros(1,7);
            for kk = 1:7
                index_cac3 = sub2ind([num_r,num_theta,num_phi],index_cac2(kk,1),index_cac2(kk,2),index_cac2(kk,3));
                if(srpfinal(index_cac3,4)==0) % ��λ�û�н��м���
                    % ��ʼ��
                    r = index_r(index_cac2(kk,1));
                    theta = index_theta(index_cac2(kk,2));
                    phi = index_phi(index_cac2(kk,3));
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
                        index = frameLen+floor(delaycac(zz))+(-5:5); % (-3:4)
                        energy_xx_cac(zz) = my_sinc(gcc_all(zz,index),index,frameLen+delaycac(zz));
                    end 
                    % ��ɼ���
                    srpfinal(index_cac3,4) = sum(energy_xx_cac);  
                    srpfinal(index_cac3,1:3) = [index_r(index_cac2(kk,1)),index_theta(index_cac2(kk,2)),index_phi(index_cac2(kk,3))];
                end
                % ȡ��7��ֵ
                data_temp(kk) = srpfinal(index_cac3,4);
            end
            % ������Ӧ���߸���Ԫ������˼��㣬�����Ѿ�ȡ��
            index_cac4 = sub2ind([num_r,num_theta,num_phi],index_cac2(7,1),index_cac2(7,2),index_cac2(7,3));
            srpfinal(index_cac4,[1,2,3,5,6]) = [index_r(kr),index_theta(ktheta),index_phi(kphi),mean(data_temp),var(data_temp,1)]; 
        end
    end
end

% --------------------------------------------------------------
% �������������ľ���
srp_cac = srpfinal(:,4);
index_srp = mean(find(srp_cac==max(srp_cac)));             % Ѱ��srp�е����ֵ��Ϊ�ο�����1
mean_cac = srpfinal(:,5);
index_mean = mean(find(mean_cac==max(mean_cac)));          % Ѱ��mean�е����ֵ��Ϊ�ο�����2
var_cac = srpfinal(:,6);
index_var = mean(find(var_cac==min(var_cac(var_cac~=0)))); % Ѱ��var�е���Сֵ��Ϊ�ο�����3��ע��������ֵӰ��
r_output = [srpfinal(index_srp,1),srpfinal(index_mean,1),srpfinal(index_var,1)]*[0.05,0.05,0.9]'; % ���ܶ��������м�Ȩ����������

% --------------------------------------------------------------
% �������������ĽǶ�
srp_cac2 = sortrows(srpfinal,-4);
theta_output = mean(srp_cac2(1:100,2));
phi_output = mean(srp_cac2(1:100,3));

% --------------------------------------------------------------
% ������
c = [r_output,theta_output,phi_output];

end