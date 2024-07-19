import { Controller } from "@hotwired/stimulus";
import Cropper from 'cropperjs';

// import Cropper from 'cropperjs';
// Connects to data-controller="image-crop"

export default class extends Controller {
  static targets = ["fileInput", "image", "modal"];
  connect() {
    this.fileInputTarget.addEventListener('change', this.handleFileSelect.bind(this));
  }
  handleFileSelect(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        // モーダルを強制的に非表示にする
        const existingModal = document.querySelector('.modal.show');
        if (existingModal) {
          const existingBootstrapModal = bootstrap.Modal.getInstance(existingModal);
          existingBootstrapModal.hide();
        }

        // モーダルの画像を更新
        const image = document.getElementById('modal_image');
        image.src = e.target.result;

        // モーダルを再表示
        const modalElement = document.getElementById('imageModal');
        if (modalElement) {
          const modal = new bootstrap.Modal(modalElement);
          modal.show();
        }
      };
      reader.readAsDataURL(file);
    }
  }
  //   console.log('image_crop is working');
  //   console.log('Cropper is ' , Cropper);
  //   const image = this.element;
  //   const cropper = new Cropper(image, {
  //   aspectRatio: 16 / 9,
  //   crop(event) {
  //     console.log(event.detail.x);
  //     console.log(event.detail.y);
  //     console.log(event.detail.width);
  //     console.log(event.detail.height);
  //     console.log(event.detail.rotate);
  //     console.log(event.detail.scaleX);
  //     console.log(event.detail.scaleY);
  //   },
  // });
  // console.log('Cropper is ' , cropper);
  }

