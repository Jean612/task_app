import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="modal-task"
export default class extends Controller { 
  showModal(){
    const modal = new bootstrap.Modal("#taskModal");
    modal.show();
    
    document.getElementById('taskModal').addEventListener('hidden.bs.modal', event => {
      document.getElementById('show_content_modal').innerHTML = `
        <div class="modal-header">
          <h5 class="card-title placeholder-glow">
            <span class="placeholder col-6"></span>
          </h5>
        </div>
        <div class="modal-body">
          <p class="card-text placeholder-glow">
            <span class="placeholder col-7"></span>
            <span class="placeholder col-4"></span>
            <span class="placeholder col-4"></span>
            <span class="placeholder col-6"></span>
            <span class="placeholder col-8"></span>
          </p>
          <p class="card-text placeholder-glow">
            <span class="placeholder col-7"></span>
            <span class="placeholder col-4"></span>
            <span class="placeholder col-4"></span>
            <span class="placeholder col-6"></span>
            <span class="placeholder col-8"></span>
          </p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary disabled placeholder col-1"></button>
        </div>
      `
    })
  }
}
