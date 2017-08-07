%% Plot the Local Coordinate System ( Parameters: Coordinate System Name ( name ), Coordinate System Position ( p ), Coordinate System Direction ( optimal, unit matrix by default ) )
function DrawCoordinate(name, p, varargin)
    % use p(x, y, z) as the original point, and R as the direction to plot the coordinate system
    R = [1 0 0; 0 1 0; 0 0 1];
    if numel(varargin) == 1
        R = varargin{1};
    end
    quiver3(p(1), p(2), p(3), R(1,1), R(2,1), R(3,1), 1);
    hold on;
    quiver3(p(1), p(2), p(3), R(1,2), R(2,2), R(3,2), 1);
    hold on;
    quiver3(p(1), p(2), p(3), R(1,3), R(2,3), R(3,3), 1);
    hold on;
    text(p(1), p(2), p(3), '');
    text(p(1)+R(1,1), p(2)+R(2,1), p(3)+R(3,1), ['x_', name]);
    text(p(1)+R(1,2), p(2)+R(2,2), p(3)+R(3,2), ['y_', name]);
    text(p(1)+R(1,3), p(2)+R(2,3), p(3)+R(3,3), ['z_', name]);
    hold on;
end

