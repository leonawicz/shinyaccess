const saToggleBinding = new Shiny.InputBinding();

$.extend(saToggleBinding, {
  find: function(scope) {
    return $(scope).find('.sa-input-toggle');
  },
  getValue: function(el) {
    return $(el).find('button').attr('aria-checked');
  },
  setValue: function(el, value) {
    $(el).find('button').attr('aria-checked', value);
  },
  updateLabel: function(el, label){
    $(el).find('label').text(label);
  },
  updateValueLabels: function(el, value_labels){
    $(el).find('span').eq(0).text(value_labels[0]);
    $(el).find('span').eq(1).text(value_labels[1]);
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value')) this.setValue(el, data.value);
    if (data.hasOwnProperty('label')) this.updateLabel(el, data.label);
    if (data.hasOwnProperty('value_labels')) this.updateValueLabels(el, data.value_labels);
    $(el).trigger('change');
  },
  subscribe: function(el, callback) {
    $(el).change('saToggleBinding', function(event) {
      callback();
      // Click event listener that will update the 'checked' state of the toggle, triggering the UI change of the toggle
    }).click(function(event) {
      let isChecked = event.currentTarget.children[1].getAttribute('aria-checked') === 'true';
      event.currentTarget.children[1].setAttribute('aria-checked', !isChecked);
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.sa-input-toggle');
  }
});

Shiny.inputBindings.register(saToggleBinding, 'shinyaccess.saToggleBinding');
