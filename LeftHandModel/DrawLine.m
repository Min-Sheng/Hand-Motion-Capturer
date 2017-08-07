%% Plot the Straight Line (Parameters: Initial Point Vector ( p ), Ending Point Vector ( q ) )
function DrawLine(p, q , varargin)
    % use p(x, y, z) as the initial point, and q(x, y, z) as the ending point to plot the straight line
    marker='none';
    if numel(varargin) == 1
        marker=varargin{1};
    end
    plot3([p(1) q(1)], [p(2) q(2)], [p(3) q(3)], 'LineWidth', 14,'Marker',marker,'MarkerSize',52);
    hold on;
end