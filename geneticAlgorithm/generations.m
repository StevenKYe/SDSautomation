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

% Check and remove the redundant
samples = unique(samples, 'rows', 'first');

candidates = samples; % Candidates of the first generation

% % Calculate the SBS gain of each sample in the first generation
% for i = 1:population
%     output = runCOMSOL(candidates(i));
%     maxgain.gain(i) = output.gain;
%     maxgain.freq(i) = output.freq;
% end

% Select half of the candidates with the highest gain
[~, ind] = maxk(candidates.gain, height(candidates) / 2);
elites = candidates(ind, :);
kids = zeros(height(elites), width(elites));
kids = array2table(kids);
kids.Properties.VariableNames = {'tg' 'tint' 'tc' 'w' 'gain' 'freq'};

% Generate the other half of the candidates from the elites
for i = 1:height(elites) / 2
    j = randperm(height(elites), 2); % Randomly select two elites
    kidsA = elites(j(1), :);
    kidsB = elites(j(2), :);
    kidsA(1, [5, 6]) = table(0, 0); % Initialize the gain and corresponding frequencies of kidsA
    kidsB(1, [5, 6]) = table(0, 0); % Initialize the gain and corresponding frequencies of kidsB
    diffProp = find(kidsA{:, :} - kidsB{:, :}); % Get the different parameters between A and B
    propInd = diffProp(randi(length(diffProp))); % Randomly determine which property to swap
    propValue = kidsA(1, propInd);
    kidsA(1, propInd) = kidsB(1, propInd);
    kidsB(1, propInd) = propValue;
    kids(2 * i - 1, :) = kidsA;
    kids(2 * i, :) = kidsB;
end

% mutatate the kids
for i = 1:height(kids)
    j = randi(100);

    if (j > 50) && (j < 65) % mutation probability is 14 %
        k = randi(4); % randomly select one of the four freedoms to mutate

        if mod(j, 2) == 1
            kids(i, k) = table(kids{i, k} * 1.1);
        else
            kids(i, k) = table(kids{i, k} / 1.1);
        end

    end

end

candidates = [elites; kids]; % candidates for the next generation
