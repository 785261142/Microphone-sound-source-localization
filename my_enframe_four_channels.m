function y = my_enframe_four_channels(frameLen,overLoap,x)
% Note:
%       This function is used to calculate the GCC-ALL function.
% Usage:
%       y = my_gcc_all(frameNum, frameLen, s1, s2, s3, s4)
% Input arguments:
%       frameNum : the number of frames of every channel data
%       frameLen : the length of each frame
% Output arguments:
%       y        : the GCC-PHAT function (1*(2*N-1))
% For example:
%       x1 = randn(1,2000);
%       x2 = delayseq(x1, 5e-3, 8000); % ��x1����ƽ��5ms��������Ϊ8kHz
%       y  = %%%;
% ˵����
%       ����������ʵ����·�źŵ�GCC-PHAT�ļ���
%       ���룺��·����ʱ�ӹ�ϵ���źţ�Ҫ�����źŵȳ���
%       �����GCC-PHAT

% --------------------------------------------------------------
% ���÷�֡����
x1_enframe = my_enframe(x(1,:), frameLen, overLoap, 'rect'); % ��ʱѡ����δ�
x2_enframe = my_enframe(x(2,:), frameLen, overLoap, 'rect');
x3_enframe = my_enframe(x(3,:), frameLen, overLoap, 'rect');
x4_enframe = my_enframe(x(4,:), frameLen, overLoap, 'rect');

% --------------------------------------------------------------
% ���4·�źŷ�֡��ľ���ע��������һ��Ԫ������
y = {x1_enframe;x2_enframe;x3_enframe;x4_enframe}; 

end