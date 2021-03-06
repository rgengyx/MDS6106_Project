%create the small dataset

%hyperparameter and initial points setting
p1.c = [0,0]';p1.sigma = 0.3;p1.m = 1000;
p2.c = [1,1]';p2.sigma = 0.5;p2.m = 1000;

%dataset create
[data1,label1] = create_2points_dataset(p1,p2);

%data save
save('small_dataset_larger','data1','label1')

%load("small/small_dataset_larger.mat");

%visual the points(little slow as use for loop)
l = size(label1);
l = l(2);
parfor i = 1:l
    if label1(i) == 1
        scatter(data1(1,i),data1(2,i),'r*');
        hold on;
    else
        scatter(data1(1,i),data1(2,i),'b*');
        hold on;
    end
end
