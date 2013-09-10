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
    "compiled/public/" + path
  )
  
  # Get path to core grunt dependencies from Sails
  depsPath = grunt.option("gdsrc") or "node_modules/sails/node_modules"
  grunt.loadTasks depsPath + "/grunt-contrib-clean/tasks"
  grunt.loadTasks depsPath + "/grunt-contrib-copy/tasks"
  grunt.loadTasks depsPath + "/grunt-contrib-jst/tasks"
  grunt.loadTasks depsPath + "/grunt-contrib-watch/tasks"
  grunt.loadTasks depsPath + "/grunt-contrib-uglify/tasks"
  grunt.loadTasks depsPath + "/grunt-contrib-cssmin/tasks"
  grunt.loadTasks depsPath + "/grunt-contrib-less/tasks"
  grunt.loadNpmTasks "grunt-sails-linker"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    coffee:
      glob_to_multiple:
        expand: true
        cwd: "./source/js"
        src: ["**/*.coffee"]
        dest: "compiled/public/js"
        ext: ".js"

    jade:
      dev:
        options:
          data:
            debug: true
        files:
          "compiled/public/index.html": "source/templates/static/*.jade"

      release:
        options:
          data:
            debug: false
        files:
          "compiled/public/index.html": "source/templates/static/*.jade"

      client:
        options:
          client: true
          namespace: "JST"
        files:
          "compiled/public/templates/tmp.js": "source/templates/runtime/*.jade"

    less:
      dev:
        files: [
          expand: true
          cwd: "source/styles/"
          src: ["*.less"]
          dest: "compiled/public/styles/"
          ext: ".css"
        ]

    uglify:
      dist:
        src: ["compiled/public/concat/production.js"]
        dest: "compiled/public/min/production.js"

    cssmin:
      dist:
        src: ["compiled/public/concat/production.css"]
        dest: "compiled/public/min/production.css"

    "sails-linker":
      devStyles:
        options:
          startTag: "<!--STYLES-->"
          endTag: "<!--STYLES END-->"
          fileTmpl: "<link rel=\"stylesheet\" href=\"%s\">"
          appRoot: "compiled/public"

        
        # cssFilesToInject defined up top
        files:
          "compiled/public/**/*.html": cssFilesToInject
          "views/**/*.html": cssFilesToInject

      prodStyles:
        options:
          startTag: "<!--STYLES-->"
          endTag: "<!--STYLES END-->"
          fileTmpl: "<link rel=\"stylesheet\" href=\"%s\">"
          appRoot: "compiled/public"

        files:
          "compiled/public/index.html": ["compiled/public/min/production.css"]
          "views/**/*.html": ["compiled/public/min/production.css"]

    
    ###
    File manipulation
    ###
    copy:
      dev:
        files: [
          expand: true
          cwd: "./source"
          src: ["**/*"]
          dest: "compiled/public"
        ]

      build:
        files: [
          expand: true
          cwd: "compiled/public"
          src: ["**/*"]
          dest: "www"
        ]

    clean:
      dev: ["compiled/public/**"]
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
