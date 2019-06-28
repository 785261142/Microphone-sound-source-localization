function result = my_xyzToRtheta(x,y,z)
% Note:
%       This function is used to translate the cartesian coordinates to the
%       spherical coordinates.
% Usage:
%       result = my_xyzToRtheta(x,y,z)
% Input arguments:
%       x      : the x-coordinate
%       y      : the y-coordinate
%       z      : the z-coordinate
% Output arguments:
%       result : the output spherical coordinates [r, theta, phi]
% For example:
%       x       = 0.7071;
%       y       = 0.7071;
%       z       = 0.0000;
%       result  = [1,90,45];
% ˵����
%       ����������ʵ�ֽ�ֱ������ת��Ϊ������
%       ���룺ֱ������ x,y,z
%       ����������������ǣ���λ�� r,theta,phi���Ƕ�ֵ��
%       ע�⣺������Ϊ��ʱ���Ƕȿ����ж��ֵ����������Ϊ��

% --------------------------------------------------------------
% ��ʼת��
r = sqrt(x^2+y^2+z^2);     % ���㼫��
theta = acos(z/r)/pi*180;  % ���㸩����
phi = atan(y/x)/pi*180;    % ���㷽λ��
result = [r,theta,phi];    % ������
result(isnan(result)) = 0; % ��������һЩ�������

end