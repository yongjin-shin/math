w1 = [16 -40 5 20 6];
w2 = [1 -5.4 10.56 -8.954 2.7951];
w3 = [1 -16 129 -652 2241 -5320 8543 -8508 4158];
w4 = [1 -16 123 -580 1825 -3912 5593 -4900 2058];
w0 = [1 0 2];

solver(w0);
solver(w1);
solver(w2);
solver(w3);
solver(w4);

%%
% "solver" solve roots of given polynomials and print its roots with "printer" function
% Implement "bisection", "newton's method", "horner's method"

function [p, refinement] = solver(w)
    w_origin = w;
    num = size(w,2)-1;
    p = zeros(num, 1); %stack roots without refinement
    n=1;
    while n <= num
        r = findradius(w); 
        s = complex(r,r); %set inital point around radius r(1+i)
        c = bisection(s,w,r);
        p(n) = newtons(c, w);    
        w = horners(p(n), w);
        n = n+1;
    end
    
    n=1;
    w = w_origin;
    refinement = zeros(num, 1); %stack roots after refinement
    while n <= num
        c = p(n);
        refinement(n) = newtons(c, w);    
        w = horners(p(n), w);
        n = n+1;
    end    
    
    printer(w_origin,p,refinement)
end

%%
function TT = printer(w, p, r)
    root_ = 1:size(w,2)-1;
    poly2sym(w)
    TT = table(root_', sort(p), sort(r), sort(roots(w)), 'VariableNames',{'roots', 'Pi', 'Ri', 'Builtin'});
    return
end

%%
function r = findradius(w)
    r = sum(abs(w./w(1)),2);
    return
end

%%
% input= a:initial point, w:coefficients, r:radius
% output= c:approximated point, iter: the number of iteration
function [c, iter] = bisection (a, w, r)
    b = a;
    t = 0;
    
    % guess how big r is
    while 10^t < a
        t = t+1;
    end
    
    % find differnt point from the starting
    % to let producution of their value be under zero
    % with adding random number into starting point
    while polyval(w,a)*polyval(w,b) > 0
        r_number = complex(sqrt(r)*(-1*10^t)*randn(1), sqrt(r)*(-1*10^t)*rand(1));
        b = a+r_number;
        if polyval(w,a)*polyval(w,b) < 0
            break;
        end
    end
    
    % bisection method
    % set threshold: 0.00001
    c = (a+b)/2;
    c_value = polyval(w, c);
    iter = 0;
    
    while abs(b-a) > 10^(-5)
        iter = iter+1;
        if c_value == 0
          return
        elseif polyval(w, a)*c_value < 0
          b = c;
        else
          a = c;
        end
        c = (a+b)/2;
        c_value = polyval(w, c);
    end
    
    return
end

%%
% input= s:initial point, w:coefficients
% output= nth root
function x_n = newtons(s, w)
    thres = 10^(-8); %given threshold
    
    x_n_1 = s;
    w_ = horners(x_n_1, w); %first derivative of w with using horner's
    x_n = x_n_1 - (polyval(w, x_n_1)/polyval(w_,x_n_1));
    diff = abs((x_n - x_n_1)/x_n);
    x_n_1 = x_n;
    while diff > thres
        w_ = horners(x_n_1, w);
        x_n = x_n_1 - (polyval(w, x_n_1)/polyval(w_,x_n_1));
        diff = abs((x_n-x_n_1)/x_n);
        x_n_1 = x_n;
    end  
    return 
end

%%
% input= alpha:root, a:coefficients
% output= new coefficients
function [b, c] = horners(alpha, a)
    high = size(a,2);
    b(high-1) = 0;
    n = 1;
    while n < high
        b(n) = a(n);
        if n ~= 1
            b(n) = b(n) + b(n-1)*alpha;
        end
        n = n+1;
    end
    c = a(high)+b(high-1)*alpha;
end
