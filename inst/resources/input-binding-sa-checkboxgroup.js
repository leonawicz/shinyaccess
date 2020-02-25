const saCheckboxGroupBinding = new Shiny.InputBinding();

$.extend(saCheckboxGroupBinding, {
  find: function(scope) {
    return $(scope).find('.sa-input-checkboxgrp');
  },
  getValue: function(el) {
    // Find all inputs in checkbox groups and create an array
    let inputElements = Array.from($(el).find('input'));
    // Find input elements that are checked and find their value
    let values = inputElements.filter(inputElement => inputElement.checked === true).map(inputElement => inputElement.value);
    return values;
  },
  setValue: function(el, value) {
    // Clear all checkboxes
    $(el).find('input').prop('checked', false);
    // Loop through which checkboxes should be checked based on the value array and update the checkbox
    let inputElements = Array.from($(el).find('input'));
    for(let i = 0; i < inputElements.length; i++){
      for(let j = 0; j < value.length; j++){
        if(inputElements[i].value === value[j]) inputElements[i].checked = true;
      }
    }
  },
  updateLabel: function(el, label) {
    $(el).find('legend').text(label);
  },
  receiveMessage: function(el, data) {
    // If data.options exist, replace all the options with new ones
    if (data.hasOwnProperty('options')) {
      $(el).find('.sa-options-group').remove();
      $(el,"> legend").append(data.options);
    }
    // If data.value exists, update what values are checked or not checked
    if(data.hasOwnProperty('value')) this.setValue(el, data.value);
    //If data.label exists, update the legend element
    if(data.hasOwnProperty('label')) this.updateLabel(el, data.label);

    $(el).trigger('change');
  },
  subscribe: function(el, callback) {
    $(el).on('change.saCheckboxGroupBinding', function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.saCheckboxGroupBinding');
  },
});

Shiny.inputBindings.register(saCheckboxGroupBinding, 'shinyaccess.saCheckboxGroupBinding');
