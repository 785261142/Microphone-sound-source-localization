function y = my_srp_phat004(gcc_all, mic2, v, fs)
% ����������ʵ����Դ��λ��Ҳ��һ�����԰棩
% ���룺GCC-PHAT������˷�λ�ã������꣩�����٣�������
% �������Դλ��
% ˵����������Ҫʹ��ֱ����������+SRP-PHAT����
% �����������ޣ���ͼ���������������
% �ı�Ϊ������

% --------------------------------------------------------------
% ������ʼ��
energycac = 0; % �����о�����ֵ
frameLen = (size(gcc_all,2)+1)/2;
plotcac = [];  % �����������
srpangle = [];
d_theta = 10;  % theta�ֱ��ʣ�10��
d_phi = 10;    % phi�ֱ��ʣ�10��

% --------------------------------------------------------------
% ��������ѭ��
for theta = 60:d_theta:90  % ������
    for phi = 0:d_phi:90   % ��λ��       
        response_cac = 0;
        for r = 0.1:1:10.1 % ������ע����ñ���㿪ʼ��
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
            % ת����ֱ�����겢�洢
            plotcac = [plotcac;[my_rthetaToXYZ(r,theta,phi),energysum]]; % kx,ky,kz   
            % �洢�÷����10��SRP����Ӧ��
            response_cac = response_cac+energysum;
        end
        srpangle = [srpangle;[theta,phi,response_cac]];
    end
end

% --------------------------------------------------------------
% �鿴ÿ�������ϵĲ�ͬ�������Ӧ֮��
disp(srpangle);

% --------------------------------------------------------------
% ������ɫ��������ͼ
maxcac = max(plotcac(:,4));
for kk = 1:size(plotcac,1)
    if(plotcac(kk,4)>0.95*maxcac)
        plotcac(kk,5:7) = plotcac(kk,4)/maxcac*[1 0 0];
    else
        plotcac(kk,5:7) = plotcac(kk,4)/maxcac*[0 1 0];
    end   
end
figure;
scatter3(plotcac(:,1),...
         plotcac(:,2),...
         plotcac(:,3),...
         plotcac(:,4)*2,...
         plotcac(:,5:7),...
         'filled');
grid on;
% hold on;
% scatter3(6, 5, 1.6, 100, [0 0 1],'filled');
% hold on;
% % % line(plotcac(:,1),plotcac(:,2),plotcac(:,2));
% plot3([0 8; 1 1],[0 8; 0 8],[1 1; 1 1]);
% % view(3);
xlabel('x');
ylabel('y');
zlabel('z');

% --------------------------------------------------------------
% α���
y = 0;

end