clear all 
close all

fpath1 = 'D:\Google Drive\Work\Machine Learning\';

load('D:\Google Drive\Work\Machine Learning\processed_data3.mat','dataF','freqs','svmodel2','labels')

box = 1;
freqMax = 25;
order = 4;
examples = size(dataF,1);
tests = 5;
E = zeros(tests,1);
for a = 1;%:tests
%     labels = rand(examples,1)>0.5;
    errorChance = zeros(length(labels),1);
    for b = 1:length(labels);
        train = ones(length(labels),1);
        test = zeros(length(labels),1);
        train(b) = 0;test(b) = 1;
        train = logical(train);test = logical(test);
        % train on frequency domain
        svmodel3 = fitcsvm(dataF(train,freqs<freqMax),labels(train),...
            'KernelFunction','polynomial','PolynomialOrder',4,...
            'BoxConstraint',box);  
        prediction2 = predict(svmodel3,dataF(test,freqs<freqMax));
        errorChance(b) = sum(abs(prediction2 - labels(test)));
    end
    E(a) = sum(errorChance)/length(errorChance)
end