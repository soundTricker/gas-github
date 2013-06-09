'use strict';
var mountFolder = function (connect, dir) {
  return connect.static(require('path').resolve(dir));
};

module.exports = function (grunt) {
  // load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  // configurable paths
  var gasgitHubconfig = {
    app: 'app',
    dist: 'dist'
  };
  try {
    gasgitHubconfig.app = require('./component.json').appPath || gasgitHubconfig.app;
  } catch (e) {}

  grunt.initConfig({
    gasgithub: gasgitHubconfig,
    watch: {
      coffee: {
        files: ['<%= gasgithub.app %>/{,*/}*.coffee'],
        tasks: ['coffee:dist']
      }
    },
    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
            '.tmp',
            '<%= gasgithub.dist %>/*',
            '!<%= gasgithub.dist %>/.git*'
          ]
        }]
      },
      server: '.tmp'
    },
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      all: [
        'Gruntfile.js',
        '<%= gasgithub.app %>/{,*/}*.js'
      ]
    },
    coffee: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= gasgithub.app %>/',
          src: '{,*/}*.coffee',
          dest: '.tmp',
          ext: '.js'
        }]
      }
    },
    concat: {
      dist: {
        files: {
          '<%= gasgithub.dist %>/scripts.js': [
            '.tmp/{,*/}*.js',
            '<%= gasgithub.app %>/{,*/}*.js'
          ]
        }
      }
    },
    uglify: {
      dist: {
        files: {
          '<%= gasgithub.dist %>/scripts.js': [
            '<%= gasgithub.dist %>/scripts.js'
          ]
        }
      }
    },
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= gasgithub.app %>',
          dest: '<%= gasgithub.dist %>',
          src: [
            '*.{ico,txt}',
            '.htaccess',
            'components/**/*',
            'images/{,*/}*.{gif,webp}',
            'styles/fonts/*'
          ]
        }]
      }
    }
  });
  grunt.renameTask('regarde', 'watch');

  grunt.registerTask('build', [
    'clean:dist',
    'coffee',
    'concat',
    'copy',
    'uglify'
  ]);

  grunt.registerTask('default', ['build']);
};
