function x = run_gradient_method(func, opts)

% Add folder to path
addpath(genpath('method'));
addpath(genpath('function'));
addpath(genpath('visualization'));
addpath(genpath('search'));
addpath(genpath('test'));
% Global Seed Settings
rng("default");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call Optimization Methods %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if func == "svm"
    f = svm();
elseif func == "logr"
    f = logistic_regression();
end

x0 = [0;0;0];
[x,ks,ngs] = gradient_method(f,x0,opts);

end