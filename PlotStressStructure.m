function [] = PlotStressStructure(spoke, glob_coord, s_xx, s_yy, nodemap);

X = glob_coord(1,:);
Y = glob_coord(2,:);

% Initial Scatter Plot of Each Point
figure('Name', 'Plot of Stress xx')
hold on
for ii = 1:length(nodemap)
    enodes = nodemap(ii, :);
    if enodes(end) == 0
        enodes = enodes(1:end-1);
    end
    for jj = 2:length(enodes)
        X_vec = [X(enodes(jj-1)), X(enodes(jj))];
        Y_vec = [Y(enodes(jj-1)), Y(enodes(jj))];
               
        plot(X_vec, Y_vec, 'k', 'LineWidth', 1.25)       
    end
end
scatter(X, Y, 250, s_xx, 'filled')
c = colorbar;
c.Label.String = 'Stress [Pa]';
grid
title('Plot of Stress at Wheel Nodes [\sigma_{xx}]')
xlabel('X Position [m]')
ylabel('Y Position [m]')
axis image
hold off

figure('Name', 'Plot of Stress yy')
hold on
for ii = 1:length(nodemap)
    enodes = nodemap(ii, :);
    if enodes(end) == 0
        enodes = enodes(1:end-1);
    end
    for jj = 2:length(enodes)
        X_vec = [X(enodes(jj-1)), X(enodes(jj))];
        Y_vec = [Y(enodes(jj-1)), Y(enodes(jj))];
               
        plot(X_vec, Y_vec, 'k', 'LineWidth', 1.25)       
    end
end
scatter(X, Y, 250, s_yy, 'filled')
c = colorbar;
c.Label.String = 'Stress [Pa]';
grid
title('Plot of Stress at Wheel Nodes [\sigma_{yy}]')
xlabel('X Position [m]')
ylabel('Y Position [m]')
axis image
hold off

