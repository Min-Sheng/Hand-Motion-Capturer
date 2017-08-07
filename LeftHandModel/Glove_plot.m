clf
close all
clear all
clc
%% Set the Serial Port
COM_Port='COM6';
s = serial(COM_Port);
if(isvalid(s))
    %Clean up and shut it down
    fclose (s);
    delete (s);
    clear s;
end
delete(instrfindall);
InputBuffer_Size = 500;
s = serial(COM_Port);
% s = Bluetooth('H-C-2010-06-01',1);
set(s,'BaudRate',115200);
set(s,'InputBufferSize',InputBuffer_Size);
% set(s, 'Timeout', 2);
fopen(s);
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
%% Parameters Initialization
imu=10;
t_pre=0;
count=1;
duration=3600;
number=1;
store_limit=5;
plot_interval=0.05;
y=[0,0,0,0,0,0,0,0,0,0];
p=[0,0,0,0,0,0,0,0,0,0];
r=[0,0,0,0,0,0,0,0,0,0];
time=[0,0,0,0,0,0,0,0,0,0];
data=[ ];
first=1;
%% First Time Read
while(isempty(data))
    buffer = fscanf(s,'%c',InputBuffer_Size);
    data=str2num(buffer);
end
if(length(data)==5)
    i=data(:,1)+1;
    y(1,i)=data(:,2);
    p(1,i)=data(:,3);
    r(1,i)=data(:,4);
    t0=data(:,5);
    time(1,i)=0;
end
%% Read until Full IMU Data
while(count<imu)
     buffer = fscanf(s,'%c',InputBuffer_Size);
     data=str2num(buffer);
     if(length(data)==5)
         i=data(:,1)+1;
         y(end,i)=data(:,2);
         p(end,i)=data(:,3);
         r(end,i)=data(:,4);
         t=data(:,5)-t0;
        time(end,i)=t;
        count=count+1;
     end
end
P_0= [y(1,1), p(1,1), r(1,1)];
T3_0=[y(1,2), p(1,2), r(1,2)];
T2_0=[y(1,3), p(1,3), r(1,3)];
T1_0=[y(1,4), p(1,4), r(1,4)];
I3_0=[y(1,5), p(1,5), r(1,5)];
I2_0=[y(1,6), p(1,6), r(1,6)];
I1_0=[y(1,7), p(1,7), r(1,7)];
M3_0=[y(1,8), p(1,8), r(1,8)];
M2_0=[y(1,9), p(1,9), r(1,9)];
M1_0=[y(1,10), p(1,10), r(1,10)];
count=0;
while(number<=store_limit-1)
     buffer = fscanf(s,'%c',InputBuffer_Size);
     data=str2num(buffer);
     if(length(data)==5)
     i=data(:,1)+1;
        if(count<imu)
             y(end,i)=data(:,2);
             p(end,i)=data(:,3);
             r(end,i)=data(:,4);
             t=data(:,5)-t0;
             time(end,i)=t;
             count=count+1;
        else
             count=0;
             y=[y;zeros(1,10)];
             p=[p;zeros(1,10)];
             r=[r;zeros(1,10)];
             time=[time;zeros(1,10)];
             y(end,i)=data(:,2);
             p(end,i)=data(:,3);
             r(end,i)=data(:,4);
             t=data(:,5)-t0;
             time(end,i)=t;
             number=number+1;
        end
    end
end
count=0;
%% Read
while(t<duration)
    cla
    %% Capture the Angle Data of Joints
    buffer = fscanf(s,'%c',InputBuffer_Size);
    data=str2num(buffer);
    if(length(data)==5)
        i=data(:,1)+1;
        if(count<imu)
             y(end,i)=data(:,2);
             p(end,i)=data(:,3);
             r(end,i)=data(:,4);
             t=data(:,5)-t0;
             time(end,i)=t;
             count=count+1;
        else
             count=0;
             y(1:store_limit,1:10)=[y(2:store_limit,1:10);zeros(1,10)];
             p(1:store_limit,1:10)=[p(2:store_limit,1:10);zeros(1,10)];
             r(1:store_limit,1:10)=[r(2:store_limit,1:10);zeros(1,10)];
             time(1:store_limit,1:10)=[time(2:store_limit,1:10);zeros(1,10)];
             y(end,i)=data(:,2);
             p(end,i)=data(:,3);
             r(end,i)=data(:,4);
             t=data(:,5)-t0;
             time(end,i)=t;
             number=number+1;
