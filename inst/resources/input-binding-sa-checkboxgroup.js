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
    $(el).find('input').prop('checked', false);
    let inputElements = Array.from($(el).find('input'));
    for(let i = 0; i < inputElements.length; i++){
      if (value instanceof Array) {
        for(let j = 0; j < value.length; j++){
          if(inputElements[i].value === value[j]) inputElements[i].checked = true;
        }
      } else {
        if(inputElements[i].value === value) inputElements[i].checked = true;
      }
    }
  },
  updateLabel: function(el, label) {
    $(el).find('legend').text(label);
  },
  receiveMessage: function(el, data) {
    // If exists, then setValue below does not need to be called (redundant)
    if (data.hasOwnProperty('options')) {
      $(el).find('.sa-options-group').remove();
      $(el,"> legend").append(data.options);
    } else if(data.hasOwnProperty('value')) this.setValue(el, data.value);
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
  }
});

Shiny.inputBindings.register(saCheckboxGroupBinding, 'shinyaccess.saCheckboxGroupBinding');
