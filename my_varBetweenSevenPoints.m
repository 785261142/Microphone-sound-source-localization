function [y1,y2] = my_varBetweenSevenPoints(obj,mic,dx)
% Note:
%       This function is used to calculate the mean and var of 7 points' DelayPoints. 
% Usage:
%       [y1,y2] = my_varBetweenSevenPoints(obj,mic,dx)
% Input arguments:
%       obj     : the center point (cartesian coordinates)
%       mic     : the cartesian coordinates of micphone arrays (4*3)
%       dx      : the radius of these 7 points
% Output arguments:
%       [y1,y2] : the mean and var of these 7 points SRP
% For example:
%       mic     = [0  , 0 , 0  ;
%                  0  , 0 , 0.1;
%                  0.1, 0 , 0  ;
%                  0  , 0 , 0.1];
%       obj     = [6,5,1.6];
%       dx      = 0.1;
%       [y1,y2] = [1.0634,0.0299];
% ˵����
%       ��������������ĳһ���ĵ㸲�ǵ���Χ7�����ʱ�ӵ������ľ�ֵ�ͷ���
%       ���룺��Դ���꣬�������꣬�ֱ���
%       �������ֵ������
%       ע�⣺������ʱ�Ӷ�Ӧ�ľ��������Ϊ�������ͼ

% --------------------------------------------------------------
% ��ʼ��
v = 340;                                            % ����
fs = 48000;                                         % ������
delaycac_obj = [6.02;21.05;17.65;15.47;12.7;-3.89]; % �ο���ʱ�ӵ����������Ҫ��
distance_cac = zeros(1,7);
obj_cac = ones(7,1)*obj-dx*[0 0 0;0 0 1;0 0 -1;0 1 0;0 -1 0;1 0 0;-1 0 0];

% --------------------------------------------------------------
% ѭ���������
for kk = 1:7
    % ��������
    discac = abs(obj_cac(kk,:)-mic(1,:));
    distance1 = sqrt(sum(discac.^2)); % Ŀ�굽1����˷����
    discac = abs(obj_cac(kk,:)-mic(2,:));
    distance2 = sqrt(sum(discac.^2)); % Ŀ�굽2����˷����
    discac = abs(obj_cac(kk,:)-mic(3,:));
    distance3 = sqrt(sum(discac.^2)); % Ŀ�굽3����˷����
    discac = abs(obj_cac(kk,:)-mic(4,:));
    distance4 = sqrt(sum(discac.^2)); % Ŀ�굽4����˷���� 
    % ����ʱ�ӵ�������
    delaycac = [2*(distance1-distance2)/v*fs;
                2*(distance1-distance3)/v*fs;
                2*(distance1-distance4)/v*fs;
                2*(distance2-distance3)/v*fs;
                2*(distance2-distance4)/v*fs;
                2*(distance3-distance4)/v*fs
               ];
    % �������
    distance_cac(kk) = sum((delaycac-delaycac_obj).^2);
end

% --------------------------------------------------------------
% ���
y1 = mean(distance_cac);  % ��ֵ
y2 = var(distance_cac,1); % ����

end