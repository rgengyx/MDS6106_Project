% Add folder to path
addpath(genpath('method'));
addpath(genpath('function'));
addpath(genpath('visualization'));

%%%%%%%%%%%%%
% Load data %
%%%%%%%%%%%%%

load("small/small_dataset_mod.mat");
% load("small/small_dataset_sample.mat");


%%%%%%%%%%%%%%%%%%%
% Method Options %
%%%%%%%%%%%%%%%%%%%

% GM
opts.gm.maxit = 20;
opts.gm.tol = 1e-8;
opts.gm.display = true;
opts.gm.step_size_method = "armijo";
opts.gm.plot = false;
opts.gm.print = true;

% Armijo
opts.armijo.maxit = 100;
opts.armijo.s = 1;
opts.armijo.sigma = 0.5;
opts.armijo.gamma = 0.1;

% Sample
opts.sample.m = length(data1);


%%%%%%%%%%%%%%%%%%%%%%
% Parameters Options %
%%%%%%%%%%%%%%%%%%%%%%

% SVM
opts.svm.lambda = 0;
opts.svm.delta = 1e-4;

% Logistic Regression
opts.logr.lambda = 0.1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call Optimization Methods %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = svm();
% f = logistic_regression();

x0 = [0;0;0];
[x,ks,ngs] = gradient_method(f,x0,opts);


%%%%%%%%%%%%%%%%%
% Visualization %
%%%%%%%%%%%%%%%%%

plot_scatter(data1,label1);
hold on

x1 = -3:0.01:3;
x2 = calculate_x2(x,x1);

plot(x1,x2);


%%%%%%%%%%%%%%%%%%%%%
% Utility Functions %
%%%%%%%%%%%%%%%%%%%%%

function x2 = calculate_x2(x, x1)
    x2 = (-x1 * x(1) - x(3))/x(2); 
end

