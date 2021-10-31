% Run Comsol server with this command:
% "C:\Program Files\COMSOL\COMSOL56\Multiphysics\bin\win64\comsolmphserver.exe" -port 12345 -autosave off
% MATLAB function to run the COMSOL model with certain parameters once

function maxGain = runCOMSOL(geom)
    %myFun - Description
    %
    % Syntax: maxGain = runCOMSOL(geom)
    % Geometry configuration example:
    % geom.w = 4200; % Width of the chip
    % geom.tint = 450; % Seperation between the two stripes
    % geom.tintup = 250; % Distance from the bottom boundary of the upper stripe to the center of the chip, unit: nm
    % geom.tg = 180; % Thickness of the stripe, unit: nm

    format long;

    model = mphload('..\nlnp2021stevenSDS(formatlab).mph');
    % Clean up all solution data
    model.sol('sol1').clearSolutionData();
    model.sol('sol2').clearSolutionData();
    model.sol('sol3').clearSolutionData();

    % Config the COMSOL model and trial run the optical model
    model = configParas(model, geom);
    model.param.set('freq_acous', [num2str(13.5) ' [GHz]']);
    fprintf('Configurations of the running model\n');
    fprintf(['Width: ' num2str(geom.w) ' nm\t' 'Distance to center: ' num2str(geom.tg + geom.tint) ' nm\t' 'Thickness: ' num2str(geom.tg) ' nm\n']);
    fprintf(['Seperation: ' num2str(geom.tint) ' nm\t' 'Top cladding thickness: ' num2str(geom.tc * 1000) ' nm\n\n']);
    model.study('std1').run();

    % Croase sweeping
    coarseGain = zeros(1, 20);
    coarseFreq = zeros(1, 20);

    for i = 1:20
        coarseFreq(i) = 13.8 - 0.1 * i;
        model.param.set('freq_acous', [num2str(coarseFreq(i)) ' [GHz]']);
        model.study('std2').run();
        coarseGain(i) = mphglobal(model, 'SBSgain', 'dataset', 'dset4');
        fprintf(['SBSgain @' num2str(coarseFreq(i)) 'GHz is ' num2str(coarseGain(i)) '\n']);

        if (max(coarseGain) > 0.1) && ((max(coarseGain) - coarseGain(i)) > 0.05)
            [gainCenter, gainCenterLoc] = max(coarseGain);
            freqCenter = coarseFreq(gainCenterLoc);
            break;
        end

    end

    fprintf(['Maximum gain is around ' num2str(freqCenter) 'GHz\n']);

    % Fine sweeping
    freqSpan = linspace(freqCenter + 0.09, freqCenter -0.1, 20);
    SBSgain = zeros(1, 20);
    maxGain.gain = 0;
    maxGain.freq = 0;
    [FLAG1, FLAG2] = deal(0,0);

    for i = 1:length(freqSpan)
        FLAG1 = ~FLAG1;
        freqAcous = freqSpan(i);
        model.param.set('freq_acous', [num2str(freqAcous) ' [GHz]']);
        model.study('std2').run();
        SBSgain(i) = mphglobal(model, 'SBSgain', 'dataset', 'dset4');
        fprintf(['SBSgain @' num2str(freqAcous) 'GHz is ' num2str(SBSgain(i)) '\n']);
        
        if i > 1
            if SBSgain(i) > SBSgain(i-1)
                FLAG2 = ~FLAG2;
            end
        end

        % Find the maximum gain and the corresponding frequency
        if FLAG1 == FLAG2
            maxGain.gain = SBSgain(i - 1);
            maxGain.freq = freqSpan(i - 1);
            fprintf(['The maximum gain (until now) for this model is ' num2str(maxGain.gain) ' @ ' num2str(maxGain.freq) ' GHz\n']);
            break;
        end

    end

        writematrix([freqSpan.', SBSgain.'], ['results\frequencySweep\w' num2str(geom.w) '_tint' num2str(geom.tint) '_tg' num2str(geom.tg) '_tc' num2str(geom.tc * 1000) '.csv']);
    clear model;

end


