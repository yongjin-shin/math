%% project3
% YONJIN SHIN 20090488
clear
digits(64)

%% MAIN
% Given Conditions

c.init = 0; c.last = 10; c.thres = 10^(-15);
%c.init = 2^(-10);c.last = 1;c.thres = 10^(-5);

[my_result, lv, points] = adaptive_simpson(c, 0);
print_result(my_result, c, points);

%% Given function
function y = given_fun(x)
    y = 2/pi*(exp(-x^2));
    %y = sin(x^(-1));
    return
end

%% get result
% Compare with builtin function
% and print bar plot
function [] = print_result(my_result, c, points)
    fun = @(x) 2/pi*(exp(-x.^2));
    %fun = @(x) sin(x.^(-1));
    builtin_result = integral(fun,c.init,c.last);

    % print result
    format long
    my_result
    builtin_result
    diff = abs(my_result - builtin_result)
    
    % print bar plot
    draw_bar(unique(points), c);
    
    % draw bar plot function
    % points: list of nodal points
    % c: inital points for setting axes
    function [] = draw_bar(points, c)
        points = points(1:100:end);
        num = size(points)
        ystart = ones(num); ystart = ystart*0.2;
        yend = ones(num); yend = yend*(-0.2);
        
        fig = figure; hold on;
        axis([c.init-0.1 c.last+0.1 -1 1])
        for idx = 1 : num(2)
            plot([points(idx) points(idx)], [ystart(idx) yend(idx)]);
        end
    end

    fplot(fun, [c.init-0.1, c.last+0.1])
    hline = refline([0 0])

end

%% adaptive_simpson's
% using recursive function
% c: inital points
% lv: inital level
% x: list of nodal points
% result: integral result to be returned
function [result, lv, x] = adaptive_simpson(c, lv, x)
    
    % when there's infinite loop
    % exit with error msg
    if lv == 10^4
        msg = 'Out of Memory';
        error(msg)
    end
    
    % x is a container to collect nodal points
    if nargin <3
        x = [];
    end
    
    % simpson's method
    h = (c.last-c.init)/2;
    S = h/3 * (given_fun(c.init) + 4 * given_fun(c.init+h) + given_fun(c.last));
    [s, x_] = composite(c, h);
    x = [x, x_];
    lv = lv+1;
    
    % compare difference
    % if below conditions, then return it
    % otherwise call simpson's method for left, right intervals
    tmp = abs(S-s); threshold = 15*c.thres;
    if(tmp < 15*c.thres)
        result = s;
    else
        d.init = c.init; d.last = c.init+h; d.thres = c.thres/2;
        e.init = c.init+h; e.last = c.last; e.thres = c.thres/2;
        [tmp_result1, lv1, x1] = adaptive_simpson(d, lv);
        [tmp_result2, lv2, x2] = adaptive_simpson(e, lv);
        result = tmp_result1 + tmp_result2;
        lv = max(lv1, lv2);
        x = [x1, x2];
    end
        
    % composite simpson's
    % c: initial points
    % h: step size
    % t: integral result to be returned
    % tt: nodal points
    function [t, tt] = composite(c, h)
        s1 = h/6*(given_fun(c.init) + 4 * given_fun(c.init+h/2) + given_fun(c.init+h));
        s2 = h/6*(given_fun(c.init+h) + 4 * given_fun(c.init+h*3/2) + given_fun(c.last));
        
        t = s1+s2;
        tt = [c.init, c.init+h/2, c.init+h, c.init+h*3/2, c.last];
        return
    end
    
    return
end

