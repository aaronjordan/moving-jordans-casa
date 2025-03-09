import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}

  openNavigation() {
    document.getElementById("navigation-menu").showModal();
  }

  openExternal() {
    let e = this.element;
    while (e.parentElement) {
      if (e.tagName === "TURBO-FRAME") {
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
        this.closeGracefully(e);
        break;
      } else if (e.parentElement) {
        e = e.parentElement;
      }
    }
  }

  closeGracefully(dialog) {
    dialog.classList.add("exit");
    setTimeout(() => {
      dialog.close();
      dialog.classList.remove("exit");
    }, 1000);
  }
}
