function dfx = df(x)
%DF(X) �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
x1 = x(1);x2 = x(2);
dfx = 2 * f1(x) * df1(x) + 2 * f2(x) * df2(x);
end

