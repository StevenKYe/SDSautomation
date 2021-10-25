% Run Comsol server with this command:
% "C:\Program Files\COMSOL\COMSOL56\Multiphysics\bin\win64\comsolmphserver.exe" -port 12345 -autosave off
% Simulate the Brillouin gain when the width changes from 2300nm to 2800nm

clc;
clear all;
close all;

format long;

import com.comsol.model.*
import com.comsol.model.util.*

% mphstart(12345);

freq_span = linspace(13.55, 13.60, 11);
SBSgain = zeros(1, length(freq_span));
w = 2800;

model = mphload('..\nlnp2021stevenSDS(formatlab).mph');
model.result('pg2').set('data', 'dset4');
model.result('pg2').feature('surf1').set('expr', 'solid.u_tZ*i');
model.result('pg3').set('data', 'dset4');
model.result('pg3').feature('surf1').set('expr', 'f_z*i');
model.result('pg2').feature('surf1').label('imag(u_tZ)');
model.result('pg2').feature('surf1').set('rangecoloractive', true);
model.result('pg2').feature('surf1').set('rangecolormin', '-15E-15');
model.result('pg2').feature('surf1').set('rangecolormax', '15E-15');
model.result('pg2').feature('surf1').set('colortablesym', true);
model.result('pg3').feature('surf1').label('f_z*i');
model.result('pg3').feature('surf1').set('rangecoloractive', true);
model.result('pg3').feature('surf1').set('rangecolormin', '-0.08');
model.result('pg3').feature('surf1').set('rangecolormax', '0.08');
model.result('pg3').feature('surf1').set('rangecoloractive', true);
model.result('pg3').feature('surf1').set('colortablesym', true);
tic;
model.param.set('tint_up', [num2str(250) ' [nm]']);
model.param.set('w', [num2str(w) ' [nm]']);
model.param.set('freq_acous', [num2str(13.585) ' [GHz]']);
model.study('std1').run();

disp(['Width @ ' num2str(w)]);    

for i = 1:length(freq_span)
freq_acous = freq_span(i);
model.param.set('freq_acous', [num2str(freq_acous) ' [GHz]']);
model.study('std2').run();
SBSgain(i) = mphglobal(model,'SBSgain','dataset','dset4');
disp(['SBSgain @' num2str(freq_acous) 'GHz is :' num2str(SBSgain(i))]);
toc;

model.result.export('img1').set('sourceobject', 'pg2');
model.result.export('img1').set('pngfilename', ['SDSautomationNo3changeWidth\singlePoint(2800nm)\' 'acoustic\imag(u_tZ) @' num2str(freq_acous) 'GHz']);
model.result.export('img2').set('sourceobject', 'pg3');
model.result.export('img2').set('pngfilename', ['SDSautomationNo3changeWidth\singlePoint(2800nm)\' 'force\imag(f_z)@' num2str(freq_acous) 'GHz']);
model.result.export('img1').run();
model.result.export('img2').run();
end

writematrix([freq_span.', SBSgain.'], 'singlePoint(2800nm)\SBSgain2800nm.csv');
plot(freq_span, SBSgain);
saveas(gcf, 'singlePoint(2800nm)\SBSgain2800nm.png');

clear model;



