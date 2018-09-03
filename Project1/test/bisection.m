function [c, iter] = bisection (a, w, r)

%     function result = cal(input)
%         order = size(w,2); %
%         result = 0;
%         for n = 1:order
%           result = result + w(n)*(input^(n-1));
%           n = n+1;
%         end
%         return
%     end
    b = a;
    while polyval(w,a)*polyval(w,b) > 0
        r_number = complex(sqrt(r)*randn(1), sqrt(r)*rand(1));
        b = a+r_number;
        if polyval(w,a)*polyval(w,b) < 0
            break;
        end
    end
    
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


