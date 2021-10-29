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

    freq_span = linspace(13.50, 13.65, 2);
    SBSgain = zeros(1, length(freq_span));

    model = mphload('..\nlnp2021stevenSDS(formatlab).mph');
    model.sol('sol1').clearSolutionData();
    model.sol('sol2').clearSolutionData();
    model.sol('sol3').clearSolutionData();

    % Config the COMSOL model and trial run the optical model
    model = configParas(model, geom, freq_span);
    fprintf('Configurations of the running model\n');
    fprintf(['Width: ' num2str(geom.w) ' nm\t' 'Distance to center: ' num2str(geom.tg + geom.tint) ' nm\t' 'Thickness: ' num2str(geom.tg) ' nm\n']);
    fprintf(['Seperation: ' num2str(geom.tint) ' nm\t' 'Top cladding thickness: ' num2str(geom.tc * 1000) ' nm\n\n'])
    model.study('std1').run();

    maxGain.gain = 0;
    maxGain.freq = 0;
    % Sweep the frequency
    for i = 1:length(freq_span)
        freq_acous = freq_span(i);
        model.param.set('freq_acous', [num2str(freq_acous) ' [GHz]']);
        model.study('std2').run();
        SBSgain(i) = mphglobal(model, 'SBSgain', 'dataset', 'dset4');
        % Store the maximum gain and the corresponding frequency
        if SBSgain(i) > maxGain.gain
            maxGain.gain = SBSgain(i);
            maxGain.freq = freq_span(i);
        end

        fprintf(['SBSgain @' num2str(freq_acous) 'GHz is ' num2str(SBSgain(i)) '\n']);
        fprintf(['The maximum gain (until now) for this model is ' num2str(maxGain.gain) ' @ ' num2str(maxGain.freq) ' GHz\n'])
    end

    % Writematrix([freq_span.', SBSgain.'], ['results\' 'width' num2str(geom.w) 'nm\' num2str(geom.w) '.csv']);
    % Clean up all solution data
    clear model;
end
