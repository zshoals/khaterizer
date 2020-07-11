let project = new Project('khaterizer');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');

project.addLibrary('ecx-sh');
project.addLibrary('ds');
project.addLibrary('zui');

project.addDefine('khaterizer_default_services_enabled');

resolve(project);
