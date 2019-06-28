function c = my_spaceShrinkDistance(a, b, gcc_all, mic2, v, fs)
% Note:
%       This function is used to realize��space Shrink' from distance.
% Usage:
%       c = my_spaceShrinkDistance(a, b, gcc_all, mic2, v, fs)
% Input arguments:
%       a       : the original angle/distance range
%       b       : the original resolution
%       gcc_all : the SRP response based on GCC-PHAT (6*(frameLen*2-1))
%       mic2    : the spherical coordinates of micphone arrays (4*3)
%       v       : the speed of sound (340m/s)
%       fs      : the sampling rate (48000Hz)
% Output arguments:
%       c       : the angle/distance range after shrinking (it size relates to b)
% For example:
%       a       = [0.1    , 10.1   ;   % r
%                  76.4251, 84.4251;   % theta
%                  38.0377, 42.0377;]  % phi
%       b       = [0.5, 0.2, 0.2];     % r/theta/phi
%       gcc_all = [xcorr12;xcorr13;xcorr14;xcorr23;xcorr24;xcorr34];
%       mic2    = [0  , 0 , 0;
%                  0.1, 0 , 0;
%                  0.1, 90, 0;
%                  0.1, 90, 90];
%       v       = 340;
%       fs      = 48000;
%       c       = [4.6    , 8.6    ;   % r
%                  76.4251, 78.4137;   % theta
%                  39.3472, 41.3472];  % phi
% ˵����
%       ����������ʵ�ֿ����������������Ҫ�Ծ�����ԣ��Ƕ�Ҳ�ʵ������ˣ�
%       ���룺ԭʼ�߽磬�ֱ���
%       ����������߽�
%       ע�⣺���ַ�ʽ�ص��ǶԼ��������������

% --------------------------------------------------------------
% ��ʼ��
frameLen = (size(gcc_all,2)+1)/2;  % ֡��
index_theta = a(2,1):b(2):a(2,2);  % ������
index_phi = a(3,1):b(3):a(3,2);    % ��λ��
index_r = a(1,1):b(1):a(1,2);      % ��
% �����������
num_r = length(index_r);           % r������С
num_theta = length(index_theta);   % theta������С
num_phi = length(index_phi);       % phi������С
num_row = num_theta*num_phi;       % �Ƕ�������С
number_srpdistance = 0;            % ���ڻ���Ŀ��Ʊ���
% ������
srpdistance = zeros(num_r+4,num_row+2);

% --------------------------------------------------------------
% ��������ѭ��
for r = index_r             % ��
    n1 = 0;
    for theta = index_theta % ������
        n1 = n1+1;
        n2 = 0;
        for phi = index_phi % ��λ��  
             n2 = n2+1;
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
                index = frameLen+floor(delaycac(zz))+(-5:5); % �ı�������Կ���sinc��Ȩ�㷶Χ(-3:4)
                energy_xx_cac(zz) = my_sinc(gcc_all(zz,index),index,frameLen+delaycac(zz));
            end
            energysum = sum(energy_xx_cac);            
            % ��ÿһ���������ɾ�����������Ӧ����
            srpdistance(number_srpdistance+1,num_theta*(n1-1)+n2) = energysum; % ������
        end
    end
    % ���д洢
    srpdistance_cac = srpdistance(number_srpdistance+1,:);
    srpdistance(number_srpdistance+1,num_row+1:num_row+2) = [mean(srpdistance_cac),var(srpdistance_cac,1)];
    number_srpdistance = number_srpdistance+1;
end

% --------------------------------------------------------------
% ��������
srpdistance2 = [[index_r';zeros(4,1)],srpdistance];                                  % ����뼫��
for kk = 2:size(srpdistance2,2)
    if(kk<=size(srpdistance2,2)-2)
        srpdistance2(num_r+1,kk) = index_theta(ceil((kk-1)/num_phi));                % ���theta
        srpdistance2(num_r+2,kk) = index_phi(kk-1-(ceil((kk-1)/num_phi)-1)*num_phi); % ���phi
    end
    max_cac = srpdistance2(1:num_r,kk);
    srpdistance2(num_r+3,kk) = max(max_cac);                         % Ѱ�����ֵ
    srpdistance2(num_r+4,kk) = index_r(find(max_cac==max(max_cac))); % Ѱ�����ֵ�����ھ���
end

% --------------------------------------------------------------
% ��������
distance_temp = [];
for kk = 2:size(srpdistance2,2)-2 % ��ʱ��Ҫ�������Ӧ�ü�����Сֵ�����������⣩
    if(srpdistance2(end,kk)~=max(index_r))
        distance_temp = [distance_temp;srpdistance2(end:-1:end-4,kk)'];
    end
end
% �������ͽǶ��ϵ�����
% ����ط������⣬������SRP�����ֵ����������
% ���Բο��Ƚ���һ�����ߵ�
distance_temp2 = sortrows(distance_temp,-5);      % ���ű�ʾ����
distace_center = distance_temp2(1:3,1)'*[1,0,0]'; % ��ǰ������ֵ���м�Ȩ[0.5 0.3 0.2]���������ֵ
theta_center = mean(distance_temp2(:,4));         % �������theta�������ֵ
phi_center = mean(distance_temp2(:,3));           % �������phi�������ֵ

% --------------------------------------------------------------
% ������
c = [max(distace_center-2,0),min(distace_center+2,10.1);
     max(theta_center-1,a(2,1)),min(theta_center+1,a(2,2));
     max(phi_center-1,a(3,1)),min(phi_center+1,a(3,2))];

end