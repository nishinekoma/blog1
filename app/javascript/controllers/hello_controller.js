import { Controller } from "@hotwired/stimulus"
import add from './test.js';
export default class extends Controller {
  static targets = ["name", "output"]; // ターゲットを定義


  
  connect() {
    //this 今回はconnectが呼ばれた元がthisになる。
    console.log("conect this is : ",this);
    console.log("conect this.element is : ",this.element);
    console.log("conect this.element.textContent is : ",this.element.textContent);
    console.log("HelloController connected"); // ログを追加
  }

  greet() {
    console.log("Greet method called"); // ログを追加
    console.log("conect this is : ",this);// ログを追加
    // ここで add 関数を使うことができます
    const result = add(1, 2);
    console.log(result);

    // ターゲット要素に結果を表示
    this.outputTarget.textContent = `Result: ${result}`;

  }
}
