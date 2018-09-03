function x_n = newtons(s, w)
    thres = 10^(-8);
    
    x_n_1 = s;
    w_ = horners(x_n_1, w);
    x_n = x_n_1 - (polyval(w, x_n_1)/polyval(w_,x_n_1));
    diff = abs((x_n - x_n_1)/x_n) < thres;
    while diff > thres
        w_ = horners(x_n_1, w);
        x_n = x_n_1 - (polyval(w, x_n_1)/polyval(w_,x_n_1));
        diff = abs((x_n-x_n_1)/x_n) < thres;
    end  
    return 
end