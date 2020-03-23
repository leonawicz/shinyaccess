const saRadioBinding = new Shiny.InputBinding();

$.extend(saRadioBinding, {
  find: function(scope) {
    return $(scope).find('.sa-input-radio');
  },
  getValue: function(el) {
    // Find all inputs in checkbox groups and create an array
    let inputElements = Array.from($(el).find('input'));
    // Find input elements that are checked and find their value
    let checkedElement = inputElements.filter(inputElement => inputElement.checked === true)[0].value;
    return checkedElement;
  },
  setValue: function(el, value) {
    console.log("setValue ", el, value);
    // Loop through which checkboxes should be checked based on the value array and update the checkbox
    let inputElements = Array.from($(el).find('input'));
    for(let i = 0; i < inputElements.length; i++){
      if(inputElements[i].value === value) inputElements[i].checked = true;
    }
  },
  updateLabel: function(el, label){
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
