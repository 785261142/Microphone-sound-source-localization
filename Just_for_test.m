% just for test
% Note:
%       Release date: 2019/06/10
%       Author: xiaoli
%       Email: xiaoli644@qq.com
% Copyright (C) 2019 xiaoli
% Usage:
%       This program is used to test some ideas.
% ˵����
%       ������Ҫ��������һЩ���ԡ�
% ע�⣺
%       ������������򣬶������ڵ��ԡ�

%% ���ڲ���

% ������
% ֱ��ɨ�貢��ͼ
result2 = my_srp_phat002(gcc_all, mic, v, fs);

% ������
% ������ɨ�貢��ͼ
result3 = my_srp_phat003(gcc_all, mic, v, fs);

% ����
% ���������겢���е�һ����������
result4 = my_srp_phat004(gcc_all, mic2, v, fs);

a1 = [0.1,10.1;60,90;0,90];
b1 = [1,10,10];
a2 = my_spaceShrink(a1, b1, gcc_all, mic2, v, fs)

b2 = [1,2,2];
a3 = my_spaceShrink(a2, b2, gcc_all, mic2, v, fs)

b3 = [1,0.5,0.5];
a4 = my_spaceShrink(a3, b3, gcc_all, mic2, v, fs)

% ���ս�����£��о����Ǻܲ����
% a4 =
%     0.1000   10.1000
%    78.0787   79.0787
%    39.6756   40.6756
% my_rthetaToXYZ(7.9525,78.5787,40.1756)
%     5.9559    5.0288    1.5748

%% ����sinc��ֵ
z = [];
tt_center = 1195;
tt = (tt_center-5):0.01:(tt_center+5);
for kk = tt
    zcac = my_sinc(xcorr34((tt_center-10):(tt_center+10)),(tt_center-10):(tt_center+10),kk);
    z = [z, zcac];
end

figure;
stem(tt,z);
tt_center-5+0.01*(find(z==max(z))-1)

%% ������
clc;
close all;
for kk = 1:441
    aaa(kk) = find(test_cac(:,kk)==max(test_cac(:,kk)));
end
plot(aaa,'o-');
hold on;
stem(aaa);
grid on;

%% ����sinc��ͼ3*3
figure;
n = 1200:1240;
x = gcc_all2(2,n);
num = 10;
[y, m] = my_sinc_vector(x, n, num);

subplot(211);
plot(n,x,'-o','linewidth',2);
hold on;
stem(n,x);
legend('ԭʼGCC13');
xlabel('delay/points');
grid on;

subplot(212);
plot(m,y,'linewidth',2);
hold on;
stem(m,y);
legend('sinc��ֵ��GCC13');
xlabel('delay/points');
grid on;
xlim([1215,1225]);

%% ����������ͼ
my_srp_phat002(gcc_all, mic, v, fs);

my_srp_phat003(gcc_all, mic, v, fs);





