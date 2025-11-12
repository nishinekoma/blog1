// app/javascript/controllers/image_crop_controller.js

import { Controller } from "@hotwired/stimulus";
import Cropper from 'cropperjs';

export default class extends Controller {
  static targets = ["fileInput", "image", "modal"]; // "modal"ターゲットはHTML側に追加が推奨されます
  cropper = null; 

  connect() {
    if (this.hasFileInputTarget) {
      this.fileInputTarget.addEventListener('change', this.handleFileSelect.bind(this));
    }
  }


  handleFileSelect(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        const image = document.getElementById('modal_image');
        image.src = e.target.result;

        const modalElement = document.getElementById('imageModal');
        const modal = new bootstrap.Modal(modalElement);
        modal.show();

        // Cropperインスタンスが存在する場合は破棄
        if (this.cropper) {
          this.cropper.destroy();
          this.cropper = null;
        }

        // モーダル表示時にCropperを初期化
        modalElement.addEventListener('shown.bs.modal', () => {
          this.cropper = new Cropper(image, {
            aspectRatio: 1,
            viewMode: 1,
            cropBoxResizable: true,
            cropBoxMovable: true,
            movable: true,
            zoomable: true,
            background: false,
          });
        }, { once: true });

        // 「Save changes」ボタンのクリックイベントのバインドを一度解除してから再設定
        const saveBtn = modalElement.querySelector('.btn-primary');
        // 既存のリスナーを解除 (ここではこの行は不要な可能性が高いですが、念のため残します)
        saveBtn.removeEventListener('click', this.saveChanges); 
        // 新しいリスナーを再バインド（モーダルインスタンスを渡す）
        saveBtn.addEventListener('click', this.saveChanges.bind(this, modal), { once: true }); 
      };
      reader.readAsDataURL(file);
    }
  }

  // 💡 [修正点: クロップ座標の保存ロジックを追加]
  saveChanges(modal) {
    if (this.cropper) {
      
      // 1. CropperJSからクロップ座標とサイズを取得 (整数値に丸める)
      const cropData = this.cropper.getData(true); 
      
      // 2. hidden fieldに値を設定
      // hidden fieldのIDはHTMLで定義されているIDを使用
      document.getElementById('image_x').value = Math.round(cropData.x);
      document.getElementById('image_y').value = Math.round(cropData.y);
      document.getElementById('image_w').value = Math.round(cropData.width);
      document.getElementById('image_h').value = Math.round(cropData.height);
      
      // デバッグ用にコンソールに出力して値が設定されているか確認
      console.log("Crop Coordinates Saved:", {
          x: document.getElementById('image_x').value,
          y: document.getElementById('image_y').value,
          w: document.getElementById('image_w').value,
          h: document.getElementById('image_h').value,
      });

      // 3. プレビューの更新 (ここまでのロジックは既存のものを踏襲)
      const croppedCanvas = this.cropper.getCroppedCanvas({
        width: 200, 
        height: 200 
      });
  
      if (croppedCanvas) {
        const croppedImageDataURL = croppedCanvas.toDataURL('image/png');
        document.getElementById('prev_img').src = croppedImageDataURL;
  
        // モーダルを閉じる
        modal.hide();
  
        // Cropperインスタンスを破棄
        this.cropper.destroy();
        this.cropper = null;
      }
    }
  }
}