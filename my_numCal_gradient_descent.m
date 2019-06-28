function y = my_numCal_gradient_descent(mic, gcc_all, v, fs)
% Note:
%       This function is used to realize sound source location by 
%       'numerical calculation method'.
% Usage:
%       y = my_numCal_gradient_descent(mic, gcc_all, v, fs)
% Input arguments:
%       mic       : the spherical coordinates of micphone arrays (4*3)
%       gcc_all   : the SRP response based on GCC-PHAT (6*(frameLen*2-1))
%       v         : the speed of sound (340m/s)
%       fs        : the sampling rate (48000Hz)
% Output arguments:
%       y         : the cartesian coordinates of the sound source
% For example:
%       mic       = [0  , 0 , 0  ;
%                    0  , 0 , 0.1;
%                    0.1, 0 , 0  ;
%                    0  , 0 , 0.1];
%       gcc_all = ***; % 
%       v       = 340;
%       fs      = 48000;
%       y       = [6.3880, 5.3350, 1.6807];
% ˵����
%       ����������ʵ����Դ��λ��ֱ����ֵ����ķ�����
%       ���룺��˷�λ�ã�ֱ���������꣩����ͨ��ʱ�Ӿ����ٶȣ�������
%       �������Դλ�ã�ֱ�����꣩
%       ע�⣺���ַ�ʽ�ǻ���ֱ�������

% --------------------------------------------------------------
% ��ʼ��
obj = [1, 1, 1];      % ��ʼֵ��Ӱ��ܴ󣩣���������Դ��6,5,1.6
alpha = 0.005;        % ������Ӱ��ܴ�
error_thresh = 1e-1;  % �������
number = 0;           % ��������
number_thresh = 500;  % ������������
error = 100;          % �������ĳ�ʼֵ
factor_matrix = [1, -1,  0,  0;
                 1,  0, -1,  0;
                 1,  0,  0, -1;
                 0,  1, -1,  0;
                 0,  1,  0, -1;
                 0,  0,  1, -1;]; % ϵ������
delay_ref = my_get_six_delay_point(gcc_all, 20, 20); % ���ú�������delay_ref

% --------------------------------------------------------------
% �ݶ��½���
while(error>error_thresh&&number<number_thresh)                 % ����������ﵽ���޵�ʱ���˳�
    range = sqrt(sum((ones(4,1)*obj-mic).^2,2));                % ����           4*1
    delay = factor_matrix*range*2/v*fs;                         % ʱ��           6*1         
    error = sum((delay-delay_ref).^2);                          % ��ǰ���       1*1
    range_gradient = 1./(range*ones(1,3)).*(ones(4,1)*obj-mic); % ÿ��������ݶ� 4*3
    delay_gradient = factor_matrix*range_gradient;              % ÿ��ʱ�ӵ��ݶ� 6*3
    delay_error = (delay-delay_ref)*ones(1,3);                  % ÿ��ʱ�����   6*3
    error_gradient = sum(delay_gradient.*delay_error*4*fs/v);   % ��ǰ����ݶ�   1*3
    obj = obj - alpha*error_gradient;                           % ���е�������
    number = number+1;                                          % ��¼����
    
%     % ���������������
%     e = 4*fs/v*(delay-delay_ref)'*factor_matrix*range_gradient; %
%     ���ַ�ʽҲ�ǶԵ�
%     % ���������������
%     number 
%     error
%     obj

end

% --------------------------------------------------------------
% ������ 
y = obj;

end