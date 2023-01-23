import { Controller } from "@hotwired/stimulus"
import Swal from 'sweetalert2';

// Connects to data-controller="sweet-alert"
export default class extends Controller {
  static targets = [ "button" ]
  
  connect(){
    document.getElementById('btn-hide-task-modal').click();
    this.setDeleteButton(this.buttonTarget, this.element.dataset.id);
  }
  
  setDeleteButton(element, id) {
    element.addEventListener('click', () => {
      Swal.fire({
        title: "¿Está seguro de eliminar esta tarea?",
        text: "No podrá recuperarla",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: 'Eliminar',
      }).then((result) => {
      if (result.isConfirmed) {
          const link = document.querySelector(`#delete-task-${id}`);
          link.click();
          Swal.fire(
            'Eliminado!',
            'La tarea ha sido eliminada.',
            'success'
          )
        }
      });
    });
  }
}
