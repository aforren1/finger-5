% draw a normalized [0, 1] bezier curve
% resolution must be (0, 1)
% P0 - 3 must be 1x2 matrices
function [x, y] = Bezier2D(resolution, P0, P1, P2, P3)

    t = (0:resolution:1)';
    u = 1 - t;
    out = u.^3 .*P0;
    out = out + u.^2 .* t .* P1;
    out = out + u .* t.^2 .* P2;
    out = out + t.^3 .* P3;
    x = out(:, 1);
    y = out(:, 2);
end
