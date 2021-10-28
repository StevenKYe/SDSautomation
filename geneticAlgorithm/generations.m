% Create the random genes for each sample

clc;
clear all;
close all;

format long;

% Genetic pool for the first generation
tg_span = linspace(160, 190, 31);
tint_span = linspace(450, 510, 13);
tc_span = linspace(7.8, 8.3, 51);
w_span = linspace(2800, 3100, 31);

population = 20; % Population for the genetic evolution
candidates = table(zeros(population, 1), zeros(population, 1), ...
    zeros(population, 1), zeros(population, 1), rand(population, 1), rand(population, 1)); % table that store the geometry of the candidates
candidates.Properties.VariableNames = {'tg' 'tint' 'tc' 'w' 'gain' 'freq'};

% Generate the first generation
for i = 1:population
    candidates.tg(i) = tg_span(randi(length(tg_span)));
    candidates.tint(i) = tint_span(randi(length(tint_span)));
    candidates.tc(i) = tc_span(randi(length(tc_span)));
    candidates.w(i) = w_span(randi(length(w_span)));
end

samples = table(zeros(130, 1), zeros(130, 1), ...
    zeros(130, 1), zeros(130, 1), zeros(130, 1), zeros(130, 1));

samples(linspace(1, 20, 20), :) = candidates; % Candidates of the first generation
samples.Properties.VariableNames = {'tg' 'tint' 'tc' 'w' 'gain' 'freq'};

rounds = 10; % 10 rounds for evolutions

for round = 1:rounds
    newCandis = find(~candidates.gain); % Find the new candidates whose gain haven't been calculated

    if newCandis

        % Calculate the SBS gain of the candidates
        for i = 1:length(newCandis)
            geom = table2struct(candidates(newCandis(i), :)); % newCandis(i) is the index of the newCandis candidate
            % SBS = runCOMSOL(geom);
            % candidates.gain(newCandis(i)) = SBS.gain;
            % candidates.freq(newCandis(i)) = SBS.freq;

            % code for trial run
            candidates.gain(newCandis(i)) = rand(1);
            candidates.freq(newCandis(i)) = 0;
        end

        firstZero = find(~samples.tg); % find the pointer to store infomation of new samples in the 'samples' array
        samples(linspace(firstZero(1), firstZero(1) + length(newCandis) - 1, length(newCandis)), :) = candidates(newCandis, :);
    end

    % Select half of the candidates with the highest gain
    [~, index] = maxk(candidates.gain, height(candidates) / 2);
    elites = candidates(index, :);
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

            if ~propValue{:, :}
                disp(num2str(propInd));
                error('ERROR');
            end

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
end
