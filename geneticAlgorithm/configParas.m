function newModel = configParas(model, geom)
    % Config the geometry and central frequency of the COMSOL model;
    model.param('par2').set('angle_etch', ['82[' native2unicode(hex2dec({'00' 'b0'}), 'unicode') ']'], 'etching angle');
    model.param('par2').set('t_g1', [num2str(geom.tg) ' [nm]']);
    model.param('par2').set('t_g2', [num2str(geom.tg) ' [nm]']);
    model.param('par2').set('t_int', [num2str(geom.tint) ' [nm]']);
    model.param('par2').set('w', [num2str(geom.w) ' [nm]']);
    model.param('par2').set('t_c', [num2str(geom.tc) ' [um]']);
    model.param('par2').set('t_b', '8 [um]', 'bottom cladding thickness');
    model.param('par2').set('w_model', '12 [um]', 'width of the calculation area');
    model.param('par2').set('mesh_size', '50 [nm]', 'mesh size');
    model.param('par2').set('t_subs', '1000 [nm]', 'substrate thickness');
    model.param('par2').set('PML', '1000 [nm]', 'PML thickness');
    model.param('par2').set('t_intup', [num2str(geom.tg + geom.tint) ' [nm]']);
    model.param('par2').set('t_intdown', 't_int - t_intup');
    model.param.label('frequency parameters');
    model.param('par2').label('geometry parameters');
    model.component('comp1').geom('geom1').run;
    model.component('comp1').mesh('mesh1').run;
    model.component('comp2').geom('geom2').run;
    model.component('comp2').mesh('mesh2').run;
    model.study('std1').feature('mode').set('shift', '2');
    model.study('std1').feature('mode2').set('shift', '2');
    model.sol('sol1').feature('e1').set('shift', '2');
    model.sol('sol1').feature('e2').set('shift', '2');
    newModel = model;
end
