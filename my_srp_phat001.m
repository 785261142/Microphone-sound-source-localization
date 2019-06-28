function y = my_srp_phat001(gcc_all, mic, v, fs)
% ���������ʵ���� my_srp_phat_maxFind_method �Ĳ��԰�
% ����������ʵ����Դ��λ
% ���룺GCC-PHAT������˷�λ�ã����٣�������
% �������Դλ��
% ˵����������Ҫʹ��ֱ����������+SRP-PHAT������ֱ�����ֵ�ķ���

% --------------------------------------------------------------
% ������ʼ��
xmax = 8;      % xά�������߽�
ymax = 8;      % yά�������߽�
zmax = 2;      % zά�������߽�
dr = 0.1;      % ÿ��ά����������
energycac = 0; % �����о�����ֵ
frameLen = (size(gcc_all,2)+1)/2; % ֡������������SRP��

% --------------------------------------------------------------
% ����ѭ����������
for kx = 0:dr:xmax
    for ky = 0:dr:ymax
        for kz = 0:dr:zmax
            obj = [kx,ky,kz]; % Ŀ��λ��
            % ��������
            discac = abs(obj-mic(1,:));
            distance1 = sqrt(sum(discac.^2)); % Ŀ�굽1����˷����
            discac = abs(obj-mic(2,:));
            distance2 = sqrt(sum(discac.^2)); % Ŀ�굽2����˷����
            discac = abs(obj-mic(3,:));
            distance3 = sqrt(sum(discac.^2)); % Ŀ�굽3����˷����
            discac = abs(obj-mic(4,:));
            distance4 = sqrt(sum(discac.^2)); % Ŀ�굽4����˷���� 
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
            % ֱ��Ѱ�����ֵ
            if(energysum>energycac) % ����ҵ������ֵ
                energycac = energysum;
                y = obj;
            end  
        end
    end
end

end