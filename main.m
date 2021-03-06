clear

% Add folder to path
addpath(genpath('method'));
addpath(genpath('run'));
addpath(genpath('function'));
addpath(genpath('visualization'));
addpath(genpath('search'));
addpath(genpath('test'));
addpath(genpath('train_test'));
addpath(genpath('run'));

%%%%%%%%%%%%%
% Load data %
%%%%%%%%%%%%%
global data1;global label1;global data2;global label2;

%load("small/small_dataset_sample.mat");
dataset = "mushrooms";

load("bigdata/"+dataset+"/"+dataset+"_train.mat");
load("bigdata/"+dataset+"/"+dataset+"_train_label.mat");
data1 = A';label1 = b';
% Sample
sizes = size(data1);
opts.sample.m = sizes(2);%the count of sample
opts = config(opts);

%split data, data1 for train, data2 for test
rand_index = randperm(opts.sample.m,opts.sample.m);split_index = floor(opts.sample.m * opts.split_ratio);
data2 = data1(:,rand_index(1:split_index));
label2 = data1(rand_index(1:split_index));

data1 = data1(:,rand_index(split_index+1:end));
label1 = data1(rand_index(split_index+1:end));

sizes = size(data1);
opts.sample.m = sizes(2);%the count of sample

%%%%%%%
% Run %
%%%%%%%

% svm, logr (no more bigdata)
% gm, agm, bfgs, lbfgs
% gm_batch,agm_batch,bfgs_batch,lbfgs_batch
% gm_sgd,agm_sgd, bfgs_sgd, lbfgs_sgd
% gm_sgd_batch,agm_sgd_batch, bfgs_sgd_batch, lbfgs_sgd_batch

%initial point set
opts.x0 = zeros(size(data1,1) + 1,1);
method_cmp_list = {"lbfgs","lbfgs_batch","lbfgs_sgd","lbfgs_sgd_batch"};method_name_list = {};

for i = 1:length(method_cmp_list)
    method_name_list{i} = strrep(method_cmp_list{i},"_"," ");
end

x_list = {};k_list = {};ngs_list = {};train_accs_list = {};test_accs_list = {};time_list = [];
for i = 1:length(method_cmp_list)%use tic toc here to measure the time consume
    tic
    [x_list{i},k_list{i},ngs_list{i}] = run("logr",method_cmp_list{i},opts);
    time_list(i) =  toc
end

%{
lbfgs_lambda_list = [0.05,0.1,0.2,0.5,0.8];
for i = 1:length(lbfgs_lambda_list)
    tic
    opts.logr.lambda = lbfgs_lambda_list(i);
    %if big data please no more accuracy save!!
    [x_list{i},k_list{i},ngs_list{i},train_accs_list{i},test_accs_list{i}] = run("logr","lbfgs",opts);
    toc
end
%}

%%%%%%%%
% test %
%%%%%%%%

ac_list = [];
for i = 1:length(x_list)%here use global, no return value, maybe change further
    [CR_train,CR_test] = train_test_accuracy(x_list{i});
    ac_list(:,i) = [CR_train,CR_test]';
end

%%%%%%%%%%%%%
% Visualize %
%%%%%%%%%%%%%

%{
% Visualize
figure('Name','Scatter Plot');
for i = 1:length(x_list)
    visualize(x_list{i}, data2, label2);
end
%}

% Convergence Plot
figure('Name','Convergence Plot');
for i = 1:length(ngs_list)
    plot(log(ngs_list{i}) / log(10));
    hold on;
end
legend(method_name_list);

% Accuracy Plot
%{
for i = 1:length(method_cmp_list)
    figure('Name','Train Test Accuracy:' + method_cmp_list{i});
    plot(train_accs_list{i});
    hold on;
end
%}
for i = 1:length(test_accs_list)
    plot(test_accs_list{i});
    hold on;
end
%legend(string(lbfgs_lambda_list))
ylabel("norm(grad(x))");
xlabel("iteration times");
title(dataset + " result");
%legend({"Training Accuracy", "Test Accuracy"});

% Save the result
save("bigdataresult/" + dataset + "/" + dataset + ".mat","method_name_list","k_list","x_list","ngs_list","time_list","opts");