import swal from 'sweetalert';

const initSweetalert = (element, options = {}, callback = () => {}) => {
  const swalButton = element;
  if (swalButton) { // protect other pages
    swalButton.addEventListener('click', () => {
      swal(options).then(callback); // <-- add the `.then(callback)`
    });
  }
};

export { initSweetalert };
