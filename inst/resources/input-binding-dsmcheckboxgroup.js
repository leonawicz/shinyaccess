const dsmCheckboxGroupInputBinding = new Shiny.InputBinding();

$.extend(dsmCheckboxGroupInputBinding, {
  find: function(scope) {
    return $(scope).find('.dsm-input-checkboxgrp');
  },
  getValue: function(el) {
    // Find all inputs in checkbox groups and create an array
    let inputElements = Array.from($(el).find('input'));
    // Find input elements that are checked and find their value
    let values = inputElements.filter(inputElement => inputElement.checked === true).map(inputElement => inputElement.value);
    return values;
  },
  setValue: function(el, value){
    // Clear all checkboxes
    $(el).find('input').prop('checked', false);
    // Accept array

    // Else assume it's a single value
  },
  subscribe: function(el, callback) {
    $(el).on('change.dsmCheckboxGroupInputBinding', function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.dsmCheckboxGroupInputBinding');
  },
});

Shiny.inputBindings.register(dsmCheckboxGroupInputBinding, 'shinyaccess.dsmCheckboxGroupInputBinding');
