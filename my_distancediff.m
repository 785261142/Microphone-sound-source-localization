function y = my_distancediff(a, b)
% Note:
%       This function is used to calculate the distance between two points in spherical coordinates.
% Usage:
%       y = my_distancediff(a, b)
% Input arguments:
%       a : the spherical coordinates of the first point  (1*3)
%       b : the spherical coordinates of the second point (1*3)
% Output arguments:
%       y : the distance
% For example:
%       a = [1, 0 , 90];
%       b = [1, 90, 90];
%       y = 1.414;
% ˵����
%       ��������������������������ľ���
%       ���룺a��b��Ϊ1*3�����������������꣺r,theta,phi(�Ƕ�ֵ���ǻ�����)
%       ���������

% --------------------------------------------------------------
% ���ݴ���
r1 = a(1);
theta1 = a(2)/180*pi; % theta1ת��Ϊ������
phi1 = a(3)/180*pi;   % phi1ת��Ϊ������
r2 = b(1);
theta2 = b(2)/180*pi; % theta2ת��Ϊ������
phi2 = b(3)/180*pi;   % phi2ת��Ϊ������
% --------------------------------------------------------------
% ���չ�ʽ����
y = sqrt(r1^2+r2^2-2*r1*r2*(sin(theta1)*sin(theta2)*cos(phi1-phi2)+cos(theta1)*cos(theta2)));

end