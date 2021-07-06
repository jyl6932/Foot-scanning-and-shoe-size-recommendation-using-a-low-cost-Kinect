%先用xlsinfo确定file.xlsx中有多少个sheet要读
clc;clear;
file = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0917\HalfFeatures.xlsx';
absSaveFeaturePath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0917\FeaturesPredict_AbsRank.xlsx';
squreSaveFeaturePath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0917\FeaturesPredict_Rank^2.xlsx';
[Type,Sheet,Format]=xlsfinfo(file);
%循环读取每个Sheet
Training=[];
m = length(Sheet) ;
P = 0.80 ;
idx = randperm(m)  ;
trainIdx = idx(1:round(P*m)) ; 
testIdx = idx(round(P*m)+1:end);
Features = [3,5,6];

for i = trainIdx
	A = xlsread(file,Sheet{i});
    Training = cat(1,Training,A);
end
X_training = Training(:,Features);



%% abs label
y_training = abs(Training(:,8));
%X=[ones(size(y)) X];
%开始分析
[b1,bint,r,rint,stats] = regress(y_training,X_training);

for i = testIdx
	A = xlsread(file,Sheet{i});
    X_test = A(:,Features);
    predict = X_test*b1;
    [~,idx] = min(abs(predict));
    A(:,10) = NaN;
    A(idx,10) = 0;
    writematrix(A,absSaveFeaturePath,'Sheet',Sheet{i});
end


%% squre label
y_training = Training(:,9);
%开始分析
[b2,bint,r,rint,stats] = regress(y_training,X_training);

for i = testIdx
	A = xlsread(file,Sheet{i});
    X_test = A(:,Features);
    predict = X_test*b2;
    [~,idx] = min(abs(predict));
    A(:,10) = NaN;
    A(idx,10) = 0;
    writematrix(A,squreSaveFeaturePath,'Sheet',Sheet{i});
end