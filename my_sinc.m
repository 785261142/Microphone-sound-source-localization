function y = my_sinc(x, n, t)
% Note:
%       This function is used to realize 'Sinc interpolation'.
% Usage:
%       y = my_sinc(x, n, t)
% Input arguments:
%       x : the original signal (1*N)
%       n : the original time axis (1*N)
%       t : the moment you want to do 'Sinc interpolation'
% Output arguments:
%       y : the value of the 't' moment
% For example:
%       x = sin(1:10);
%       n = 1:10;
%       t = 7.5;
%       y = 0.8960;
% ˵����
%       ����������ʵ��sinc��ֵ
%       ���룺ԭʼ�źţ�ԭʼ�źŶ�Ӧʱ���ᣨ����������ֵʱ��㣨С��������
%       �������ֵ���źŴ�С
%       ע�⣺����������ص���һ����

% --------------------------------------------------------------
if(~isempty(find(n == t, 1))) % ȷ����ֵ���Ƿ��Ѿ�����
    y = x(find(n == t, 1));
else
    y = 0;          % �ۼӻ���
    N = length(x);  % �źų���
    for kk = 1:N
        y = y + x(kk)*sin((t-n(kk))*pi)/((t-n(kk))*pi); % ����sinc��ֵ�ۼ�
    end
end

end