function y = my_gcc_all(frameNum, frameLen, s_ideal_enframe)
% Note:
%       This function is used to calculate the GCC-ALL function.
% Usage:
%       y = my_gcc_all(frameNum, frameLen, s1, s2, s3, s4)
% Input arguments:
%       frameNum        : the number of frames of every channel data
%       frameLen        : the length of each frame
%       s_ideal_enframe : the input signal (4*1: {s1;s2;s3;s4})
% Output arguments:
%       y               : the xcorr between two channels (6*1: [x12;x13...])
% For example:
%       frameNum         = 161;
%       fremeLen         = 1200;
%       s_ideal_enframe  = %%%;
% ˵����
%       ����������ʵ����·�źŵ�GCC-PHAT�ļ���
%       ���룺֡����֡����4·�ź���ɷ�֮֡���Ԫ������
%       �����gcc_all����6�У�ÿһ����һ���źŶԵ�GCC��

% --------------------------------------------------------------
% ��ʼ��
s1 = s_ideal_enframe{1};
s2 = s_ideal_enframe{2};
s3 = s_ideal_enframe{3};
s4 = s_ideal_enframe{4};
xcorrCac12 = zeros(frameNum, 2*frameLen - 1);
xcorrCac13 = zeros(frameNum, 2*frameLen - 1);
xcorrCac14 = zeros(frameNum, 2*frameLen - 1);
xcorrCac23 = zeros(frameNum, 2*frameLen - 1);
xcorrCac24 = zeros(frameNum, 2*frameLen - 1);
xcorrCac34 = zeros(frameNum, 2*frameLen - 1);

% --------------------------------------------------------------
% ����my_gcc_phat������·ͨ����GCC
for kk = 1:frameNum
    xcorrCac12(kk, :) = my_gcc_phat(s1(kk, :), s2(kk, :));
    xcorrCac13(kk, :) = my_gcc_phat(s1(kk, :), s3(kk, :));
    xcorrCac14(kk, :) = my_gcc_phat(s1(kk, :), s4(kk, :));
    xcorrCac23(kk, :) = my_gcc_phat(s2(kk, :), s3(kk, :));
    xcorrCac24(kk, :) = my_gcc_phat(s2(kk, :), s4(kk, :));
    xcorrCac34(kk, :) = my_gcc_phat(s3(kk, :), s4(kk, :));   
end

% --------------------------------------------------------------
% �γ�ʱ�Ӿ���(1*Ncorr)��ÿ��ʱ�Ӷ�Ӧ��ֵ
xcorr12 = abs(sum(xcorrCac12));
xcorr13 = abs(sum(xcorrCac13));
xcorr14 = abs(sum(xcorrCac14));
xcorr23 = abs(sum(xcorrCac23));
xcorr24 = abs(sum(xcorrCac24));
xcorr34 = abs(sum(xcorrCac34));

% --------------------------------------------------------------
% ����
% % ע��������ʱ����Ҫ������ʱ�������⴦��������Ҫ������
% xcorr12(1200) = 0;
% xcorr13(1200) = 0;
% xcorr14(1200) = 0;
% xcorr23(1200) = 0;
% xcorr24(1200) = 0;
% xcorr34(1200) = 0;
% --------------------------------------------------------------
% % ��ͼ
% figure;
% imagesc(abs(gcc_all(2,:))); % ��֡���ʱ��ͼ
% ylabel('frame/nums');
% xlabel('delay/points');
% title('��֡��ʽ�µ�ʱ��ͼ');
% figure;
% stem(xcorr13); % ���Ϻ��ʱ��ͼ
% grid on;
% xlabel('delay/points');
% title('������ʽ�µ�ʱ��ͼ');

% --------------------------------------------------------------
% ���
y = [xcorr12;xcorr13;xcorr14;xcorr23;xcorr24;xcorr34]; 

end