// app/javascript/controllers/image_crop_controller.js

import { Controller } from "@hotwired/stimulus";
// Bootstrapのインポートは不要（window.bootstrapを使用するため）

export default class extends Controller {
  // fileInput, modalImage のターゲットはHTMLで必要
  static targets = ["fileInput", "modalImage"]; 
  
  cropper = null; 

  connect() {
    console.log("Image Crop Controller connected.");
  }


  handleFileSelect(event) {
    console.log("File selected. Attempting to open modal.");
    
    // actionがfile input自体にバインドされているため、event.targetからファイルを取得
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      
      reader.onload = (e) => {
        if (this.cropper) {
          this.cropper.destroy();
          this.cropper = null;
        }

        this.modalImageTarget.src = e.target.result;
        
        // 2. モーダルを発火
        const modalElement = document.getElementById('imageModal');
        
        // window.bootstrap.Modal を使用
        const modal = new window.bootstrap.Modal(modalElement); 
        modal.show();
        
        console.log("Modal instance created and show() called.");

        // 3. モーダル表示完了イベント時にCropperを初期化
        modalElement.addEventListener('shown.bs.modal', () => {
          this.cropper = new window.Cropper(this.modalImageTarget, {
            aspectRatio: 1,
            viewMode: 1,
            cropBoxResizable: true,
            cropBoxMovable: true,
            movable: true,
            zoomable: true,
            background: false,
          });
          console.log("Cropper initialized.");
        }, { once: true });
      };
      
      reader.readAsDataURL(file);
    }
  }


  saveChanges(event) {
    event.preventDefault(); 
    
    if (this.cropper) {
      const croppedCanvas = this.cropper.getCroppedCanvas({
        width: 200, 
        height: 200 
      });

      if (croppedCanvas) {
        document.getElementById('prev_img').src = croppedCanvas.toDataURL('image/png');
        
        // 1. モーダルを閉じる
        const modalElement = document.getElementById('imageModal');
        // window.bootstrap.Modal を使用
        const modal = window.bootstrap.Modal.getInstance(modalElement);
        if (modal) {
          modal.hide();
        }

        // 2. Cropperインスタンスを破棄
        this.cropper.destroy();
        this.cropper = null;
      }
    }
  }
}