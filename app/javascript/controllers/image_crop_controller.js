import { Controller } from "@hotwired/stimulus";
import Cropper from 'cropperjs';

export default class extends Controller {
  static targets = ["fileInput", "image", "modal"];
  cropper = null; // Cropperインスタンスをクラスプロパティとして保持

  connect() {
    if (this.hasFileInputTarget) {
      //エラーが出るが、fileInput ターゲット（fileInputTarget）に対してイベントリスナーを設定しているだけなので、問題なし
      this.fileInputTarget.addEventListener('change', this.handleFileSelect.bind(this));
    }
    // 上記の理由により何も表示しない。

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
        }, { once: true }); // イベントリスナーを1回だけ実行

        // 「Save changes」ボタンのクリックイベントのバインドを一度解除してから再設定
        const saveBtn = modalElement.querySelector('.btn-primary');
        saveBtn.removeEventListener('click', this.saveChanges); // 既存のリスナーを解除
        saveBtn.addEventListener('click', this.saveChanges.bind(this, modal), { once: true }); // 再バインド
      };
      reader.readAsDataURL(file);
    }
  }

  saveChanges(modal) {
    if (this.cropper) {
      // 画像を高解像度でクロップ
      const croppedCanvas = this.cropper.getCroppedCanvas({
        width: 200, // 表示サイズより大きめに設定
        height: 200 
      });
  
      if (croppedCanvas) {
        // ここで高解像度のキャンバスをそのまま画像として使用
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

// import { Controller } from "@hotwired/stimulus";
// import Cropper from 'cropperjs';

// export default class extends Controller {
//   static targets = ["fileInput", "image", "modal"];
//   cropper = null; // Cropperインスタンスをクラスプロパティとして保持

//   connect() {
//     this.fileInputTarget.addEventListener('change', this.handleFileSelect.bind(this));
//   }

//   handleFileSelect(event) {
//     const file = event.target.files[0];
//     if (file) {
//       const reader = new FileReader();
//       reader.onload = (e) => {
//         const image = document.getElementById('modal_image');
//         image.src = e.target.result;

//         const modalElement = document.getElementById('imageModal');
//         const modal = new bootstrap.Modal(modalElement);
//         modal.show();

//         // Cropperインスタンスが存在する場合は破棄
//         if (this.cropper) {
//           this.cropper.destroy();
//           this.cropper = null;
//         }

//         // モーダル表示時にCropperを初期化
//         modalElement.addEventListener('shown.bs.modal', () => {
//           this.cropper = new Cropper(image, {
//             aspectRatio: 1,
//             viewMode: 1,
//             cropBoxResizable: true,
//             cropBoxMovable: true,
//             movable: true,
//             zoomable: true,
//             background: false,
//           });
//         }, { once: true }); // イベントリスナーを1回だけ実行

//         // 「Save changes」ボタンのクリックイベントのバインドを一度解除してから再設定
//         const saveBtn = modalElement.querySelector('.btn-primary');
//         saveBtn.removeEventListener('click', this.saveChanges); // 既存のリスナーを解除
//         saveBtn.addEventListener('click', this.saveChanges.bind(this, modal), { once: true }); // 再バインド
//       };
//       reader.readAsDataURL(file);
//     }
//   }

//   saveChanges(modal) {
//     if (this.cropper) {
//       // 画像を高解像度でクロップ
//       const croppedCanvas = this.cropper.getCroppedCanvas({
//         width: 200, // 表示サイズより大きめに設定
//         height: 200 
//       });
  
//       if (croppedCanvas) {
//         // ここで高解像度のキャンバスをそのまま画像として使用
//         const croppedImageDataURL = croppedCanvas.toDataURL('image/png');
//         document.getElementById('prev_img').src = croppedImageDataURL;
  
//         // モーダルを閉じる
//         modal.hide();
  
//         // Cropperインスタンスを破棄
//         this.cropper.destroy();
//         this.cropper = null;
//       }
//     }
//   }
// }
