import Swal from 'sweetalert2'

const initSweetalert = (element, options = {}, callback = () => {}) => {
  const swalButton = element;
  if (swalButton) { // protect other pages
    swalButton.addEventListener('click', () => {
      Swal.fire(options).then(callback); // <-- add the `.then(callback)`
    });
  }
};

export { initSweetalert };
