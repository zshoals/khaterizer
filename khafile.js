let project = new Project('khaterizer');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');

project.addLibrary('ecx-sh');
project.addLibrary('HaxeContracts');
project.addLibrary('ds');
project.addLibrary('zui');

resolve(project);
