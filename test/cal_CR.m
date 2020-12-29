function CR = cal_CR(data,label,opts)

%CAL_CR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
len = size(data,2);
paras = opts.paras;
bar = opts.bar;
label_bar = opts.label_bar;
res_count = 0;

for i = 1:len
    x_now = data(:,i);
    pred_value = paras(1:end-1)' * x_now + paras(end);
    if((pred_value - bar) * (label(i) - label_bar) >= 0)%right prediction
        res_count = res_count + 1;
    end
end

%calculate the correctness ratio
CR = res_count / len;
end


