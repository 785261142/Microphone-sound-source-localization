function y = my_srp_phat002(gcc_all, mic, v, fs)
% �������Ҳ�� my_srp_phat_maxFind_method �Ĳ��԰�
% �������ڣ������˻�ͼ����������Ľ��в���
% ����������ʵ����Դ��λ
% ���룺GCC-PHAT������˷�λ�ã����٣�������
% �������Դλ�ã��Լ�ɨ��Ŀռ�����Ϣͼ��
% ˵����������Ҫʹ��ֱ����������+SRP-PHAT����
% �����������ޣ���ͼ���������������
% ��Ҫ��ʹ����ֱ����������

% --------------------------------------------------------------
% ������ʼ��
xmax = 8;
ymax = 8;
zmax = 2;
dr = 1;
energycac = 0; % �����о�����ֵ
frameLen = (size(gcc_all,2)+1)/2;
plotcac = [];  % �����������

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
            plotcac = [plotcac;[kx,ky,kz,energysum]];
            % ����ΪѰ�����ֵ���֣���ʱע�͵�
%             % ֱ��Ѱ�����ֵ
%             if(energysum>energycac) % ����ҵ������ֵ
%                 energycac = energysum;
%                 y = obj;
%             end  
        end
    end
end

% --------------------------------------------------------------
% ������ɫ����
maxcac = max(plotcac(:,4));
for kk = 1:size(plotcac,1)
    if(plotcac(kk,4)>0.8*maxcac)
        plotcac(kk,5:7) = plotcac(kk,4)/maxcac*[1 0 0];
    else
        plotcac(kk,5:7) = plotcac(kk,4)/maxcac*[0 1 0];
    end   
end

% --------------------------------------------------------------
% ��ͼ
figure;
scatter3(plotcac(:,1),...
         plotcac(:,2),...
         plotcac(:,3),...
         plotcac(:,4)*2,...
         plotcac(:,5:7),...
         'filled');
grid on;
hold on;
% % line(plotcac(:,1),plotcac(:,2),plotcac(:,2));
% plot3([0 8; 1 1],[0 8; 0 8],[1 1; 1 1]); % ��������ά�ռ��л���һ����
% view(3);
xlabel('x');
ylabel('y');
zlabel('z');

% --------------------------------------------------------------
% α���
y = 0;

end