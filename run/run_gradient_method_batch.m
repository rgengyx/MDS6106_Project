function [x,k,ngs, train_accs, test_accs]  = run_gradient_method_batch(func, opts)

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
global data1;global label1;
data1_ori = data1;label1_ori = label1; %save the original data and label
tol_ori = opts.gm.tol;%save the original epsilon
sizes = size(label1_ori);
ori_m = sizes(2);

%batch settings
rand_index = randperm(opts.sample.m,opts.sample.m);

%set the batch size here, maybe can change in main run
batch_size = opts.bfgs.batch_size;batch_count = ceil(ori_m / batch_size);

x = opts.x0;k = 0;ngs = [];train_accs=[];test_accs=[];

for i = 1:batch_count %do with the batch

    data1 = data1_ori(:,rand_index((i-1) * batch_size + 1:min(i * batch_size,ori_m)));
    label1 = label1_ori(rand_index((i-1) * batch_size + 1:min(i * batch_size,ori_m)));
    %renew the m as needs
    sizes = size(label1);
    opts.sample.m = sizes(2);
    
    %renew the epsilon as batch is more tolarent
    opts.gm.tol = opts.gm.batch_epsilon;
    
    %use new batch data to run new f
    if func == "svm"
        f = svm();
    elseif func == "svm_sgd"
        f = svm_sgd();
    elseif func == "svm_sparse"
        f = svm_sparse();
    elseif func == "logr"
        f = logr();
    elseif func == "logr_sparse"
        f = logr_sparse();
    elseif func == "logr_sgd"
        f = logr_sgd();
    elseif func == "logr_sparse_sgd"
        f = logr_sgd_sparse();
    end
    
    %use the former batch result for next train
    x0 = x;
    [x,k_new,ngs_new,train_accs_new,test_accs_new] = gradient_method(f,x0,opts);

    %store the res
    k = k + k_new;
    ngs = [ngs,ngs_new];
    train_accs = [train_accs, train_accs_new];
    test_accs = [test_accs, test_accs_new];
end

%finally use the whole dataset for final descent
data1 = data1_ori;label1 = label1_ori;
%renew the m as needs
sizes = size(label1);opts.sample.m = sizes(2);
%renew the epsilon as before
opts.gm.tol = tol_ori;

%use the former batch result for final train
x0 = x;
[x,k_new,ngs_new,train_accs_new, test_accs_new] = gradient_method(f,x0,opts);

%store the res
k = k + k_new;
ngs = [ngs,ngs_new];
train_accs = [train_accs, train_accs_new];
test_accs = [test_accs, test_accs_new];
end