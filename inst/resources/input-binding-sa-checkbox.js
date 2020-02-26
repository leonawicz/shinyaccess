const saCheckboxBinding = new Shiny.InputBinding();

$.extend(saCheckboxBinding, {
  find: function(scope) {
    return $(scope).find('.sa-input-checkbox');
  },
  getValue: function(el) {
    return $(el).find('input').checked;
  },
  setValue: function(el, value) {
    $(el).find('input').attr('aria-checked', value);
  },
  updateLabel: function(el, label){
    $(el).find('label').text(label);
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value')) this.setValue(el, data.value)
    if (data.hasOwnProperty('label')) this.updateLabel(el, data.label)
    $(el).trigger('change');
  },
  subscribe: function(el, callback) {
    $(el).on('change.saCheckboxBinding', function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.sa-input-checkbox');
  }
});
inputBindings.register(saCheckboxBinding, 'shiny.saCheckboxBinding');
