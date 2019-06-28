function y = my_numCal_Newton_method(mic, gcc_all, v, fs)
% Note:
%       This function is used to realize sound source location by 
%       'numerical calculation method'.
% Usage:
%       y = my_num_calculation_method(mic, delay_ref)
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
%       gcc_all   = ***; % 
%       v         = 340;
%       fs        = 48000;
%       y         = [6.3880, 5.3350, 1.6807];
% ˵����
%       ����������ʵ����Դ��λ��ֱ��ţ�ټ���ķ�����
%       ���룺��˷�λ�ã�ֱ���������꣩����ͨ��ʱ�Ӿ����ٶȣ�������
%       �������Դλ�ã�ֱ�����꣩
%       ע�⣺���ַ�ʽ�ǻ���ֱ������ģ�����ţ�ٷ�

% --------------------------------------------------------------
% ��ʼ��
obj = [0.1, 0.1, 0.1]; % ��ʼֵ��Ӱ��ܴ󣩣���������Դ��6,5,1.6
error_thresh = 1e-8;   % �������
number = 0;            % ��������
number_thresh = 500;   % ������������
error = 100;           % �������ĳ�ʼֵ
factor_matrix = [1, -1,  0,  0;
                 1,  0, -1,  0;
                 1,  0,  0, -1;
                 0,  1, -1,  0;
                 0,  1,  0, -1;
                 0,  0,  1, -1;]; % ϵ������
delay_ref = my_get_six_delay_point(gcc_all, 20, 20); % ���ú�������delay_ref

% --------------------------------------------------------------
% �����ǲ�������
error_cac = [];
obj_cac = []; % ���ڲ���
delay_cac = []; % ���ڲ���
data_cac = [];
% ���Է���ֻ�е�ʱ�ӹ���ʮ�־�ȷ��ʱ�򣬲ſ��Խ��о��붨λ����������¶��ᵼ�²�����
% delay_ref = [5.4932;21.1721;17.5998;15.6759;12.1036;-3.5724]; % �������
% delay_ref = [6.02;21.05;17.65;15.47;12.7;-3.89]; % �����
% delay_ref = [6.02-0.4881;21.05;17.65;15.47;12.7-0.5735;-3.89+0.4099]; % �����
% delay_ref = [6.02-0.4881;21.05;17.65;15.47;12.7-0.5735;-3.89+0.4099-0.06]; % �����
% delay_ref = [6.02-0.4881-0.009;21.05;17.65;15.47;12.7-0.5735;-3.89+0.4099-0.06]; % �����
% delay_ref = [5.5932;21.0721;17.6998;15.5759;12.2036;-3.4724]; % �����
% delay_ref = [5.4832;21.1821;17.5898;15.6859;12.1136;-3.5624];
% delay_ref = [5.4932;21.1721;17.5998;15.6759;12.1036;-3.5724] + 0.01*rand(6,1);

% --------------------------------------------------------------
% ����ţ�ٷ���ѭ��
while(error>error_thresh&&number<number_thresh)                 % ����������ﵽ���޵�ʱ���˳�
    range = sqrt(sum((ones(4,1)*obj-mic).^2,2));                % ����           4*1
    delay = factor_matrix*range*2/v*fs;                         % ʱ��           6*1         
    error = sum((delay-delay_ref).^2);                          % ��ǰ���       1*1
    range_gradient = 1./(range*ones(1,3)).*(ones(4,1)*obj-mic); % ÿ��������ݶ� 4*3
    delay_gradient = factor_matrix*range_gradient;              % ÿ��ʱ�ӵ��ݶ� 6*3
    delay_error = (delay-delay_ref)*ones(1,3);                  % ÿ��ʱ�����   6*3
    error_gradient = sum(delay_gradient.*delay_error*4*fs/v);   % ��ǰ����ݶ�   1*3
    
    % ������ţ�ٷ�
    % һ���ݶȾ���
    e1 = 4*fs/v*(delay-delay_ref)'*factor_matrix*range_gradient; %
    % �����ݶȾ���
    e2_cac = factor_matrix*((ones(4,1)*obj-mic).*(1./range*ones(1,3)));
    e2 = 4*fs/v*(1./range')*factor_matrix'*(delay-delay_ref)+8*fs^2/v^2*e2_cac'*e2_cac;
    % ���е���
    obj = obj - e1*inv(e2)';
    number = number+1;

%     % ���������������
%     number 
%     error
%     obj
%     my_xyzToRtheta(obj(1),obj(2),obj(3))
%     obj_cac = [obj_cac;ans];
%     error_cac = [error_cac;error];
%     delay_cac = [delay_cac;abs(my_delayPoint(mic,obj)-delay_ref')];
%     % ��������Ϣ����������
%     % ����Ϊ��[num,error,obj,obj2,delay,delay_error]
%     data_cac = [data_cac;...
%                 number,error,obj,my_xyzToRtheta(obj(1),obj(2),obj(3)),my_delayPoint(mic,obj),abs(my_delayPoint(mic,obj)-delay_ref')
%                 ];
%     % data_cacҲ�����ڲ��Ե�����

end

% --------------------------------------------------------------
% ������ 
y = obj;

end