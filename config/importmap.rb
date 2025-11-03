# config/importmap.rb

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Bootstrapをピン留め（HTMLのCDNと併用されることで安定動作）
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true

# 安定動作が確認された jspm.io の Cropper.js パス
pin "cropperjs", to: "https://ga.jspm.io/npm:cropperjs@1.6.2/dist/cropper.esm.js"