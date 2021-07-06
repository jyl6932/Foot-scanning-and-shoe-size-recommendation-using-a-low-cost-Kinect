clear;clc;
% 2. Normal equations
% load data
data = load('manualFeatures.txt');
[m,n] = size(data);      % number of data size and features
X = data(:,2:4);       % Length, Width	40mm, Width	MidFoot Width, MidFoot High, Short Heel Girth, Ankle Girth, Size
y = data(:,n);           % Selected Size

X = [ones(m,1) X];

% Leave one out regression
predic_size = ones(m,1);

for i = 1:m
    train_X = X;
    train_X( i,:) = [];
    test_X = X(i,:);
    
    train_y = y;
    train_y( i,:) = [];
    test_y = X(i,:);
    
    m = length(train_y);      % number of data size

    % calculate theta from the normal equation
    theta_noreq = normalEqn(train_X, train_y);


    % estimate the size
    predic_noreq = test_X * theta_noreq;
    
    predic_size(i,1) = predic_noreq;
    
    fprintf('Predicted size using normal equation: $%f\n', predic_noreq);
    
end



