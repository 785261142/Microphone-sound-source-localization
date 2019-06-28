function y = my_enframe(x, frameLen, overloap, win)
% Note:
%       This function is used to realize 'framing'.
% Usage:
%       y = my_enframe(x, frameLen, overloap, win)
% Input arguments:
%       x         : the input signal (1*N)
%       frameLen  : the lenth of a frame
%       overtloap : the overloap between two frames
%       win       : the type of window function: 'rect', 'hanning', 'hamming'
% Output arguments:
%       y         : the output signal (M1*M2)
% For example:
%       x        = randn(1,1e4);
%       frameLen = 1200;
%       overloap = 400;
%       win      = 'rect';
%       y        = %%%;
% ˵����
%       ����������ʵ�ַ�֡
%       ���룺ԭʼ�źţ���ʸ������֡�������������ص���������������������
%       �������֡����źţ�ÿһ֡ռ��һ��
%       ע�⣺�����������������һ֡������

% --------------------------------------------------------------
% ��ʼ��
N = length(x);                            % �źų���
stepLen = frameLen - overloap;            % ��������
frameNum = floor((N - overloap)/stepLen); % ֡��
y = zeros(frameNum, frameLen);            % �������
n = 1:frameLen;
switch win
    case 'hanning'
        window = 0.5 - 0.5*cos(2*pi*n/frameLen);
    case 'hamming'
        window = 0.54 - 0.46*cos(2*pi*n/frameLen);
    otherwise
        window = ones(1, frameLen);
end

% --------------------------------------------------------------
% ���з�֡
for kk = 1:frameNum % ��ȡ�±���������ӿ�
    startIndex = 1+(kk-1)*stepLen;       % ÿһ֡��ʼ������
    endIndex = startIndex+frameLen-1;    % ÿһ֡����������
    y(kk,:) = x(startIndex:endIndex).*window;
end

end