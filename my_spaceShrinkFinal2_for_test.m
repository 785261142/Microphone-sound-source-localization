function c = my_spaceShrinkFinal2_for_test(a, b, gcc_all, mic, v, fs)
% ����������ʵ�ֿ�������������������ǽǶȣ�
% ����ı�һ�ַ�ʽֱ�ӶԾ���������ɨ��
% ���ַ�ʽ���Ǽ��η���������ǿ��ɨ�裬���ǲ��ã���ʱ����һ����ֵ����
% ���������һ�����԰�
% ���룺ԭʼ�߽磬�ֱ���
% ��������Ƴ�����Դλ��

% --------------------------------------------------------------
% ��ʼ��
frameLen = (size(gcc_all,2)+1)/2;  % ֡��
index_theta = a(2,1):b(2):a(2,2);  % ������
index_phi = a(3,1):b(3):a(3,2);    % ��λ��
index_r = a(1,1):b(1):a(1,2);      % ��
delaycac_obj = [6.02;21.05;17.65;15.47;12.7;-3.89]; % �ο���׼ȷʱ�ӣ������Ҫ����������ͬʱ����

% --------------------------------------------------------------
% �����������
num_r = length(index_r);           % �����С
num_theta = length(index_theta);   % �����Ǵ�С
num_phi = length(index_phi);       % ��λ�Ǵ�С
num_all = num_theta*num_phi*num_r; % ȫ���������С

% --------------------------------------------------------------
% ֱ�Ӽ�����ά����
number_srpfinal = 0;          % ��ʾ�Ѿ���ɵĸ���
srpfinal = zeros(num_all,6);  % ����洢����
number_srpfinal_r = 0;        % ��ʾ�Ѿ����r�ĸ���
srpfinal_r = zeros(num_r,2);  % �Ծ���ά�ȵĴ洢����
for r = index_r
    cac_r = 0;
    for theta = index_theta
        for phi = index_phi
            % ��ʼ��
            obj = my_rthetaToXYZ(r,theta,phi);
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
            % �������
            error_cac = sum((delaycac-delaycac_obj).^2);
            [y1,y2] = my_varBetweenSevenPoints(obj,mic,0.05);
            number_srpfinal = number_srpfinal+1;
            srpfinal(number_srpfinal,1:6) = [r,theta,phi,error_cac,y1,y2];
            % ��r���л���
            cac_r = cac_r+error_cac;
        end
    end
    % ����
    number_srpfinal_r = number_srpfinal_r+1; % ��ʾ�Ѿ����r�ĸ���
    srpfinal_r(number_srpfinal_r,1:2) = [r,cac_r];
end

% --------------------------------------------------------------
% �������������ľ�������
srpfinal_r = sortrows(srpfinal_r,2);
output_r = mean(srpfinal_r(1:10,1));

% �������������ĽǶ�����
srpfinal = sortrows(srpfinal,4);
output_theta = mean(srpfinal(1:100,2));
output_phi = mean(srpfinal(1:100,3));

% --------------------------------------------------------------
% ������
c = [output_r,output_theta,output_phi];

end