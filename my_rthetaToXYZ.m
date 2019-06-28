function result = my_rthetaToXYZ(r,theta,phi)
% Note:
%       This function is used to translate the spherical coordinates to the
%       cartesian coordinates.
% Usage:
%       result = my_rthetaToXYZ(r,theta,phi)
% Input arguments:
%       r      : the polar diameter (0 to inf)
%       theta  : the pitch angle    (0 to 180)
%       phi    : the azimuth angle  (0 to 360)
% Output arguments:
%       result : the output cartesian coordinates
% For example:
%       r       = 1;
%       theta   = 90;
%       phi     = 45;
%       result  = [0.7071,0.7071,0.0000];
% ˵����
%       ����������ʵ�ֽ�������ת��Ϊֱ������
%       ���룺�����������ǣ���λ�� r,theta,phi���Ƕ�ֵ��
%       �����ֱ������ x,y,z

% --------------------------------------------------------------
% ����ת��
angle_con = pi/180;                              % �Ƕ���ת����������
x = r*sin(theta*angle_con)*cos(phi*angle_con);   % x����
y = r*sin(theta*angle_con)*sin(phi*angle_con);   % y����
z = r*cos(theta*angle_con);                      % z����

% --------------------------------------------------------------
% ���
result = [x,y,z];

end