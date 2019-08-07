clear all;close all

fpath1 = '_Con\EEG\';
fpath2 = '_Con\';

eegFiles = dir(strcat(fpath1,'*eeg*'));
taskFiles = dir(strcat(fpath2,'*task*'));

state = cell(length(taskFiles),1);
for a = 1:length(taskFiles)
    day = str2double(taskFiles(a).name(8:9));
    load(strcat(fpath2,taskFiles(day).name));
    state{a}  = zeros(length(task{a}),1);
    for b = 1:length(task{a})
        state{a}(b) = isempty(strfind(task{a}{b}.type,'run'))==0;
    end
end

for a = 1:length(eegFiles)
    day = str2double(eegFiles(a).name(7:8));
    epoch = str2double(eegFiles(a).name(10));
    tet = str2double(eegFiles(a).name(12:13));
    load(strcat(fpath1,eegFiles(a).name));
    data = eeg{day}{epoch}{tet}.data;
    fs = eeg{day}{epoch}{tet}.samprate;
    l(a) = length(data);
end
save(strcat(fpath2,'states.mat'),'state')
save(strcat(fpath2,'data_lengths.mat'),'l')