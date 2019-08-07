clear all;close all

fpath1 = 'D:\Google Drive\Work\Machine Learning\_Con\EEG\';
fpath2 = 'D:\Google Drive\Work\Machine Learning\_Con\';

eegFiles = dir(strcat(fpath1,'*eeg*'));
taskFiles = dir(strcat(fpath2,'*task*'));

state = cell(length(taskFiles))
for a = 1:length(taskFiles)
    day = str2double(taskFiles(a).name(7:8));
    load(strcat(fpath2,taskFiles(day).name))
    state{a}  = zeros(length(task{a}),1)
    for b = 1:length(task{a})
        state{a}(b) = task{a}{b}.type== 'run';
    end
end



load(strcat(fpath1,eegFiles(a).name))