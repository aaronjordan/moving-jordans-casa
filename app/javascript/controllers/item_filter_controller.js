import { Controller } from "@hotwired/stimulus";

const DEFAULT_CATEGORY_ID = -1; // all items

export default class extends Controller {
  items = [];
  categoryToItems = {};

  connect() {
    if (this.element.tagName !== "FORM") return;

    this.detectCategories();
    this.recordItems();
    this.element.addEventListener("change", (e) => this.onCategoryUpdated(e));
  }

  detectCategories() {
    // init all keys on self as valid `category_ids`
    const ids = JSON.parse(this.element.dataset["categories"] ?? "[]");
    for (const id of ids) {
      this.categoryToItems[id] = new Set();
    }
  }

  recordItems() {
    this.items = Array.from(
      document.getElementById("items").querySelectorAll("article")
    );

    for (const item of this.items) {
      this.categoryToItems[DEFAULT_CATEGORY_ID].add(item);

      const ids = JSON.parse(item.dataset["categories"] ?? "[]");
      for (const id of ids) {
        this.categoryToItems?.[id]?.add(item);
      }
    }
  }

  onCategoryUpdated(event) {
    const nextId = event.target.value;
    const targetCategory = this.categoryToItems[nextId];
    for (const item of this.items) {
      if (targetCategory.has(item)) {
        item.classList.remove("hidden");
      } else {
        item.classList.add("hidden");
      }
    }

    placeEmptyStateIfEmpty();
  }

  toggleAvailable(e) {
    const items = Array.from(
      document.getElementById("items").querySelectorAll("article")
    );

    for (const item of items) {
      const available = item.dataset.available;
      if (available !== "true" && e.target.checked) {
        item.classList.add("hidden-av");
      } else {
        item.classList.remove("hidden-av");
      }
    }

    placeEmptyStateIfEmpty();
  }

  placeEmptyStateIfEmpty() {
    console.log("NYI: empty");
  }
}
