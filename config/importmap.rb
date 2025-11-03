# config/importmap.rb (最終調整)

pin "application", to: "application.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers", preload: true

pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
# 💡 Cropper.jsにも preload: true を追加
pin "cropperjs", to: "https://unpkg.com/cropperjs@1.6.2/dist/cropper.esm.js", preload: true