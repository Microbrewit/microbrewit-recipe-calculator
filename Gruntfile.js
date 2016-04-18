'use strict';
var config = {
	build: {
		dependencies: [
			"build/mbFormulas.js",
			"bower_components/lodash/dist/lodash.js",
			"bower_components/angular/angular.js",
			"bower_components/angular-ui-router/release/angular-ui-router.js",
			"bower_components/angular-ui-select/dist/select.js",
			"bower_components/ng-sortable/dist/ng-sortable.js",
			"tmp/js/**/*.js"
		],
		source: "app",
		destination: "build",
		tmp: 'tmp'
	}
};

module.exports = function (grunt) {
	// show elapsed time at the end
	require('time-grunt')(grunt);
	// load all grunt tasks
	require('load-grunt-tasks')(grunt);

	var jsFiles = config.build.dependencies;
	var sourceFolder = config.build.source;
	var buildFolder = config.build.destination;

	console.log(buildFolder);


	var tmpFolder = "tmp";

	grunt.initConfig({
		
		// The Coffeescript compiler
		coffee: {
			compile: {
				options: {
					bare: true,
					sourceMap: false
				},
				files: [{
					expand: true,					// Enable dynamic expansion
					cwd: sourceFolder,		// Src matches are relative to this path
					src: ['**/*.coffee'],			// Actual patterns to match
					dest: tmpFolder + '/js',		// Store in tmp folder
					ext: '.js'               		// Destination path prefix
				}]
			}
		},

		ngAnnotate: {
			options: {
				singleQuotes: true,
			},
			app1: {
				files: [{
					expand: true,
					src: [buildFolder + '/build.js'],
					ext: '.annotated.js', // Dest filepaths will have this extension.
                    extDot: 'last'
				}]
			}
		},
		
		uglify: {
			options: {
				report: false,
				mangle: true,
				compress: true,
			},
			prod: {
				files: [{
					expand: true,
					src: [buildFolder + '/build.annotated.js'],
					ext: '.min.js', // Dest filepaths will have this extension.
                    extDot: 'first'
				}]
			}
		},

		clean: {
			src: ["tmp/**/*"],
			filter: 'isFile'
		},

		watch: {
			source: {
				files: [sourceFolder + '/**/*.*'],
				options: {
					spawn: false,
					interrupt: true
				}
			}
		},

		copy: {
			html: {
				files: [ {expand: true, cwd: sourceFolder, src: ['**/*.html'], dest: config.build.destination, filter: 'isFile'} ]
			},
			images: {
				files: [ {expand: true, cwd: sourceFolder, src: ['**/*.{png,jpg,jpeg,gif,ico,svg,woff,svg,eot,ttf}'], dest: config.build.destination, filter: 'isFile'} ]
			}
		},

		concat: {
			options: {
				separator: '\n',
				stripBanners: true,
				block: true,
				line: true
			},
			source: {
				src: jsFiles,
				dest: buildFolder + '/build.js',
				nonull: true
			}
		}
	});

	// fires when any watched file is updated
	grunt.event.on('watch', function(action, filepath, target) {

		grunt.log.subhead('## ' + target + ': ' + filepath + ' has ' + action + ' ##');

		// turn on --force
		grunt.task.run('usetheforce_on');

		// find filename and extention
		var fileExt = filepath.split('.');
		fileExt = fileExt[fileExt.length-1];
	
		if(fileExt === "coffee" || fileExt === "js") {
			grunt.log.writeln('#### DETECTED COFFEE CHANGE - COMMENCING REBUILD ####');
			// run coffee only on changed files, for some reason coffee needs exact filepath in order to be able to write the file

			grunt.task.run('coffee', 'concat:source');
		}

		// changed file is a template
		else if(fileExt === "html") {
			grunt.log.writeln('#### DETECTED TEMPLATE CHANGE ####');
			grunt.task.run('copy:html');
		}

		// if changed file is an asset
		else if(filepath.indexOf('images') !== -1) {
			grunt.log.writeln('#### DETECTED IMAGE ASSET CHANGE ####');
			// grunt.task.run('imagemin');
			grunt.task.run('copy:images');
		}

		grunt.task.run('hasfailed', 'usetheforce_restore');
	});

	// avoid crash if error in build
	grunt.registerTask('usetheforce_on',
		'force the force option on if needed',
		function() {
			if ( !grunt.option( 'force' ) ) {
			grunt.config.set('usetheforce_set', true);
			grunt.option( 'force', true );
		}
	});
	grunt.registerTask('usetheforce_restore',
		'turn force option off if we have previously set it',
		function() {
		if ( grunt.config.get('usetheforce_set') ) {
			grunt.option( 'force', false );
		}
	});

	// Checks if there are any errors when running tasks in the watcher
	grunt.registerTask('hasfailed', function() {
		if (grunt.fail.errorcount > 0) {
			grunt.warn('Encountered ' + grunt.fail.errorcount + ' errors while running watcher');
			grunt.log.write('\x07'); // beep!
			grunt.fail.errorcount = 0; //overwrite
		}
	});

	grunt.registerTask('build', 'Build Microbrew.it development version (coffee, sass)', ['clean', 'coffee', 'concat:source', 'ngAnnotate:app1', 'uglify:prod', 'copy:html', 'copy:images' ]);

	grunt.registerTask('develop', 'Build Microbrew.it development version (coffee, sass)', ['clean', 'coffee', 'concat:source', 'copy:html', 'copy:images' ]);


	grunt.registerTask('default', 'Runs develop task and concurrent (watcher + connect).', ['develop', 'watch']);
};