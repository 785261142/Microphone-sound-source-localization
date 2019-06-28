function [y, m] = my_sinc_vector(x, n, num)
% Note:
%       This function is used to realize 'Sinc interpolation'.
% Usage:
%       [y, n] = my_sinc_vector(x, n, number)
% Input arguments:
%       x   : the original signal (1*N)
%       n   : the original time axis (1*N)
%       num : the number of interpolation points between two original points.
% Output arguments:
%       y   : the output signal (about 1*N*number)
%       m   : the output time axis (about 1*N*number)
% For example:
%       x   = sin(1:10);
%       n   = 1:10;
%       num = 5;
%       [y, m] = my_sinc_vector(x, n, num);
%       plot(n,x,'-o','linewidth',2);
%       hold on;
%       stem(m,y);
% ˵����
%       ����������ʵ��sinc��ֵ
%       ���룺ԭʼ�źţ�ԭʼ�źŶ�Ӧʱ���ᣨ��������ԭʼ����֮���²���ĵ���
%       �������ֵ���źţ���ֵ��ʱ����
%       ע�⣺����������ص���һ�������������ź�������ʱ��������

% --------------------------------------------------------------
% ��ʼ��
N = length(n)+num*(length(n)-1); % �ܵ���
y = zeros(1,N);                  % ����ź�ʸ��
m = zeros(1,N);                  % ���ʱ��ʸ��

% --------------------------------------------------------------
% ���в�ֵ
for ii = 1:N
    if(mod(ii,num+1)==1)                  % ����պ�ȡ��
        y(ii) = x(ceil(ii/(num+1)));
        m(ii) = n(ceil(ii/(num+1)));
    else                                  % ���û��ȡ��
        y_cac = 0;                        % �ۼӱ���
        m_before = n(ceil(ii/(num+1)));   % ��ǰ��ֵ��֮ǰ��ԭʼʱ��λ��
        m_back = n(ceil(ii/(num+1))+1);   % ��ǰ��ֵ��֮���ԭʼʱ��λ��
        dt = (m_back-m_before)/(num+1);   % �ò�ֵ����ķֱ���
        m_cac = m_before+dt*(ii-(num+1)*(ceil(ii/(num+1)-1))-1); % �µĲ�ֵ���Ӧ��ʱ��λ��
        for jj = 1:length(n)
            y_cac = y_cac + x(jj)*sin((m_cac-n(jj))*pi)/((m_cac-n(jj))*pi); % ����sinc��ֵ�ۼ�
        end
        y(ii) = y_cac; % �źŸ�ֵ
        m(ii) = m_cac; % ʱ�丳ֵ
    end
end

end