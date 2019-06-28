% TDOA_method
% Note:
%       Release date: 2019/06/06
%       Author: xiaoli
%       Email: xiaoli644@qq.com
% Copyright (C) 2019 xiaoli
% Usage:
%       This program is used to realize the simulation for TDOA.
% ˵����
%       ������Ҫ��������TDOA�㷨�ĸĽ���
% ע�⣺
%       �����������ֱ�����м��ɡ�

%% ��ȡ����
% ע��ʵ���еĴ�������������ϲ���������ת����
clear;
clc;
close all;

% cd('E:\2018-2019 Master Grade 2 - Backup\006_Competition\003_�������\002_��������\TDOA_method');
% ����ԭʼ�����Ѿ���ɣ����� obj = [6 5 1.6] λ�ô�����Դ���ɵ�
load('oriWave_004.mat');

fs = 48000; % ������
snr = 30;   % �����

% ԭʼ�����ź�
s_ideal = [s1cac';s2cac';s3cac';s4cac'];

% �˹�����
s1cacAddNoise = awgn(s1cac, snr);
s2cacAddNoise = awgn(s2cac, snr);
s3cacAddNoise = awgn(s3cac, snr);
s4cacAddNoise = awgn(s4cac, snr);
s_AddNoise = [s1cacAddNoise';s2cacAddNoise';s3cacAddNoise';s4cacAddNoise'];

% Ԥ�˲�
s1cacNoiseFilter = my_prefilter(s1cacAddNoise, 50, 3400, fs); % 300 5000
s2cacNoiseFilter = my_prefilter(s2cacAddNoise, 50, 3400, fs);
s3cacNoiseFilter = my_prefilter(s3cacAddNoise, 50, 3400, fs);
s4cacNoiseFilter = my_prefilter(s4cacAddNoise, 50, 3400, fs);
s_NoiseFilter = [s1cacNoiseFilter';s2cacNoiseFilter';s3cacNoiseFilter';s4cacNoiseFilter'];

% ��ͼ
t = linspace(0,length(s1cac)/fs,length(s1cac));
figure;
subplot(311);
plot(t,s1cac);
grid on;
xlabel('t/s');
legend('�����ź�');
subplot(312);
plot(t,s1cacAddNoise);
grid on;
xlabel('t/s');
legend('�����ź�');
subplot(313);
plot(t,s1cacNoiseFilter);
grid on;
xlabel('t/s');
legend('������˲��ź�');

%% ���з�֡
% �趨����
% frameLenTime = 25e-3; % 25ms
% frameLen = round(fs*frameLenTime); % 1200��
frameLen = 1200;    % ֡��1200��
overLoap = 400;     % 200���ص�

% ���µ��ö�4·ͨ���ֱ���з�֡�ĺ���
s_ideal_enframe = my_enframe_four_channels(frameLen,overLoap,s_ideal);             % ԭʼ�����źŵķ�֡Ԫ��
s_AddNoise_enframe = my_enframe_four_channels(frameLen,overLoap,s_AddNoise);       % �����ķ�֡Ԫ��
s_NoiseFilter_enframe = my_enframe_four_channels(frameLen,overLoap,s_NoiseFilter); % �����˲���ķ�֡Ԫ��

%% ����GCC-PHAT(gcc-all)
frameNum = size(s_ideal_enframe{1,1},1);                          % ֡��
gcc_all = my_gcc_all(frameNum, frameLen, s_ideal_enframe);        % ԭʼ�����źŵ�6·gcc����
gcc_all2 = my_gcc_all(frameNum, frameLen, s_AddNoise_enframe);    % ������6·gcc����
gcc_all3 = my_gcc_all(frameNum, frameLen, s_NoiseFilter_enframe); % �����˲����6·gcc����

% ��ͼ
figure;
subplot(311);
plot(gcc_all(2,:),'-o','linewidth',2);
hold on;
stem(gcc_all(2,:),'linewidth',1);
legend('�����ź�');
xlim([1180,1240]);
grid on;
subplot(312);
plot(gcc_all2(2,:),'-o','linewidth',2);
hold on;
stem(gcc_all2(2,:),'-o','linewidth',1);
legend('�����ź�');
xlim([1180,1240]);
grid on;
subplot(313);
plot(gcc_all3(2,:),'-o','linewidth',2);
hold on;
stem(gcc_all3(2,:),'-o','linewidth',1);
legend('������˲��ź�');
xlim([1180,1240]);
grid on;

