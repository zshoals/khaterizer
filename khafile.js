let project = new Project('khaterizer');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');

project.addLibrary('ecx');
project.addLibrary('ds');
project.addLibrary('zui');
project.addLibrary('tweenx/src/tweenxcore');
project.addLibrary('utest');

//polygonal/ds @:generic flag, its presence means enabled
project.addDefine('generic');
project.addDefine('khaterizer_default_services_enabled');

resolve(project);
