function [x, y] = rand_coor_t(cx, cy, r)
    theta = rand() * pi;
    x = cx + r * cos(theta);
    y = cy + r * sin(theta);
end
