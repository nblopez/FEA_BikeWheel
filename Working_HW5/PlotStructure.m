function [] = PlotStructure(X, Y, U, nodemap)
% Scale deformation to set Max deflection to 1mm equiv
scale_val = 1 / max(abs(U(1:2:end)));
X_def = X' + U(1:2:end) .* scale_val;
Y_def = Y' + U(2:2:end) .* scale_val;

% Initial Scatter Plot of Each Point
figure('Name', 'Plot of Deformed Structure')
hold on
% fprintf('\nPlotting Node Deformations\n')
for ii = 1:length(nodemap)
    enodes = nodemap(ii, :);
    enodes = [enodes(end), enodes]; %Put end of enodes at beginning
    for jj = 2:length(enodes)
        X_vec = [X(enodes(jj-1)), X(enodes(jj))];
        Y_vec = [Y(enodes(jj-1)), Y(enodes(jj))];
        
        Xdef_vec = [X_def(enodes(jj-1)), X_def(enodes(jj))];
        Ydef_vec = [Y_def(enodes(jj-1)), Y_def(enodes(jj))];
        
        plot(X_vec, Y_vec, 'k', 'LineWidth', 1.25)
        plot(Xdef_vec, Ydef_vec, 'b--', 'LineWidth', 2)
%         fprintf('Plot Element %d; Nodes: %d, %d\n',...
%             ii, enodes(jj-1), enodes(jj))
    end
    mean_x = mean(X_def(enodes(2:end)));
    mean_y = mean(Y_def(enodes(2:end)));
    text(mean_x, mean_y, cellstr(['Element ',num2str(ii)]), 'Color',...
        'white','BackgroundColor', 'blue')
end
scatter(X, Y, 250, 'r.')
scatter(X_def, Y_def, 25, 'b', 'Filled')

dx = 0;
dy = 0.2;
text(X+dx, Y+dy, cellstr(num2str([1:length(X)]')),...
    'Color', 'white','BackgroundColor', 'black');

grid;
legend('Original', 'Deformed', 'location', 'best')

xlabel('X Position [mm]')
ylabel('Y Position [mm]')
title(['Original vs. Deformed Structure [Scaled by ',...
    num2str(scale_val, '%.2e'),' mm/mm]'])
axis image
hold off