
% scale features and set them to zero mean
[X, mu, sigma] = featureNormalize(X);

X = [ones(m, 1) X];

% 1. Gradient descent
alpha = 0.1;
num_iters = 400;
theta_grades = zeros(4,1);

[theta_grades, J_history] = gradientDescentMulti(X, y, theta_grades, alpha, num_iters);

% estimate the size
inputFeatures = [246 61.11	246.5];
normalizeFeatures = (inputFeatures - mu)./sigma;
A = [1 normalizeFeatures];
predic_grades = A * theta_grades;