%              P= [y(1,1), p(1,1), r(1,1)]-P_0;
%              T3=[y(1,2), p(1,2), r(1,2)]-T3_0;
%              T2=[y(1,3), p(1,3), r(1,3)]-T2_0;
%              T1=[y(1,4), p(1,4), r(1,4)]-T1_0;
%              I3=[y(1,5), p(1,5), r(1,5)]-I3_0;
%              I2=[y(1,6), p(1,6), r(1,6)]-I2_0;
%              I1=[y(1,7), p(1,7), r(1,7)]-I1_0;
%              M3=[y(1,8), p(1,8), r(1,8)]-M3_0;
%              M2=[y(1,9), p(1,9), r(1,9)]-M2_0;
%              M1=[y(1,10), p(1,10), r(1,10)]-M1_0;
%              qT=[JointAngle(T3(3), P(3)), JointAngle(T3(1), P(1)), JointAngle(T2(3), T3(3)), JointAngle(T2(1), T3(1)), JointAngle(T1(3), T2(3))];
%              qI=[JointAngle(I3(1), P(1)), JointAngle(I3(3), P(3)), JointAngle(I2(3), I3(3)), JointAngle(I1(3), I2(3))];
%              qM=[JointAngle(M3(1), P(1)), JointAngle(M3(3), P(3)), JointAngle(M2(3), M3(3)), JointAngle(M1(3), M2(3))];
%              %% Angles of Joints
%              theta = {[90,  -qT(2), -qT(3), -qT(4), -qT(5)];[90, 0, -qI(3), -qI(4)];[90, 0, -qM(3), -qM(4)];[90,60, 120, 80];[90,60, 120, 80]};                                % joint angle ( degree )
% %             theta = {[90-qT(1), -qT(2), -qT(3), qT(4), -qT(5)];[90+qI(1), -qI(2), -qI(3), -qI(4)];[90+qM(1), -qM(2), -qM(3), -qM(4)];[90,60, 120, 80];[90,60, 120, 80]};                                % joint angle ( degree )
%              theta=cellfun(@deg2rad,theta,'UniformOutput',false);
%              %% Calculate the Model
%              [W,H,coordinate_num]=LeftHand(theta); %W: the position vecter w.r.t global system; H: the rotation matrix w.r.t global system
             %% First Plot
             if(t_pre==0&&first==1)
             P= [y(1,1), p(1,1), r(1,1)]-P_0;
             T3=[y(1,2), p(1,2), r(1,2)]-T3_0;
             T2=[y(1,3), p(1,3), r(1,3)]-T2_0;
             T1=[y(1,4), p(1,4), r(1,4)]-T1_0;
             I3=[y(1,5), p(1,5), r(1,5)]-I3_0;
             I2=[y(1,6), p(1,6), r(1,6)]-I2_0;
             I1=[y(1,7), p(1,7), r(1,7)]-I1_0;
             M3=[y(1,8), p(1,8), r(1,8)]-M3_0;
             M2=[y(1,9), p(1,9), r(1,9)]-M2_0;
             M1=[y(1,10), p(1,10), r(1,10)]-M1_0;
             qT=[JointAngle(T3(3), P(3)), JointAngle(T3(1), P(1)), JointAngle(T2(3), T3(3)), JointAngle(T2(1), T3(1)), JointAngle(T1(3), T2(3))];
             qI=[JointAngle(I3(1), P(1)), JointAngle(I3(3), P(3)), JointAngle(I2(3), I3(3)), JointAngle(I1(3), I2(3))];
             qM=[JointAngle(M3(1), P(1)), JointAngle(M3(3), P(3)), JointAngle(M2(3), M3(3)), JointAngle(M1(3), M2(3))];
             %% Angles of Joints
             theta = {[90,  -qT(2), -qT(3), -qT(4), -qT(5)];[90, 0, -qI(3), -qI(4)];[90, 0, -qM(3), -qM(4)];[90,60, 120, 80];[90,60, 120, 80]};                                % joint angle ( degree )
