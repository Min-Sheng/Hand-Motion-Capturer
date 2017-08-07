%% Plot the Cylinder to Represent the DOF (Parameters: Position ( P ), Attitude Matrix ( R ) )
function DrawCylinder(P, R)
    r=0.2;                                   % Cylinder's radius
    n=50;                                    % Dividing line number
    [x,y,z]=cylinder(r,n);                   % Construct a Cylinder whose center of circle is (0,0), height is [0,1], and radius is R
    z=[z(1,:)-0.5;z(2,:)-0.5];               % Cylinder's height
    % Do the projection and translation to the cylinder
    for k=1:n+1
        xx1 = R(1,1)*x(1,k)+R(1,2)*y(1,k)+R(1,3)*z(1,k)+P(1);
        yy1 = R(2,1)*x(1,k)+R(2,2)*y(1,k)+R(2,3)*z(1,k)+P(2);
        zz1 = R(3,1)*x(1,k)+R(3,2)*y(1,k)+R(3,3)*z(1,k)+P(3);
        xx2 = R(1,1)*x(2,k)+R(1,2)*y(2,k)+R(1,3)*z(2,k)+P(1);
        yy2 = R(2,1)*x(2,k)+R(2,2)*y(2,k)+R(2,3)*z(2,k)+P(2);
        zz2 = R(3,1)*x(2,k)+R(3,2)*y(2,k)+R(3,3)*z(2,k)+P(3);
        x(1,k) =  xx1; x(2,k) =  xx2;
        y(1,k) =  zz1; y(2,k) =  zz2;
        z(1,k) =  yy1; z(2,k) =  yy2;
    end
    % The data about the round side of the cylinder
    z2=[z(1,:);z;z(2,:)];
    x2=[x(1,:);x;x(2,:)];
    y2=[y(1,:);y;y(2,:)];
    % The data about the bottom side of the cylinder
    z3=[z(1,:);z(1,:)];
    x3=[x(1,:);x(1,:)];
    y3=[y(1,:);y(1,:)];
    % The data about the top side of the cylinder
    z4=[z(2,:);z(2,:)];
    x4=[x(2,:);x(2,:)];
    y4=[y(2,:);y(2,:)];
    
    surf(x2,z2,y2,'LineStyle','none')
    map=jet(16);
    cl=5;                              % Can set 16 kinds of colors (1-16)
    colormap(map(cl,:))
    hold on
    surf(x3,z3,y3);
    hold on
    surf(x4,z4,y4);
    hold on
end
