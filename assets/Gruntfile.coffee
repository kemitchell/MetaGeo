###
Gruntfile
http://gruntjs.com/configuring-tasks
###
module.exports = (grunt) ->
  
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-browserify')
  
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffee:
      glob_to_multiple:
        expand: true
        cwd: "./src"
        src: ["**/*.coffee"]
        dest: "dist"
        ext: ".js"

    browserify:
      dist:
        files:
          'dist/bundle.js': ["dist/app.js"]

    jade:
      dev:
        options:
          data:
            debug: true
        files:
          "dist/index.html": "templates/static/*.jade"

      release:
        options:
          data:
            debug: false
        files:
          "dist/index.html": "templates/static/*.jade"

      client:
        options:
          client: true
          namespace: "JST"
        files:
          "dist/templates/tmp.js": "templates/runtime/*.jade"

    less:
      dev:
        files: [
          expand: true
          cwd: "styles/"
          src: ["*.less"]
          dest: "dist"
          ext: ".css"
        ]

    uglify:
      dist:
        src: ["build/public/concat/production.js"]
        dest: "build/public/min/production.js"

    cssmin:
      dist:
        src: ["dist/main.css", "node_modules/leaflet/dist/leaflet.css", "bootstrap/css/bootstrap.css"]
        dest: "dist/main.min.css"
    
    ###
    File manipulation
    ###
    clean: ["dist/**"]

    copy:
      main:
        files: [
          {expand: true, src: ['images/**'], dest: 'dist/', filter: 'isFile'},
          { src: ['robots.txt'], dest: 'dist/'}
        ]

    watch:
      source:
        
        # source to watch:
        files: ["./*"]
        
        # When source are changed:
        tasks: ["compileAssets"]

  grunt.registerTask "default", ["compileAssets", "watch"]
  grunt.registerTask "compileAssets", ["clean", "copy:main", "coffee",  "jade:dev", "jade:client", "browserify", "less:dev", "cssmin"]
  grunt.registerTask "prod", ["clean:dev", "less:dev", "uglify", "cssmin"]
