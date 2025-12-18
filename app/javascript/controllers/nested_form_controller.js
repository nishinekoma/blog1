import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template", "menu"]

  // 選択メニューの表示/非表示
  toggleMenu() {
    this.menuTarget.style.display = this.menuTarget.style.display === 'none' ? 'block' : 'none'
  }

  // ブロックの追加
  add(event) {
    const type = event.currentTarget.dataset.type
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    
    // 一時的なコンテナを作ってHTMLをパース
    const div = document.createElement('div')
    div.innerHTML = content
    
    //ブロックタイプをセット
    const typeInput = div.querySelector('[data-nested-form-target="blockType"]')
    if (typeInput) typeInput.value = type
    div.querySelector('span').innerText = type.toUpperCase()

    //画面に追加
    this.containerTarget.insertAdjacentElement('beforeend', div.firstElementChild)
    this.toggleMenu()
  }

  // ブロックの削除
  remove(event) {
    const wrapper = event.currentTarget.closest(".nested-form-wrapper")
    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove()
    } else {
      wrapper.querySelector('input[name*="_destroy"]').value = "1"
      wrapper.style.display = "none"
    }
  }
}