import "startbootstrap-sb-admin-2/js/sb-admin-2.min.js"

$(document).ready(() => {
  $('.select-toggle-trigger').click((e) => {
    $(e.target)
      .toggleClass("border border-primary border-3")
      .siblings("input")
      .prop('disabled', (_, value) => { return !value; })
  });
});
