function [n, DV] = degreeVariance2(gmt)
    % Determine the maximum degree from the input matrix
    nmax = max(gmt(:,1));
    
    % Initialize matrices for cosine and sine coefficients
    A = zeros(nmax + 1, nmax + 1);
    B = zeros(nmax + 1, nmax + 1);
    
    % Populate matrices A and B with the coefficients
    for i = 1:size(gmt, 1)
        degree = gmt(i, 1);
        order = gmt(i, 2);
        A(degree + 1, order + 1) = gmt(i, 3);
        B(degree + 1, order + 1) = gmt(i, 4);
    end
    
    % Square the coefficients
    A = A.^2;
    B = B.^2;
    
    % Calculate degree vector
    n = (0:nmax)';
    
    % Calculate degree variance
    DV = sum(A, 2) + sum(B, 2);
end
