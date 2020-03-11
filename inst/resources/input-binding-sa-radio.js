const saRadioBinding = new Shiny.InputBinding();

$.extend(saRadioBinding, {
  find: function(scope) {
    return $(scope).find('.sa-input-radio');
  },
  getValue: function(el) {
    // Find all inputs in checkbox groups and create an array
    let inputElements = Array.from($(el).find('input'));
    // Find input elements that are checked and find their value
    let checkedElement = inputElements.filter(inputElement => inputElement.checked === true);
    return checkedElement.value;
  },
  setValue: function(el, value) {

  },
  updateLabel: function(el, label){
    $(el).find('legend').text(label);
  },
  receiveMessage: function(el, data) {

  },
  subscribe: function(el, callback) {
    $(el).on('change.saRadioBinding', function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.saRadioBinding');
  }
});

Shiny.inputBindings.register(saRadioBinding, 'shinyaccess.saRadioBinding');
