# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

#add  doc:https://github.com/twbs/bootstrap-rubygem
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
# config/importmap.rb
pin "cropperjs", to: "https://ga.jspm.io/npm:cropperjs@1.6.2/dist/cropper.esm.js"

