clc
close all
clear all

recObj = audiorecorder(44000, 24, 1);% record at Fs=44khz, 24 bits per sample12
for i=1:5
    fprintf("Start speaking for audio #%d\n",i)
    recordblocking(recObj, 5); % record 2 seconds
    fprintf('Audio #%d ended\n',i)
    %play(recObj);
    y = getaudiodata(recObj);
    y = y - mean(y);
    file_name = sprintf("test #%d.wav",i);
    audiowrite(file_name, y, recObj.SampleRate);
    figure
    plot(y);
end

disp("********************************");

[y, fs] = audioread('phone.m4a');
plot(y);
f = abs(fft(y));
index_f = 1:length(f); % from 1 to number of samples in y
index_f = index_f ./ length(f); % index will be from 0:1/length(f):1
index_f = index_f * fs;
figure;
plot(index_f,f);

training_files_yes = dir('phone.m4a');
testing_files_yes = dir('phone.m4a');

data_yes = [];
for i = 1:length(training_files_yes)
    file_path = strcat(training_files_yes(i).folder,'\',training_files_yes(i).name);% get the file path with name
    [y,fs] = audioread(file_path); % read the audio file
    energy_yes=sum(y.^2); % calculate the energy
    data_yes = [data_yes energy_yes]; % append the energy with all other energies of the other files
end

energy_yes=mean(data_yes); % calculate the average energy
fprintf('The energy of yes is \n');
disp(energy_yes);

for i = 1:length(testing_files_yes)
    file_path = strcat(testing_files_yes(i).folder,'\',testing_files_yes(i).name);
    [y,fs] = audioread(file_path);
    y_energy = sum(y.^2);
    % test if the energy of this file is closer to YES or NO average energies
    if(abs(y_energy-energy_yes))
        fprintf('Test file [yes] #%d classified as yes ,E=%d \n',i,y_energy);
    else
        fprintf('Test file [yes] #%d classified as no E=%d \n',i,y_energy);
    end
end
