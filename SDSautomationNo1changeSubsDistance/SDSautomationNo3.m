% Run Comsol server with this command:
% "C:\Program Files\COMSOL\COMSOL56\Multiphysics\bin\win64\comsolmphserver.exe" -port 12345 -autosave off
% Simulate the Brillouin gain when tintup is at 630nm

clc;
clear all;
close all;

format long;

import com.comsol.model.*
import com.comsol.model.util.*

% mphstart(12345);

freq_span = linspace(13.50, 13.65, 30);
SBSgain = zeros(1, length(freq_span));

model = mphload('..\nlnp2021stevenSDS(formatlab).mph');
model.result('pg2').set('data', 'dset4');
model.result('pg2').feature('surf1').set('expr', 'solid.u_tZ');
model.result('pg3').set('data', 'dset4');
model.result('pg3').feature('surf1').set('expr', 'solid.u_tZ*i');
model.result('pg2').feature('surf1').label('real(u_tZ)');
model.result('pg2').feature('surf1').set('rangecoloractive', true);
model.result('pg2').feature('surf1').set('rangecolormin', '-15E-15');
model.result('pg2').feature('surf1').set('rangecolormax', '15E-15');
model.result('pg2').feature('surf1').set('colortablesym', true);
model.result('pg3').feature('surf1').label('imag(u_tZ)');
model.result('pg3').feature('surf1').set('rangecoloractive', true);
model.result('pg3').feature('surf1').set('rangecolormin', '-6E-14');
model.result('pg3').feature('surf1').set('rangecolormax', '6E-14');
model.result('pg3').feature('surf1').set('rangecoloractive', true);
model.result('pg3').feature('surf1').set('colortablesym', true);
tic;
model.param.set('tint_up', [num2str(630) ' [nm]']);
model.param.set('freq_acous', [num2str(13.585) ' [GHz]']);
model.study('std1').run();
    
for i = 1:length(freq_span)
freq_acous = freq_span(i);
model.param.set('freq_acous', [num2str(freq_acous) ' [GHz]']);
model.study('std2').run();
SBSgain(i) = mphglobal(model,'SBSgain','dataset','dset4');
disp(['SBSgain @' num2str(freq_acous) 'GHz is :' num2str(SBSgain(i))]);
toc;

model.result.export('img1').set('sourceobject', 'pg2');
model.result.export('img1').set('pngfilename', ['SDSautomationNo1changeSubsDistance\singlePoint(225&630nm)\' 'real\real(u_tZ) @' num2str(freq_acous) 'GHz']);
model.result.export('img2').set('sourceobject', 'pg3');
model.result.export('img2').set('pngfilename', ['SDSautomationNo1changeSubsDistance\singlePoint(225&630nm)\' 'imag\imag(u_tZ)@' num2str(freq_acous) 'GHz']);
model.result.export('img1').run();
model.result.export('img2').run();
end

clear model;



