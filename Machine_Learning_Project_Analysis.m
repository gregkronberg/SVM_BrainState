clear all;close all

%% file paths
fpath1 = '_Con\EEG\';
fpath2 = '_Con\';

%% load state labels (sleep or run)
load(strcat(fpath2,'states.mat'))
load(strcat(fpath2,'data_lengths.mat'))

%% organize directories
eegDir = dir(strcat(fpath1,'*eeg*'));
taskDir = dir(strcat(fpath2,'*task*'));
for a = 1:length(eegDir)
    day = str2double(eegDir(a).name(7:8));
    epoch = str2double(eegDir(a).name(10));
    tet = str2double(eegDir(a).name(12:13));
    eegFiles{day}{epoch}{tet} = eegDir(a).name;
end
for a = 1:length(taskDir)
    taskFiles{a} = taskDir(a).name;
end

%% Format data into matrix for SVM (features x examples)
featL = 3000;%round(min(l)/500);
tets = 30;
dataPCall = [];
dataAll = [];
labels = [];
fs = 1500;
for a = 1:length(eegFiles) % day
    data1 = cell(length(eegFiles{a}),1);
    data2 = cell(length(eegFiles{a}),1);
    data2std = cell(length(eegFiles{a}),1);
    data3 = cell(length(eegFiles{a}),1);
    for b = 1:length(eegFiles{a}) % epoch
        data1{b} = zeros(featL,length(eegFiles{a}{b}));
        for c = 1:length(eegFiles{a}{b}) % tetrode
            load(strcat(fpath1,eegFiles{a}{b}{c}))
            dat = eeg{a}{b}{c}.data(1:featL);
            data1{b}(:,c) = dat;
        end
        data2{b} = data1{b} - ones(size(data1{b},1),1)*mean(data1{b},1);
        data2std{b} = ones(size(data2{b},1),1)*std(data2{b},0,1);
        data3{b} = data2{b}./data2std{b};
        %% PCA
        [U,S,V] = svd(data3{b});
        pc  = V(:,1);
        dataPCall = [dataPCall;(pc'*data2{b}')];
        dataAll = [dataAll;data2{b}(:,2)'];
        labels = [labels;state{a}(b)];
    end
end

%%

L = round(size(dataPCall',1)/1);
dataF1 = abs(fft(dataPCall',L))/L;
dataF = dataF1(1:round(L/2)+1,:)';
freqs = fs*(0:round(L/2))/L;


%% SVM
poly =5;
error2 = zeros(poly,60/5,1,length(labels));
figure
for a = 1:poly
    for c=5:5:60
        for d = 0;
            for b = 1:length(labels)
                train = ones(length(labels),1);
                test = zeros(length(labels),1);
                train(b) = 0;test(b) = 1;
                train = logical(train);test = logical(test);
                % train on frequency domain
                svmodel2 = fitcsvm(dataF(train,freqs<c),labels(train),...
                    'KernelFunction','polynomial','PolynomialOrder',a,...
                    'BoxConstraint',10^d);  
                prediction2 = predict(svmodel2,dataF(test,freqs<c));
                error2(a,c/5,d+1,b) = sum(abs(prediction2 - labels(test)));
                plot([a,b,c,d])
                drawnow
            end
        end
    end
end
% E1 = sum(error1,2)/size(error1,2);
E2 = squeeze(sum(error2,4)/size(error2,4));


% [train, test] = crossvalind('HoldOut', numel(labels), 0.1);
% for a = 1:3
%     svmodel = fitcsvm(dataPCall(train,:),labels(train),'KernelFunction','polynomial','PolynomialOrder',a);  
%     prediction = predict(svmodel,dataPCall(test,:));
%     error(a) = sum(abs(prediction - labels(test)))/length(labels(test));
% end
% error