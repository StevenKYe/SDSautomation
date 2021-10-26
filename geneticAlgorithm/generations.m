% Create the random genes for each sample

clc;
clear all;
close all;

format long;

% Genetic pool for the first generation
tg_span = [160, 170, 180, 190];
tint_span = [450, 470, 490, 510];
tc_span = [7.8, 7.9, 8.0, 8.1];
w_span = [2800, 2900, 3000, 3100];

population = 20; % Population for the genetic evolution
samples = table(zeros(population, 1), zeros(population, 1), ...
    zeros(population, 1), zeros(population, 1), rand(population, 1), rand(population, 1)); % table that store the geometry of the samples
samples.Properties.VariableNames = {'tg' 'tint' 'tc' 'w' 'gain' 'freq'};

% Generate the first generation
for i = 1:population
    samples.tg(i) = tg_span(randi(4));
    samples.tint(i) = tint_span(randi(4));
    samples.tc(i) = tc_span(randi(4));
    samples.w(i) = w_span(randi(4));
end

candidates = samples; % Candidates of the first generation

% % Calculate the SBS gain of each sample in the first generation
% for i = 1:population
%     output = runCOMSOL(candidates(i));
%     maxgain.gain(i) = output.gain;
%     maxgain.freq(i) = output.freq;
% end

% Select samples with the 10 largest SBS gain
[~, ind] = maxk(candidates.gain, 10);
elites = candidates(ind, :);
kids = [];

% Generate 10 other candidates from the elites
for i = 1:height(elites) / 2
    j = randperm(height(elites), 2); % Randomly select two elites
    kidsA = elites(j(1), :);
    kidsB = elites(j(2), :);
    propInd = randi(4); % Randomly determine which property to swap
    propValue = kidsA(1, propInd);
    kidsA(1, propInd) = kidsB(1, propInd);
    kidsB(1, propInd) = propValue;
    kidsA.gain = 0;
    kidsA.freq = 0;
    kidsB.gain = 0;
    kidsB.freq = 0;
    kids = [kids; kidsA; kidsB];
end

candidates = [elites; kids];
