function create_2D_snapshot (rmatrix,rc,L)
    type=rmatrix(:,1);
    cells=rmatrix (type==1,:);
    %gels=rmatrix (type==0,:);
    hold on;
    for (i=1:size (cells,1))
        rectangle('Position', [cells(i,2)-rc, cells(i,3)-rc, 2*rc, 2*rc], ...
                 'Curvature', [1, 1], 'EdgeColor', [0, 0.6, 0], 'FaceColor', [0 0.5 0]);
    end
    hold off;
    axis equal;
    xlim ([-L/2-0.5 L/2+0.5]);
    ylim ([-L/2-0.5 L/2+0.5]);
    axis off;
end