function y = my_testSRPchange(mic2, obj, theta, phi)
% Note:
%       This function is used to test the change of SRP along a certain
%       angle.
% Usage:
%       y = my_testSRPchange(mic2, obj, theta, phi)
% Input arguments:
%       mic2    : the spherical coordinates of micphone arrays (4*3)
%       obj     : the real source location (spherical coordinates)
%       theta   : the angle of pitch
%       phi     : the azimuth angle
% Output arguments:
%       y       : the Min and index of Min SRP [index_min,min]
% For example:
%       mic2    = [0  , 0 , 0;
%                  0.1, 0 , 0;
%                  0.1, 90, 0;
%                  0.1, 90, 90];
%       obj     = [7.9725,78.4226,39.8056];
%       theta   = 78;
%       phi     = 39;
%       y       = [5.7000,0.9660];
% ˵����
%       ����������ʵ�ֶ���SRP��ĳһ�����ϵı仯���
%       ���룺��˷�����λ�ã���ʵ����Դ���꣬�����ĸ����Ǻͷ�λ��
%       �����srp��Ӧ����Сֵ���ֵ�λ�ã��Լ���Сֵ��������ͼ
%       ע�⣺������ʱ�Ӷ�Ӧ�ľ��������Ϊ�������ͼ

% --------------------------------------------------------------
% ��ʼ��
close all;
index_r = 0.1:0.1:10.1; % ��������
N = length(index_r);    % ���������
result = zeros(1,N);    % ����洢����

% --------------------------------------------------------------
% ������ʵ����
distance1_obj = my_distancediff(obj,mic2(1,:)); % Ŀ�굽1����˷����
distance2_obj = my_distancediff(obj,mic2(2,:)); % Ŀ�굽2����˷����
distance3_obj = my_distancediff(obj,mic2(3,:)); % Ŀ�굽3����˷����
distance4_obj = my_distancediff(obj,mic2(4,:)); % Ŀ�굽4����˷����  

% --------------------------------------------------------------
% ������ʵʱ�ӵ�������
delaycac_obj = [distance1_obj-distance2_obj;
                distance1_obj-distance3_obj;
                distance1_obj-distance4_obj;
                distance2_obj-distance3_obj;
                distance2_obj-distance4_obj;
                distance3_obj-distance4_obj]; 

% --------------------------------------------------------------
% ɨ��������
for kk = 1:N
    r = index_r(kk);
    % �������
    distance1 = my_distancediff([r,theta,phi],mic2(1,:)); % Ŀ�굽1����˷����
    distance2 = my_distancediff([r,theta,phi],mic2(2,:)); % Ŀ�굽2����˷����
    distance3 = my_distancediff([r,theta,phi],mic2(3,:)); % Ŀ�굽3����˷����
    distance4 = my_distancediff([r,theta,phi],mic2(4,:)); % Ŀ�굽4����˷����           
    % ����ʱ�ӵ�������
    delaycac = [distance1-distance2;
                distance1-distance3;
                distance1-distance4;
                distance2-distance3;
                distance2-distance4;
                distance3-distance4];  
   result(kk) = sum(abs(delaycac-delaycac_obj).^2);
end

% --------------------------------------------------------------
% �����������Сֵλ�ã��Լ���Сֵ
y_index = find(result==min(result));
y = [y_index*0.1,result(y_index)*1e5];

% --------------------------------------------------------------
% ��ͼ
figure;
plot(result,'-o','linewidth',2);
hold on;
stem(result);
grid on;

end