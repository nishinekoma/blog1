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
    //https://stackoverflow.com/questions/26634616/filereader-upload-same-file-again-not-working
    // 二度同じが画像が選択された時の対策　ファイル選択されてませんを回避する
    //variable to get the name of the uploaded file

    console.log(event);
    const file = event.target.files[0];
    console.log("file is ",file)
    var fileName = file.name;
    console.log("fileName is :",fileName);
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
      // ファイル入力をリセットして、同じ画像を再度選択できるようにする
      event.target.value = '';
      const file = event.target.files[0];
      console.log("after event is ",event);
      console.log("after file is ",file);
      console.log("after fileName is :",fileName);
      console.log("")
      //replace "No file chosen" with the new file name
      // $('#trim_img_uploder').html(fileName);

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