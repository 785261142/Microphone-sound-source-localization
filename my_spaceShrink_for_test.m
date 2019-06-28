function c = my_spaceShrink_for_test(a, b, gcc_all, mic2, v, fs)
% �ú�����Ҫ�������ԣ�Ҳ�ǶԽǶȽ�����������������my_spaceShrinkAngleʮ������
% ��Ϊ�ǲ��԰棬����ע�;Ͳ�д����ô��ʽ��
% ����������ʵ�ֿ�������������������Ǽ�����
% ���룺ԭʼ�߽磬�ֱ���
% ����������߽�
% a = [0.1,10.1;  %  r
%      60,90;     %  theta
%      0,90;]     %  phi
% b = [1,10,10];
% c = [0.1,10.1;
%      30,50;
%      70,90];

% --------------------------------------------------------------
% ��ʼ��
% energycac = 0; % �����о�����ֵ
frameLen = (size(gcc_all,2)+1)/2;   % ֡��
srpangle = [];                      % �����������

% --------------------------------------------------------------
% ��������ѭ��
for theta = a(2,1):b(2):a(2,2)      % ������
    for phi = 0:b(3):90             % ��λ��    
        response_cac = 0;
        for r = a(1,1):b(1):a(1,2)  % ��
            % �������
            distance1 = my_distancediff([r,theta,phi],mic2(1,:)); % Ŀ�굽1����˷����
            distance2 = my_distancediff([r,theta,phi],mic2(2,:)); % Ŀ�굽2����˷����
            distance3 = my_distancediff([r,theta,phi],mic2(3,:)); % Ŀ�굽3����˷����
            distance4 = my_distancediff([r,theta,phi],mic2(4,:)); % Ŀ�굽4����˷����           
            % ����ʱ�ӵ�������
            delaycac = [2*(distance1-distance2)/v*fs;
                        2*(distance1-distance3)/v*fs;
                        2*(distance1-distance4)/v*fs;
                        2*(distance2-distance3)/v*fs;
                        2*(distance2-distance4)/v*fs;
                        2*(distance3-distance4)/v*fs
                       ];            
            % ����sinc��Ȩ����SRP
            energy_xx_cac = zeros(1,6);
            for zz = 1:6
                index = frameLen+floor(delaycac(zz))+(-3:4);
                energy_xx_cac(zz) = my_sinc(gcc_all(zz,index),index,frameLen+delaycac(zz));
            end
            energysum = sum(energy_xx_cac);
            % �洢�÷����10��SRP����Ӧ��
            response_cac = response_cac+energysum;
        end
        srpangle = [srpangle;[theta,phi,response_cac]];
    end
end

% --------------------------------------------------------------
% ����������Ľ��
srpangle = sortrows(srpangle,3);
number_cac = size(srpangle,1);   % ����
number = round(number_cac*0.1);  % ��ȡǰ10%���м�Ȩ
weight_cac = srpangle(end-number:end,3)/sum(srpangle(end-number:end,3));
theta_ave = sum(srpangle((end-number):end,1).*weight_cac);
phi_ave = sum(srpangle((end-number):end,2).*weight_cac);

% --------------------------------------------------------------
% ���
c = [a(1,1),a(1,2);
     theta_ave-b(2),theta_ave+b(2);
     phi_ave-b(3),phi_ave+b(3)];

end