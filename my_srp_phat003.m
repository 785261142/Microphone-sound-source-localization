function y = my_srp_phat003(gcc_all, mic, v, fs)
% ������Ҳ��������ȷ����Դλ�õĲ��ԣ���������ѡ����������
% ����������ʵ����Դ��λ
% ���룺GCC-PHAT������˷�λ�ã����٣�������
% �������Դλ��
% ˵����������Ҫʹ��ֱ����������+SRP-PHAT����
% �����������ޣ���ͼ���������������
% �ı�Ϊ������

% --------------------------------------------------------------
% ������ʼ��
energycac = 0; % �����о�����ֵ
frameLen = (size(gcc_all,2)+1)/2;
plotcac = []; % �����������

% --------------------------------------------------------------
% ����ѭ����������
for r = 0.1:1:10.1                                 % �������ֱ���Ϊ1��ע����ñ���㿪ʼ
    for theta = 60*(pi/180):5*(pi/180):90*(pi/180) % �����ǣ��ֱ���Ϊ2
        for phi = 0:5*(pi/180):90*(pi/180)         % ��λ�ǣ��ֱ���Ϊ2
            % ת��Ϊֱ������
            kx = r*sin(theta)*cos(phi);
            ky = r*sin(theta)*sin(phi);
            kz = r*cos(theta);
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
            % ������һ��Ҳ��ע�͵���
%             scatter3(kx,ky,kz,'.',energysum);          
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
    if(plotcac(kk,4)>0.95*maxcac)
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
scatter3(6, 5, 1.6, 100, [0 0 1],'filled');
% % line(plotcac(:,1),plotcac(:,2),plotcac(:,2));
% plot3([0 8; 1 1],[0 8; 0 8],[1 1; 1 1]);
% view(3);
xlabel('x');
ylabel('y');
zlabel('z');

% --------------------------------------------------------------
% α���
y = 0;

end