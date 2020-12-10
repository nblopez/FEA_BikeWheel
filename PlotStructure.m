function [] = PlotStructure(spoke, glob_coord, U, nodemap)
labels_on = input('Would you like node numbering enabled? [y, n] ', 's');
plot_deformation = input('Would you like to plot the deformation? [y, n] ', 's');

X = glob_coord(1,:);
Y = glob_coord(2,:);
% Scale deformation to set Max deflection to 1mm equiv
% scale_val = 1e-3 / max(abs(U));
scale_val = max(abs(U)) / .005;
X_def = X' + U(1:2:end) .* 1/scale_val;
Y_def = Y' + U(2:2:end) .* 1/scale_val;

% Initial Scatter Plot of Each Point
figure('Name', 'Plot of Deformed Structure')
hold on
% fprintf('\nPlotting Node Deformations\n')
for ii = 1:length(nodemap)
    enodes = nodemap(ii, :);
    if enodes(end) == 0
        enodes = enodes(1:end-1);
    end
    %     enodes = [enodes(end), enodes]; %Put end of enodes at beginning
    for jj = 2:length(enodes)
        X_vec = [X(enodes(jj-1)), X(enodes(jj))];
        Y_vec = [Y(enodes(jj-1)), Y(enodes(jj))];
        
        Xdef_vec = [X_def(enodes(jj-1)), X_def(enodes(jj))];
        Ydef_vec = [Y_def(enodes(jj-1)), Y_def(enodes(jj))];
        
        plot(X_vec, Y_vec, 'k', 'LineWidth', 1.25)
        if strcmp(plot_deformation, 'y')
            plot(Xdef_vec, Ydef_vec, 'b--', 'LineWidth', 2)
            %                 fprintf('Plot Element %d; Nodes: %d, %d\n',...
            %                     ii, enodes(jj-1), enodes(jj))
        end
    end
    %     mean_x = mean(X_vec);
    %     mean_y = mean(Y_vec);
    %     text(mean_x, mean_y, cellstr(num2str(ii)), 'Color',...
    %         'white','BackgroundColor', 'blue')
end
scatter(X, Y, 250, 'r.')
if strcmp(plot_deformation, 'y')
    scatter(X_def, Y_def, 25, 'b', 'Filled')
end

dx = 0;
dy = 0;
if strcmp(labels_on, 'y')
    text(X+dx, Y+dy, cellstr(num2str([1:length(X)]')),...
        'Color', 'white','BackgroundColor', 'black');
end
grid;
legend('Original', 'Deformed', 'location', 'best')

xlabel('X Position [m]')
ylabel('Y Position [m]')
title(['Original vs. Deformed Structure [Scaled by ',...
    num2str(scale_val, '%.2e'),' m/m]'])
axis image
hold off
