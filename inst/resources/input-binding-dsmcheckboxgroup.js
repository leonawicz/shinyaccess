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
    // Loop through which checkboxes should be checked based on the value array and update the checkbox
    let inputElements = Array.from($(el).find('input'));
    for(let i = 0; i < inputElements.length; i++){
      for(let j = 0; j < value.length; j++){
        if(inputElements[i].value === value[j]) inputElements[i].checked = true;
      }
    }
  },
  updateLabel: function(el, label) {
    console.log('updateLabel!')
  },
  receiveMessage: function(el, data) {
   console.log($(el), data)
    // If data.options exist, replace all the options with new ones
    if (data.hasOwnProperty('options')) {
      $(el).find('div.checkbox-inputgrp').remove;
      $(el).append(data.options);
    }
    // If data.value exists, update what values are checked or not checked
    if(data.hasOwnProperty('value')) this.setValue(el, data.value);
    //If data.label exists, update the legend element
    //updateLabel(data.label, this._getLabelNode(el));

    $(el).trigger('change');
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
