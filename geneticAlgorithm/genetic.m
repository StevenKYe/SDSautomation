% Create the random genes for each sample

clc;
clear all;
close all;

format long;

% mphstart(12345);

% Genetic pool for the first generation
tg_span = linspace(160, 190, 7);
tint_span = linspace(450, 550, 11);
tc_span = linspace(7.8, 8.3, 26);
w_span = linspace(2600, 3400, 17);

population = 20; % Population for the genetic evolution
candidates = table(zeros(population, 1), zeros(population, 1), ...
    zeros(population, 1), zeros(population, 1), zeros(population, 1), zeros(population, 1)); % table that store the geometry of the candidates
candidates.Properties.VariableNames = {'tg' 'tint' 'tc' 'w' 'gain' 'freq'};

% Generate the first generation
for i = 1:population
    candidates.tg(i) = tg_span(randi(length(tg_span)));
    candidates.tint(i) = tint_span(randi(length(tint_span)));
    candidates.tc(i) = tc_span(randi(length(tc_span)));
    candidates.w(i) = w_span(randi(length(w_span)));
end

rounds = 10; % 10 rounds for evolutions
poll = population + (rounds - 1) * 10; % Total number of samples
samples = table(zeros(poll, 1), zeros(poll, 1), ...
    zeros(poll, 1), zeros(poll, 1), zeros(poll, 1), zeros(poll, 1));

samples(linspace(1, population, population), :) = candidates; % Candidates of the first generation
samples.Properties.VariableNames = {'tg' 'tint' 'tc' 'w' 'gain' 'freq'};
tic;

for singleRound = 1:rounds
    fprintf(['The ' num2str(singleRound) 'st round evolutions\n']);
    fprintf(['There are ' num2str(height(candidates)) ' candidates.\n']);
    newCandis = find(~candidates.gain); % Find the new candidates whose gain haven't been calculated

    % Calculate the SBS gain of the candidates
    for i = 1:length(newCandis)
        geom = table2struct(candidates(newCandis(i), :)); % newCandis(i) is the index of the newCandis candidate

        % Run COMSOL to get the real results
        fprintf(['\n' num2str(i) '/' num2str(length(newCandis)) ' in this round.\n']);
        SBS = runCOMSOL(geom);
        candidates.gain(newCandis(i)) = SBS.gain;
        candidates.freq(newCandis(i)) = SBS.freq;
        toc;
        % code for trial run
        % candidates.gain(newCandis(i)) = rand(1);
        % candidates.freq(newCandis(i)) = 0;
    end

    firstZero = find(~samples.gain); % find the pointer to store infomation of new samples in the 'samples' array
    samples(linspace(firstZero(1), firstZero(1) + length(newCandis) - 1, length(newCandis)), :) = candidates(newCandis, :);

    % Select half of the candidates with the highest gain
    [~, index] = unique(candidates(:, [1, 2, 3, 4]), 'stable');
    candidates = candidates(index, :);
    [~, index2] = maxk(candidates.gain, population / 2);
    elites = candidates(index2, :);

    % Display the infomation of the maximum gain
    champion = elites(1, :);
    fprintf(['\n The maximum SBS gain (until now) in all samples is ' num2str(champion.gain) ' @ ' num2str(champion.freq) 'GHz.\n']);
    fprintf('The geometry of that design is: \n');
    fprintf(['t_g@' num2str(champion.tg) 'nm;\t t_int@' num2str(champion.tint) ...
            'nm;\t t_c@' num2str(champion.tc * 1000) 'nm;\t w@' num2str(champion.w) 'nm;\n\n']);

    if height(elites) < height(candidates) / 2
        disp('error');
    end

    kids = zeros(height(elites), width(elites));
    kids = array2table(kids);
    kids.Properties.VariableNames = {'tg' 'tint' 'tc' 'w' 'gain' 'freq'};

    % Generate the other half of the candidates from the elites
    for i1 = 1:height(elites) / 2
        j1 = randperm(height(elites), 2); % Randomly select two elites
        kidsA = elites(j1(1), :);
        kidsB = elites(j1(2), :);
        kidsA(1, [5, 6]) = table(0, 0); % Initialize the gain and corresponding frequencies of kidsA
        kidsB(1, [5, 6]) = table(0, 0); % Initialize the gain and corresponding frequencies of kidsB
        diffProp = find(kidsA{:, :} - kidsB{:, :}); % Get the different parameters between A and B

        if diffProp
            propInd = diffProp(randi(length(diffProp))); % Randomly determine which property to swap
            propValue = kidsA(1, propInd);
            kidsA(1, propInd) = kidsB(1, propInd);
            kidsB(1, propInd) = propValue;
            kids(2 * i1 - 1, :) = kidsA;
            kids(2 * i1, :) = kidsB;
        else
            error('same kids'); % If the two kids are the same, then repair this trial
        end

    end

    % mutatate the kids
    for i2 = 1:height(kids)
        j2 = randi(100);

        if (j2 > 50) && (j2 < 65) % mutation probability is 14 %
            k = randi(4); % randomly select one of the four freedoms to mutate

            if mod(j2, 2) == 1
                kids(i2, k) = table(kids{i2, k} * 1.1);
            else
                kids(i2, k) = table(kids{i2, k} / 1.05);
            end

        end

    end

    candidates = [elites; kids]; % candidates for the next generation
    currentSamples = table2array(samples); % Export the up-to-date results
    writematrix(currentSamples, 'uptoDateResults.csv');
end
