function [x,k,ngs] = run_L_bfgs_batch(func, opts)

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

%batch using split data1 (using global data is not so convinient here)
global data1;global label1;
data1_ori = data1;label1_ori = label1; %save the original data and label
epsilon_ori = opts.lbfgs.epsilon;%save the original epsilon
sizes = size(label1_ori);
ori_m = sizes(2);

rand_index = randperm(opts.sample.m,opts.sample.m);

%set the batch size here, maybe can change in main run
batch_size = opts.lbfgs.batch_size;batch_count = ceil(ori_m / batch_size);

x = opts.x0;k = 0;ngs = [];
for i = 1:batch_count %do with the batch
    data1 = data1_ori(:,rand_index((i-1) * batch_size + 1:min(i * batch_size,ori_m)));
    label1 = label1_ori(rand_index((i-1) * batch_size + 1:min(i * batch_size,ori_m)));
    
    %renew the m as needs
    sizes = size(label1);
    opts.sample.m = sizes(2);
    
    %renew the epsilon as batch is more tolarent
    opts.lbfgs.epsilon = opts.lbfgs.batch_epsilon;
    
    %use new batch data to run new f
    f = func();
    
    %use the former batch result for next train
    x0 = x;
    [x,k_new,ngs_new] = L_BFGS(f,x0,opts);
    
    %store the res
    k = k + k_new;
    ngs = [ngs,ngs_new];
end

%fiannly use the whole dataset for final descent
data1 = data1_ori;label1 = label1_ori;
%renew the m as needs
sizes = size(label1);opts.sample.m = sizes(2);
%renew the epsilon as before
opts.lbfgs.epsilon = epsilon_ori;

%use the former batch result for final train
x0 = x;
[x,k_new,ngs_new] = L_BFGS(f,x0,opts);
%store the res
k = k + k_new;
ngs = [ngs,ngs_new];
end