%% �ռ�λ��
close all;
clc;

% ��ʼ������λ�ã�ֱ������������꣩
mic = [0  ,0  ,0  ;
       0  ,0  ,0.1;
       0.1,0  ,0  ;
       0  ,0.1,0  ];    % ��˷�λ�ã�1/2/3/4��
mic2 = [0  , 0 , 0;
        0.1, 0 , 0;
        0.1, 90, 0;
        0.1, 90, 90];   % ����������˷�λ�ã�1/2/3/4��
obj = [6  ,5  ,1.6  ];  % ��ʵ��Դλ��
v = 340;                % ����

%% ���ж�λ
clc;

% ��ʵ��Դλ��
obj_sph = my_xyzToRtheta(obj(1),obj(2),obj(3));
fprintf('---------------------------------------------------��\n');
fprintf('����ʵ��Դλ�á�\n');
fprintf('ֱ����������%7.4f met, %7.4f met, %7.4f met\n', obj(1), obj(2), obj(3));
fprintf('������������%7.4f met, %7.4f deg, %7.4f deg\n', obj_sph(1), obj_sph(2), obj_sph(3));

% ����һ��ֱ������ɨ��SRP���ֵ��
t0 = cputime;
result1 = my_srp_phat_maxFind_method(gcc_all, mic, v, fs);
t1 = cputime;
result1_sph = my_xyzToRtheta(result1(1),result1(2),result1(3));
fprintf('---------------------------------------------------��\n');
fprintf('��ֱ������ɨ��SRP���ֵ����\n');
fprintf('����һ��ʱΪ��%7.4fs\n', t1-t0);
fprintf('ֱ����������%7.4f met, %7.4f met, %7.4f met\n', result1(1), result1(2), result1(3));
fprintf('������������%7.4f met, %7.4f deg, %7.4f deg\n', result1_sph(1), result1_sph(2), result1_sph(3));

% ��������������SRP����������
t0 = cputime;
result2_sph = my_srp_phat_spaceShrink_method(gcc_all, mic2, v, fs);
t1 = cputime;
result2 = my_rthetaToXYZ(result2_sph(1),result2_sph(2),result2_sph(3));
fprintf('---------------------------------------------------��\n');
fprintf('��������SRP������������\n');
fprintf('��������ʱΪ��%7.4fs\n', t1-t0);
fprintf('ֱ����������%7.4f met, %7.4f met, %7.4f met\n', result2(1), result2(2), result2(3));
fprintf('������������%7.4f met, %7.4f deg, %7.4f deg\n', result2_sph(1), result2_sph(2), result2_sph(3));

% ��������ֱ���ݶ��½���
t0 = cputime;
result3 = my_numCal_gradient_descent(mic, gcc_all, v, fs);
t1 = cputime;
result3_sph = my_xyzToRtheta(result3(1),result3(2),result3(3));
fprintf('---------------------------------------------------��\n');
fprintf('��ֱ���ݶ��½�����\n');
fprintf('��������ʱΪ��%7.4fs\n', t1-t0);
fprintf('ֱ����������%7.4f met, %7.4f met, %7.4f met\n', result3(1), result3(2), result3(3));
fprintf('������������%7.4f met, %7.4f deg, %7.4f deg\n', result3_sph(1), result3_sph(2), result3_sph(3));

% �����ģ�ֱ��ţ�ٷ�
t0 = cputime;
result4 = my_numCal_Newton_method(mic, gcc_all, v, fs);
t1 = cputime;
result4_sph = my_xyzToRtheta(result4(1),result4(2),result4(3));
fprintf('---------------------------------------------------��\n');
fprintf('��ֱ��ţ�ٷ���\n');
fprintf('��������ʱΪ��%7.4fs\n', t1-t0);
fprintf('ֱ����������%7.4f met, %7.4f met, %7.4f met\n', result4(1), result4(2), result4(3));
fprintf('������������%7.4f met, %7.4f deg, %7.4f deg\n', result4_sph(1), result4_sph(2), result4_sph(3));
