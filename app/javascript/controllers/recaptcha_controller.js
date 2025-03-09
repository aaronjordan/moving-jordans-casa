import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    window.onRecaptchaValidated = () => this.enableSelf();
  }

  enableSelf() {
    this.element.disabled = false;
    const parentData = this.element.parentElement.dataset;
    delete parentData["tooltip"];
  }
}
