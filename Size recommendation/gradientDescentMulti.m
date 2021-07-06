function [theta,J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters)
    m = length(y);
    J_history = zeros(num_iters, 1);
    sumError = zeros(length(theta), 1);
    
    for iter = 1:num_iters
        prediction = X*theta;
        
        for i =1:length(theta)
            sumError(i) = sum((prediction - y).*X(:,i));
        end
        
        theta = theta - (alpha/m)*sumError;
        J_history = computeCostMulti(X, y, theta);
    end
end

