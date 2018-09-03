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