clear all 
close all

load('D:\Google Drive\Work\Machine Learning\processed_data3.mat')

S = {'rest','run'};
color = {[1 0 0],[0 0 1]};
%% raw data plots
t = (1:size(dataAll,2))/fs;
figure;hold on
for a = 1:2;
    plot(t,dataAll(a,:),'Color',color{a})
    xlabel('Time (s)')
    ylabel('Extracellular Potential (mV)')
    title('Original single electrode, time domain ')
    legend('rest','run')
end

%% PC plots
figure;hold on
for a = 1:2;
    plot(t,dataPCall(a,:),'Color',color{a})
    xlabel('Time (s)')
    ylabel('Extracellular Potential (mV)')
    title('PC dimension, time domain ')
    legend('rest','run')
end

%% frequency plots
figure;hold 
for a = 1:2;
    plot(freqs,dataF(a,:),'Color',color{a})
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (mV)')
    title('PC dimension, Frequency domain, ')
    xlim([0 60])
    legend('rest','run')
end

%% Error plots
figure;hold on
plot(5:5:60,100*E2')
[y x] = min(E2(1,:));
plot(5*x,100*y,'o','MarkerSize',15)
plot(15,50.6,'*','MarkerSize',15)
legend('1st order kernel','2nd order kernel','3rd order kernel',...
    '4th order kernel','5th order kernel',...
    'Optimal Model and Features','Random labels (chance performance)')
xlabel('Maximum frequency component included in feature vector')
ylabel('Percent classification error')
title('Classification error as a function of model order and feature vector')