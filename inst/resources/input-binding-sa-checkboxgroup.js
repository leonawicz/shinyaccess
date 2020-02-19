const saCheckboxGroupBinding = new Shiny.InputBinding();

$.extend(saCheckboxGroupBinding, {
  find: function(scope) {
    return $(scope).find('.sa-input-checkboxgrp');
  },
  getValue: function(el) {
    // Find all inputs in checkbox groups and create an array
    let inputElements = Array.from($(el).find('input'));

    let options = Array.from($(el).find('li'));
    console.log(options)
    //options is an array of objects

    for (var i = 0; i < options.length; i++) {
      //console.log(options[i].children[0].value)
      //console.log(options[i].children[1].innerHTML)
      options[i] = { value:   options[i].children[0].value,
                   label:   options[i].children[1].innerHTML };
    }
    console.log(options);
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
getState: function(el) {

    //var $objs = $('input:checkbox[name="' + $escape(el.id) + '"]');
    // Store options in an array of objects, each with with value and label
    let options = Array.from($(el).find('li'));
    //options is an array of objects

    for (var i = 0; i < options.length; i++) {
      options[i] = { value:   options[i].children[0].value,
                     label:   options[0].children[1].innerHTML };
    }

    let labelText = $(el).find('legend').text();

    let state = {
      label: labelText,
      value: this.getValue(el),
      options: options
    };

    console.log('state = ', state);

    return state;
  },
  updateLabel: function(el, label) {
    $(el).find('legend').text(label);
  },
  receiveMessage: function(el, data) {
    console.log($(el).find('legend').text())
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
