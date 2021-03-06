function [x_end,count,ngs, train_accs, test_accs] = BFGS(f,x0,opts)

%BFGS 此处显示有关此函数的摘要
%   此处显示详细说明
%addpath('D:\desktop2\new start learning\cuhksz learning\optimization-MDS6106\project\project_git\MDS6106_Project\search')
%addpath('functions_test\')
%hyperparameter setting
%just use the opts
count = 0;

%build H0 with the dimension of x0
n = size(x0);n = n(1);
H_now = eye(n) * opts.bfgs.rou;
df = f.grad;
%set initial x_now
x_now = x0;
ngs = [];
train_accs = [];
test_accs = [];

while(count < opts.bfgs.maxit)
    %df(x_now,opts)
    d_now = -H_now * df(x_now,opts);
    alpha = armijo_line_search(f,x_now,d_now,opts);
    x_next = x_now + alpha * d_now;
    ngs(count + 1) = norm(df(x_next,opts));
    if(norm(df(x_next,opts)) <= opts.bfgs.epsilon)
        break;
    end
    
    %build sk and yk
    s_now = x_next - x_now;y_now = df(x_next,opts) - df(x_now,opts);
    
    %Hk+1 setting
    if(s_now' * y_now < opts.bfgs.H_epsilon)%not good Hk+1, hold original
        H_next = H_now;
    else
        add1 = ((s_now - H_now * y_now) * s_now' + s_now * (s_now - H_now * y_now)') / (s_now' * y_now);
        add2 = (s_now - H_now * y_now)' * y_now * (s_now * s_now') / (s_now' * y_now)^2;
               
        H_next = H_now + add1 - add2;
    end
    
    %renew the x_now and H_now
    x_now = x_next;
    H_now = H_next;
    count = count + 1;
    k = count;
    % test accuracy
    if opts.cr_save
        [CR_train,CR_test] = train_test_accuracy(x_now);
        train_accs(k) = CR_train;
        test_accs(k) = CR_test;
    end

    if isnan(f.obj(x_now,opts))
        break 
    end
    
    if opts.bfgs.print
        obj_val   = f.obj(x_now,opts);
        ng = norm(df(x_now,opts));
        if opts.cr_save
            fprintf('k=[%5i] ; obj_val=%1.6f ; ng=%1.4e ; alpha=%1.2f ; train_acc=%1.4f ; test_acc=%1.4f\n',k,obj_val,ng,alpha,CR_train, CR_test);
        else
            fprintf('k=[%5i] ; obj_val=%1.6f ; ng=%1.4e ; alpha=%1.2f\n',k,obj_val,ng,alpha);
        end
    end
    
end

x_end = x_now;
end

