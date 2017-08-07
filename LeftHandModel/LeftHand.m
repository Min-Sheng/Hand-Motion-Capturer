function [W,H,coordinate_num]= LeftHand(theta)
%% Parameters Setting
HL = 18;                                                                   % Length of the hand
HB = 8;                                                                    % Width of the hand
li = [0.251*HL, 0.196*HL, 0.158*HL];
lii = [sqrt((0.374*HL)^2+(0.126*HB)^2), 0.265*HL, 0.143*HL, 0.097*HL];     % Length of the finger sections
liii = [0.373*HL, 0.277*HL, 0.170*HL, 0.108*HL];
liv = [sqrt((0.336*HL)^2+(0.077*HB)^2), 0.259*HL, 0.165*HL, 0.107*HL];
lv = [sqrt((0.295*HL)^2+(0.179*HB)^2), 0.206*HL, 0.117*HL, 0.093*HL];
joint_size = [5 4 4 4 4];                                                  % Number of the joints ( 6~9 )
coordinate_num=joint_size+1;                                               % Number of the coordinations
%% DH Parameters
a = {[0 li(1) 0 li(2) li(3)]; [0 lii]; [0 liii]; [0 liv]; [0 lv]};                                                 % link length
alpha = {[-pi/2, pi/2, -pi/2, pi/2, -pi/2];[-pi/2, 0, 0, 0];[-pi/2, 0, 0, 0];[-pi/2, 0, 0, 0];[-pi/2, 0, 0, 0]};   % link twist¡] radian )
d = {[0, 0, 0, 0, 0];[0, 0, 0, 0];[0, 0, 0, 0];[0, 0, 0, 0];[0, 0, 0, 0]};                                         % link offset
%% The Relative Position w.r.t the Global Coordinate System Original
loo=[-13, -6, -6, -6.5, -7];
gamma=deg2rad([-5, 7, 13, 20, 25]);
%% Define the Cell to Store the Transform Matrices, the Rotation Matrices, and the Positon Vecters
for i=1:5
    T{i} = cell(coordinate_num(i),1);       % The transform matrices
    R{i} = cell(coordinate_num(i),1);       % The rotation matrices w.r.t the local system
    P{i} = cell(coordinate_num(i),1);       % The position vecters w.r.t the local system
    G{i} = cell(coordinate_num(i),1);       % The projection matrices that translate from the local system to the global system
    H{i} = cell(coordinate_num(i),1);       % The rotation matrices w.r.t the global system
    W{i} = cell(coordinate_num(i),1);       % The position vecters w.r.t the global system
end
%% Define the Base Coordinations
for i=1:5
    T{i}{1} = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]; 
    P{i}{1} = T{i}{1}(1:3, 4);
    R{i}{1} = T{i}{1}(1:3, 1:3);
    G{i}{1} = GB(gamma(i),loo(i))*T{i}{1};
    W{i}{1} = G{i}{1}(1:3, 4);
    H{i}{1} = G{i}{1}(1:3, 1:3);
end
%% Iteratively Calculate the Transform Matrices of Each Joints
for i=1:5
    for k=2:coordinate_num(i)
        T{i}{k} = T{i}{k-1}*DH(a{i}(k-1), alpha{i}(k-1), d{i}(k-1), theta{i}(k-1));
        G{i}{k} = GB(gamma(i),loo(i))*T{i}{k};
        W{i}{k} = G{i}{k}(1:3, 4);
        H{i}{k} = G{i}{k}(1:3, 1:3);
        P{i}{k} = T{i}{k}(1:3, 4);
        R{i}{k} = T{i}{k}(1:3, 1:3);
    end
end
end

