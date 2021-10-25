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

    freq_span = linspace(13.50, 13.65, 31);
    SBSgain = zeros(1, length(freq_span));

    model = mphload('..\nlnp2021stevenSDS(formatlab).mph');
    model.result('pg2').set('data', 'dset4');
    model.result('pg2').feature('surf1').set('expr', 'solid.u_tZ*i');
    model.result('pg3').set('data', 'dset4');
    model.result('pg3').feature('surf1').set('expr', 'f_z*i');
    model.result('pg2').feature('surf1').set('rangecoloractive', true);
    model.result('pg2').feature('surf1').set('rangecolormin', '-15E-15');
    model.result('pg2').feature('surf1').set('rangecolormax', '15E-15');
    model.result('pg2').feature('surf1').set('colortablesym', true);
    model.result('pg3').feature('surf1').set('rangecoloractive', true);
    model.result('pg3').feature('surf1').set('rangecolormin', '-0.08');
    model.result('pg3').feature('surf1').set('rangecolormax', '0.08');
    model.result('pg3').feature('surf1').set('rangecoloractive', true);
    model.result('pg3').feature('surf1').set('colortablesym', true);

    % Config the COMSOL model and trial run the optical model
    model.param.set('w', [num2str(geom.w) ' [nm]']);
    model.param.set('tint', [num2str(geom.tint) ' [nm]']);
    model.param.set('tint_up', [num2str(geom.tintup) ' [nm]']);
    model.param.set('t_g1', [num2str(geom.tg) ' [nm]']);
    model.param.set('t_g2', [num2str(geom.tg) ' [nm]']);
    freq_center = freq_span(round(length(freq_span)/2));
    model.param.set('freq_acous', [num2str(freq_center) ' [GHz]']);
    fprintf('Configurations of the running model\n');
    fprintf(['Width: ' num2str(geom.w) ' nm\t' 'Thickness: ' num2str(geom.tg) ' nm\n']); 
    fprintf(['Seperation: ' num2str(geom.tint) ' nm\t' 'Distance to center: ' num2str(geom.tintup) ' nm\n'])
    model.study('std1').run();
    
    tic;
    maxGain.gain = 0;
    maxGain.freq = 0;
    % Sweep the frequency
    for i = 1:length(freq_span)
        freq_acous = freq_span(i);
        model.param.set('freq_acous', [num2str(freq_acous) ' [GHz]']);
        model.study('std2').run();
        SBSgain(i) = mphglobal(model,'SBSgain','dataset','dset4');
        % Store the maximum gain and the corresponding frequency
        if SBSgain(i) > maxGain.gain
            maxGain.gain = SBSgain(i);
            maxGain.freq = freq_span(i);
        end
        fprintf(['SBSgain @' num2str(freq_acous) 'GHz is ' num2str(SBSgain(i)) '\n']);
        fprintf(['The maximum gain until now is ' num2str(maxGain.gain) ' @ ' num2str(maxGain.freq) ' GHz\n'])
        toc;

        model.result.export('img1').set('sourceobject', 'pg2');
        model.result.export('img1').set('pngfilename', ['geneticAlgorithm\results' '\width' num2str(geom.w) 'nm\acoustic\imag(u_tZ) @' num2str(freq_acous) 'GHz']);
        model.result.export('img2').set('sourceobject', 'pg3');
        model.result.export('img2').set('pngfilename', ['geneticAlgorithm\results' '\width' num2str(geom.w) 'nm\force\imag(f_z) @' num2str(freq_acous) 'GHz']);
        model.result.export('img1').run();
        model.result.export('img2').run();
    end

    writematrix([freq_span.', SBSgain.'], ['results\' 'width' num2str(geom.w) 'nm\' num2str(geom.w) '.csv']);

    clear model;
end