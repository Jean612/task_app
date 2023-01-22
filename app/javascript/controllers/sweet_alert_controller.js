import { Controller } from "@hotwired/stimulus"
import { initSweetalert } from '../plugins/init_sweetalert';

// Connects to data-controller="sweet-alert"
export default class extends Controller {
  static targets = [ "button" ]
  
  connect(){
    this.setDeleteButton(this.buttonTarget, this.element.dataset.id);
  }
  
  setDeleteButton(element, id) {
    initSweetalert(element, {
      title: "¿Está seguro de eliminar esta tarea?",
      text: "No podrá recuperarla",
      icon: "warning",
      showDenyButton: true,
      denyButtonText: `No eliminar`,
    }, (value) => {
      if (value) {
        const link = document.querySelector(`#delete-task-${id}`);
        link.click();
      }
    });
  }
}
