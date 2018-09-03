%%
% PROJECT 4
% IME 20090488 YONGJIN SHIN
clear variable

for n = [4,8,12,16,20,24,28,32]
    mat = hilbert_generator(n)
    condition = my_cond(mat)
    cond(mat, inf)
end

%% Condition
% find conditional number
% input: input matrix A
% output: conditional number
function condition = my_cond(A)
    I = eye(size(A));
    inv_A = solver(A, I)
    inv(A)
    sum_A = max(sum(abs(A),2));
    sum_inv_A = max(sum(abs(inv_A),2));
    condition = sum_A * sum_inv_A;
    return
end

%% Solver(PA_LU)
% Given matrix is not singular (flag = 0)
% only if solve PA=LU problems with using
% 1)my_PALU, 2)forward, 3)backward
function X = solver(A,B)
    [L, U, permut, flag] = my_PALU(A);

    if flag == 1
        msg = 'Error <flag is 1 : Singular Matrix!>';
        error(msg)
    else
        Y = forward(L, B, permut);
        X = backward(U,Y);
    end
    
    return
end

%% PA-LU decomposition
% input: given matrix A
% output: Lower, Upper, Permutation, flag
function [L, U, P, flag] = my_PALU(A)
    origin_A = A; flag = 0; [row, col] = size(A); 
    L = eye(row, col); 
    P = eye(row, col); %permutaion matrix
    pivot_idx = 1:col; %stack pivot indices

    % find Upper Triangular Matrix
    for c = 1:col-1
        % Partial Pivoting
        [~, idx] = max(abs(A(c:row,c))); idx = idx+c-1; pivot_idx(c) = idx;
        A([c idx],:) = A([idx c],:);
        P([c idx],:) = P([idx c],:);
        
        if A(c,c) == 0
            flag = 1;
            return
        end
        for r = c+1:row
            m = A(r,c)/A(c,c); L(r,c) = m;
            A(r,:) = A(r,:) - m*A(c,:);
        end
    end
    
    % Find Lower Triangular Matrix
    L_ = eye(row,col); L_(:,col-1) = L(:,col-1);
    for c = col-2:-1:1
        I = eye(row,col);
        I(:,c) = L(:,c);
        
        for i = c+1:col-1
            p = eye(row,col);
            p([i pivot_idx(i)], :) = p([pivot_idx(i) i], :);
            I = p*I*p;
        end

        L_ = I*L_;
    end
    
    % Set Lower and Upper triangular Matrix
    U = A;
    L = L_;
        
    return
end

%% Forward_Sub
function X = forward(A, b, permut)
    num = size(A); [row, col] = size(b);
    b = permut*b;
    
    X = zeros(size(b));
    X(1,:) = b(1,:);
    
    if row ~= num
        return
    end
    
    for i = 1:col
        for r = 2:num
            X(r,i) = (b(r,i) - A(r,1:r-1)*X(1:r-1, i))/A(r,r);
        end
    end
    
    return
end

%% Backward_Sub
function X = backward(A, b)
    [num,~] = size(A); [row, col] = size(b);
    
    X = zeros(size(b));
    X(num,:) = b(num,:)/A(num,num);
    
    if row ~= num
        return
    end
    
    for i = 1:col
        for r = num-1:-1:1
            X(r,i) = (b(r,i) - A(r,r+1:num)*X(r+1:num, i))/A(r,r);
        end
    end
    
    return
end

%% Generate Hilbert
function H = hilbert_generator(n)
    H = zeros(n,n);
    for i = 1:n
        for j = 1:n
            H(i,j) = 1/(i+j-1);
        end
    end
    
    return
end
