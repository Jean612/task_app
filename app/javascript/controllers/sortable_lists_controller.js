import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs'

// Connects to data-controller="sortable-lists"
export default class extends Controller {
  connect() {
    const lists = document.querySelectorAll('.task-sortable-list')
    lists.forEach(list => {
      new Sortable(list, {
          group: 'shared',
          animation: 150,
          handle: '.handle',
          ghostClass: 'blue-background-class',
          
          onEnd: function (evt) {
            const itemEl = evt.item,
            id = itemEl.dataset.id,
            newState = evt.to.dataset.state,
            token = document.querySelector("[name='csrf-token']").content;
            
            fetch(`/tasks/${id}/update_state`, {
              method: 'PUT',
              headers: {
                "X-CSRF-Token": token,
                "Content-Type": "application/json",
                "Accept": "application/json"
              },
              body: JSON.stringify({ state: newState })
            }).then(response => response.json()).then( data => {
              const toastElement = document.getElementById("message_update_state");
              toastElement.classList.remove('bg-danger');
              toastElement.classList.remove('bg-success');
              toastElement.classList.add(data.error ? 'bg-danger' : 'bg-success');
              toastElement.querySelector('.toast-body').innerText = data.message;
              const toast = new bootstrap.Toast(toastElement);
              toast.show();
            })
            
            //evt.to;    // target list
            //evt.from;  // previous list
            //evt.oldIndex;  // element's old index within old parent
            //evt.newIndex;  // element's new index within new parent
            //evt.oldDraggableIndex; // element's old index within old parent, only counting draggable elements
            //evt.newDraggableIndex; // element's new index within new parent, only counting draggable elements
            //evt.clone // the clone element
            //evt.pullMode;  // when item is in another sortable: `"clone"` if cloning, `true` if moving
          },
      });
    });
  }
}
