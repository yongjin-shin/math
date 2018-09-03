%% PROJECT2: GENERATE CUBIC SPLINE
% YONGJIN SHIN, 20090488, IME

%% Solver function calls several functions
% to generate cubic splin with given dataset
% 1)cspline: find S's coefficients
% 2)csplin_eval: return estimated y-value by cubic spline
solver(1);
solver(2);

%% SOLVER
% input: problem type (1:clamped/ 2:natural)
% output: (Printing images and tables)
function s = solver(prob)

    % given dataset
    x1 = [1,2,5,6,7,8,10,13,17];
    y1 = [3.0, 3.7, 3.9, 4.2, 5.7, 6.6, 7.1, 6.7, 4.5];
    f1 = [1.0, -0.67];

    x2 = [17,20,23,24,25,27,27.7];
    y2 =[4.5, 7.0, 6.1, 5.6, 5.8, 5.2, 4.1];
    f2 = [3.0, -4.0];

    x3 = [27.7,28,29,30];
    y3 = [4.1, 4.3, 4.1, 3.0];
    f3 = [0.33, -1.5];

    % call cubic function to get coefficients
    [a1, b1, c1, d1] = cspline(x1, y1, f1, prob);
    [a2, b2, c2, d2] = cspline(x2, y2, f2, prob);
    [a3, b3, c3, d3] = cspline(x3, y3, f3, prob);

    p_size = 1200; p = linspace(1, 30, p_size); % generate 600 points
    s = zeros(p_size,1); % will stack the estimated y-values from spline

    for i=1:p_size
        if p(i) <= 17
            s(i) = csplin_eval(a1, b1, c1, d1, x1, p(i));
        elseif (17 < p(i)) && (p(i) <=27.7)
            s(i) = csplin_eval(a2, b2, c2, d2, x2, p(i));
        else
            s(i) = csplin_eval(a3, b3, c3, d3, x3, p(i));
        end
    end

    % draw spline in the graph
    figure
    scatter(x1,y1); hold on
    scatter(x2,y2); hold on
    scatter(x3,y3); hold on
    plot(p,s, '.')
end

%% Find Estimated Y-values
% input: a,b,c,d(coefficients, the result of 'cubic'), x(data), given x values
% output: estimated y-values of given x values according to spline
function s = csplin_eval(a, b, c, d, x, given_x)
    n = length(x);
    
    % find where the given x value is located in
    for i = n-1:-1:1
        if(given_x - x(i)) >= 0
            break
        end
    end
    
    % Plug in the given x into cubic splin
    s = a(i)+b(i)*(given_x-x(i))+c(i)*(given_x-x(i))^2+d(i)*(given_x-x(i))^3;
    return
end

%% Find coefficients of 2nd derivatives of cubic spline
% input: x,y(given dataset), 1st derivative values for (prob=1)
% output: coefficients a,b,c,d
function [a,b,c,d] = cspline(x, y, f, prob)
    n = length(x);
    h = x(2:n) - x(1:n-1); % stepsize
    
    A = eye(n,n);
    for i = 1:n-1
        A(i,i+1) = h(i);
        if(i ~= 1)
            A(i,i) = 2 * (A(i, i-1) + A(i, i+1));
        end
        A(i+1,i) = h(i);
    end
    b = (3*(y(3:n)-y(2:n-1))./h(2:n-1)-3*(y(2:n-1)-y(1:n-2))./h(1:n-2));
    
    if prob == 1 %clamped cubic
        b = [3*(y(2)-y(1))/h(1)-3*f(1), b, 3*f(2)-3*(y(n)-y(n-1))/h(n-1)];
        A(1,1) = 2*h(1);
        A(n,n) = 2*h(n-1);
    else %natural cubic
        b = [0,b,0]; %add zeors (since Z0 = Zn = 0)
        A(1, 2) = 0;
        A(n, n-1) = 0;
    end
            
    h = h';
    c = A\b';
    a = y';
    b = (a(2:n)-a(1:n-1))./h(1:n-1) - h(1:n-1).*(c(2:n) + 2*c(1:n-1))/3;
    d = (c(2:n) - c(1:n-1))./(3*h(1:n-1));
    return
end