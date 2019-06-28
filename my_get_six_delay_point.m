function y = my_get_six_delay_point(gcc_all, interPoints, interRadius)
% Note:
%       This function is used to get the six delay points from GCC-Results.
% Usage:
%       y = my_get_six_delay_point(gcc_all, interPoints, interRadius)
% Input arguments:
%       gcc_all     : the SRP response based on GCC-PHAT (6*(frameLen*2-1))
%       interPoints : the interpolation points berween every two points
%       interRadius : the chosen data radius of the original points rate
% Output arguments:
%       y           : the six delay points between two different channels (6*1)
% For example:
%       gcc_all     = ***;%
%       interPoints = 20;
%       interRadius = 20;
%       y           = [5.4286;21.1429;17.6190;15.6667;12.0952;-3.4762];
% ˵����
%       ������������GCC�Ľ����ͨ����ֵ��������ʱ�ӵ���
%       ���룺GCC����ÿ����ԭʼ��֮��Ĳ�ֵ��������ֵ�뾶
%       �����6��ʱ�ӵ���
%       ע�⣺��Ҫ��ͨ����ֵ����ȡ��Ϊ��ȷ�Ľ������Ҫ�ǹ������ֵ

% --------------------------------------------------------------
% ��ʼ��
length_gcc = size(gcc_all,2); % ȷ��GCC������
frameLen = (length_gcc+1)/2;  % ȷ��frameLen
delayPointMax = zeros(6,1);   % ��ʼ��6·��ʱ����

% --------------------------------------------------------------
% ���в�ֵ���
for kk = 1:6
    % ���ҵ����ֵλ��
    gcc_cac = gcc_all(kk,:);
    max_index = find(gcc_cac==max(gcc_cac));
    % ������Ҫ���ж���㴦�����⴦��
    if(max_index==frameLen)
        gcc_cac(max_index) = 0;
        max_index = find(gcc_cac==max(gcc_cac));                 % ����Ѱ�����ֵ
    end
    inputTime = (max_index-interRadius):(max_index+interRadius); % ����ֱ�Ӿ��ǵ���
    inputSignal = gcc_cac(inputTime);                            % �����ԭʼ��ֵ�ź�
    [outputSignal, outputTime] = my_sinc_vector(inputSignal, inputTime, interPoints);
    max_index2 = find(outputSignal==max(outputSignal));          % Ѱ�Ҳ�ֵ������ֵ����
    delayPointMax(kk,1) = outputTime(max_index2);                % ������ֵת��Ϊʱ��
end

% --------------------------------------------------------------
% ������ 
y = delayPointMax-frameLen;

end