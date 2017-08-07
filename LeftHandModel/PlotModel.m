clf
close all
clear all
clc
%% Sketch Setting
figure('Name','Left Hand Model');
axis equal;                                  % Set the propotion of the axes are eual 
axis tight;
xlabel('X-axis(cm)');
ylabel('Y-axis(cm)');
zlabel('Z-axis(cm)');
% view(170,-90)
view(30,45)
grid
hold on
cla
%% Angles of Joints
theta = {[90+5, 10, 50, 0, 90];[90, 90, 145, 75];[90, 100, 145, 75];[90, 105, 145, 75];[90, 110, 145, 75]};                                % joint angle (degree )
theta=cellfun(@deg2rad,theta,'UniformOutput',false);
%% Calculate the Model
[W,H,coordinate_num]=LeftHand(theta); %W: the position vecter w.r.t global system; H: the rotation matrix w.r.t global system
%% Real-Time Plot
for i=1:5
%     DrawCoordinate([num2str(i),'_','-','_','0'], W{i}{1}, H{i}{1}*1.5);
    for k=2:coordinate_num(i)
        DrawLine(W{i}{k-1}, W{i}{k},'.');
    end
    if(i==2)
        DrawLine(W{i-1}{3}, W{i}{2});
    elseif(i>2)
        DrawLine(W{i-1}{2}, W{i}{2});
    end

%         DrawCylinder(W{i}{k-1}, H{i}{k-1});
%         DrawCoordinate([num2str(i),'_','-','_','0'+k-1], W{i}{k}, H{i}{k});
end
% %% Angles of Joints
% theta = {[90, 30, 45, 15, 90];[90-5, -5, 0, -1];[90, 0, 0, -1];[90,30, 150, 60];[90, 30, 150, 60]};                                % joint angle (degree )
% theta=cellfun(@deg2rad,theta,'UniformOutput',false);
% %% Calculate the Model
% [W,H,coordinate_num]=LeftHand(theta); %W: the position vecter w.r.t global system; H: the rotation matrix w.r.t global system
% %% Real-Time Plot
% for i=1:5
% %     DrawCoordinate([num2str(i),'_','-','_','0'], W{i}{1}, H{i}{1}*1.5);
%     for k=2:coordinate_num(i)
%         DrawLine(W{i}{k-1}, W{i}{k},'.');
%     if(i==2)
%         DrawLine(W{i-1}{3}, W{i}{2});
%     elseif(i>2)
%         DrawLine(W{i-1}{2}, W{i}{2});
%     end
% %         DrawCylinder(W{i}{k-1}, H{i}{k-1});
% %         DrawCoordinate([num2str(i),'_','-','_','0'+k-1], W{i}{k}, H{i}{k});
%     end
% end
% x=0;
% y=0;
% while(1)
%     cla
%     if(x==0)
%         x=x+1;
%         y=0;
%     elseif(x==60)
%         x=x-1;
%         y=1;
%     elseif(y==0) 
%         x=x+1;
%     elseif(y==1) 
%         x=x-1;
%     end
%     %% Angles of Joints
%     theta = {[90, x, x, x, x];[90, x, x, x];[90, x, x, x];[90, x, x, x];[90, x, x, x]};                                % joint angle ( degree )
%     theta=cellfun(@deg2rad,theta,'UniformOutput',false);
%     %% Calculate the Model
%     [W,H,coordinate_num]=LeftHand(theta); %W: the position vecter w.r.t global system; H: the rotation matrix w.r.t global system
%     %% Real-Time Plot
%     for i=1:5
%         for k=2:coordinate_num(i)
%             DrawLine(W{i}{k-1}, W{i}{k},'.');
%         end
%         if(i==2)
%             DrawLine(W{i-1}{3}, W{i}{2});
%         elseif(i>2)
%             DrawLine(W{i-1}{2}, W{i}{2});
%         end
%     end
%     drawnow
% end