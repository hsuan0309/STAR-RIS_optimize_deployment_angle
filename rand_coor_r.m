function [x, y] = rand_coor_r(cx, cy, r)
    theta = pi + rand() * pi;
    x = cx + r * cos(theta);
    y = cy + r * sin(theta);
end
