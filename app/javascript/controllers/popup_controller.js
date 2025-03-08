import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}

  openExternal() {
    let e = this.element;
    while (e.parentElement) {
      console.log(e.tagName);
      if (e.tagName === "TURBO-FRAME") {
        console.log("gottem", e.src);
        window.open(e.src, "_blank");
        break;
      } else if (e.parentElement) {
        e = e.parentElement;
      }
    }
  }

  close() {
    let e = this.element;
    while (e.parentElement) {
      if (e.tagName === "DIALOG") {
        e.close();
        break;
      } else if (e.parentElement) {
        e = e.parentElement;
      }
    }
  }
}
