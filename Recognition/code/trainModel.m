function model = trainModel(x, y)
% param.lambda = 0.01;  % Regularization term
% param.maxiter = 100; % Number of iterations
% param.eta = 0.01;     % Learning rate

param.lambda = 0.01;  % Regularization term
param.maxiter = 5000; % Number of iterations
param.eta = 0.001;     % Learning rate

model = multiclassLRTrain(x, y, param);