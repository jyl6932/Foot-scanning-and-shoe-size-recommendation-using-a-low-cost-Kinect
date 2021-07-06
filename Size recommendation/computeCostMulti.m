function J = computeCostMulti(X, y, theta)
    m = length(y);
    J = 0;
    
    prediction = X*theta;
    J = (1/2*m) * (prediction - y).'*(prediction - y);
end

