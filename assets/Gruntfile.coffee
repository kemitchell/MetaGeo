###
Gruntfile
http://gruntjs.com/configuring-tasks
###
module.exports = (grunt) ->
  
  ###
  CSS files to inject in order
  ###
  cssFilesToInject = ["styles/*.css", "/bower_components/leaflet/dist/leaflet.css", "/bootstrap/css/bootstrap.css"]
  
  # Modify css file injection paths to use 
  cssFilesToInject = cssFilesToInject.map((path) ->
    "build/public/" + path
  )
  
  # Get path to core grunt dependencies from Sails
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks("grunt-sails-linker")
  
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffee:
      glob_to_multiple:
        expand: true
        cwd: "./source/js"
        src: ["**/*.coffee"]
        dest: "build/public/js"
        ext: ".js"

    jade:
      dev:
        options:
          data:
            debug: true
        files:
          "build/public/index.html": "source/templates/static/*.jade"

      release:
        options:
          data:
            debug: false
        files:
          "build/public/index.html": "source/templates/static/*.jade"

      client:
        options:
          client: true
          namespace: "JST"
        files:
          "build/public/templates/tmp.js": "source/templates/runtime/*.jade"

    less:
      dev:
        files: [
          expand: true
          cwd: "source/styles/"
          src: ["*.less"]
          dest: "build/public/styles/"
          ext: ".css"
        ]

    uglify:
      dist:
        src: ["build/public/concat/production.js"]
        dest: "build/public/min/production.js"

    cssmin:
      dist:
        src: ["build/public/concat/production.css"]
        dest: "build/public/min/production.css"

    "sails-linker":
      devStyles:
        options:
          startTag: "<!--STYLES-->"
          endTag: "<!--STYLES END-->"
          fileTmpl: "<link rel=\"stylesheet\" href=\"%s\">"
          appRoot: "build/public"

        
        # cssFilesToInject defined up top
        files:
          "build/public/**/*.html": cssFilesToInject
          "views/**/*.html": cssFilesToInject

      prodStyles:
        options:
          startTag: "<!--STYLES-->"
          endTag: "<!--STYLES END-->"
          fileTmpl: "<link rel=\"stylesheet\" href=\"%s\">"
          appRoot: "build/public"

        files:
          "build/public/index.html": ["build/public/min/production.css"]
          "views/**/*.html": ["build/public/min/production.css"]

    
    ###
    File manipulation
    ###
    copy:
      dev:
        files: [
          expand: true
          cwd: "./source"
          src: ["**/*"]
          dest: "build/public"
        ]

      build:
        files: [
          expand: true
          cwd: "build/public"
          src: ["**/*"]
          dest: "www"
        ]

    clean:
      dev: ["build/public/**"]
      build: ["www"]

    watch:
      source:
        
        # source to watch:
        files: ["source/**/*"]
        
        # When source are changed:
        tasks: ["compileAssets", "linkAssets"]

  
  # When Sails is lifted:
  grunt.registerTask "default", ["compileAssets", "linkAssets", "watch"]
  grunt.registerTask "compileAssets", ["clean:dev", "coffee", "jade:dev", "jade:client", "less:dev", "copy:dev"]
  
  # Update link/script/template references in `assets` index.html
  grunt.registerTask "linkAssets", ["sails-linker:devStyles"]
  
  # Build the assets into a web accessible folder.
  # (handy for phone gap apps, chrome extensions, etc.)
  grunt.registerTask "build", ["compileAssets", "linkAssets", "clean:build", "copy:build"]
  
  # When sails is lifted in production
  grunt.registerTask "prod", ["clean:dev", "less:dev", "copy:dev", "uglify", "cssmin", "sails-linker:prodStyles"]