%              theta = {[90-qT(1), -qT(2), -qT(3), qT(4), -qT(5)];[90+qI(1), -qI(2), -qI(3), -qI(4)];[90+qM(1), -qM(2), -qM(3), -qM(4)];[90,60, 120, 80];[90,60, 120, 80]};                                % joint angle ( degree )
             theta=cellfun(@deg2rad,theta,'UniformOutput',false);
             %% Calculate the Model
             [W,H,coordinate_num]=LeftHand(theta); %W: the position vecter w.r.t global system; H: the rotation matrix w.r.t global system
                 t_pre=t;
                 first=0;
                 for i=1:5
                     for k=2:coordinate_num(i)
                         DrawLine(W{i}{k-1}, W{i}{k});
                    end
                 end
                 drawnow
             end
             if(t-t_pre>plot_interval&&first==0)
                 %% Real-Time Plot
             P= [y(1,1), p(1,1), r(1,1)]-P_0;
             T3=[y(1,2), p(1,2), r(1,2)]-T3_0;
             T2=[y(1,3), p(1,3), r(1,3)]-T2_0;
             T1=[y(1,4), p(1,4), r(1,4)]-T1_0;
             I3=[y(1,5), p(1,5), r(1,5)]-I3_0;
             I2=[y(1,6), p(1,6), r(1,6)]-I2_0;
             I1=[y(1,7), p(1,7), r(1,7)]-I1_0;
             M3=[y(1,8), p(1,8), r(1,8)]-M3_0;
             M2=[y(1,9), p(1,9), r(1,9)]-M2_0;
             M1=[y(1,10), p(1,10), r(1,10)]-M1_0;
             qT=[JointAngle(T3(3), P(3)), JointAngle(T3(1), P(1)), JointAngle(T2(3), T3(3)), JointAngle(T2(1), T3(1)), JointAngle(T1(3), T2(3))];
             qI=[JointAngle(I3(1), P(1)), JointAngle(I3(3), P(3)), JointAngle(I2(3), I3(3)), JointAngle(I1(3), I2(3))];
             qM=[JointAngle(M3(1), P(1)), JointAngle(M3(3), P(3)), JointAngle(M2(3), M3(3)), JointAngle(M1(3), M2(3))];
             %% Angles of Joints
             theta = {[90,  -qT(2), -qT(3), -qT(4), -qT(5)];[90, 0, -qI(3), -qI(4)];[90, 0, -qM(3), -qM(4)];[90,60, 120, 80];[90,60, 120, 80]};                                % joint angle ( degree )
%              theta = {[90-qT(1), -qT(2), -qT(3), qT(4), -qT(5)];[90+qI(1), -qI(2), -qI(3), -qI(4)];[90+qM(1), -qM(2), -qM(3), -qM(4)];[90,60, 120, 80];[90,60, 120, 80]};                                % joint angle ( degree )
             theta=cellfun(@deg2rad,theta,'UniformOutput',false);
             %% Calculate the Model
             [W,H,coordinate_num]=LeftHand(theta); %W: the position vecter w.r.t global system; H: the rotation matrix w.r.t global system
                 t_pre=t;
                 for i=1:5
                     for k=2:coordinate_num(i)
                         DrawLine(W{i}{k-1}, W{i}{k});
                    end
                end
                drawnow
             end
        end
          t=t+1;
    end
end