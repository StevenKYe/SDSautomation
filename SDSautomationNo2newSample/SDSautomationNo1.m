% Run Comsol server with this command:
% "C:\Program Files\COMSOL\COMSOL56\Multiphysics\bin\win64\comsolmphserver.exe" -port 12345 -autosave off
% Simulate the SBS gain of the 220/300/220 nm SDS waveguide

clc;
clear all;
close all;

format long;

import com.comsol.model.*
import com.comsol.model.util.*

% mphstart(12345);

freq_span = [linspace(11, 12, 20), linspace(12.01, 13, 80), linspace(13.01, 14.5, 30) linspace(14.51, 15.5, 80)];
SBSgain = zeros(1, length(freq_span));
overlap = zeros(1, length(freq_span));

model = mphload('..\nlnp2021stevenSDS(formatlab).mph');
model.param.set('t_int', [num2str(300) ' [nm]']);
model.param.set('t_g1', [num2str(220) ' [nm]']);
model.param.set('t_g2', [num2str(220) ' [nm]']);
model.param.set('w', [num2str(940) ' [nm]']);
model.param.set('t_intup', [num2str(520) ' [nm]']);
model.param.set('freq_acous', [num2str(13) ' [GHz]']);
model.study('std1').feature('mode').set('shift', '1.5739');
model.study('std1').feature('mode2').set('shift', '1.5739');
model.sol('sol1').feature('e1').set('shift', '1.5739');
model.sol('sol1').feature('e2').set('shift', '1.5739');
model.study('std1').run();
tic;
for i = 1:length(freq_span)
    freq_acous = freq_span(i);
    model.param.set('freq_acous', [num2str(freq_acous) ' [GHz]']);
    model.study('std2').run();
    SBSgain(i) = mphglobal(model,'SBSgain','dataset','dset4');
    overlap(i) = mphglobal(model,'overlap','dataset','dset4');
    disp(['SBSgain @' num2str(freq_acous) 'GHz is :' num2str(SBSgain(i))]);
    toc;
end

clear model;

SBSgain = [freq_span; SBSgain];
writematrix(SBSgain.', 'SDSgain.csv')