% Add folder to pathf = svm();

x0 = [1;4;1];
[x,ks,ngs] = gradient_method(f.svm,x0,opts);
addpath(genpath('../method'));
addpath(genpath('../function'));

%%%%%%%%%%%%%
% Load data %
%%%%%%%%%%%%%

load("../small/small_dataset_sample.mat");


%%%%%%%%%%%%%%%%%%%
% Method Options %
%%%%%%%%%%%%%%%%%%%

% GM
opts.gm.maxit = 20000;
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


%%%%%%%%%%%%%%%%%%%%%%
% Parameters Options %
%%%%%%%%%%%%%%%%%%%%%%

opts.svm.lambda = 0.1;
opts.svm.delta = 1e-1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call Optimization Methods %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = svm();

x0 = [1;4;1];
[x,ks,ngs] = gradient_method(f.svm,x0,opts);



