var saCheckboxBinding = new Shiny.InputBinding();

$.extend(saCheckboxBinding, {
  find: function(scope) {
    return $(scope).find('.sa-input-checkbox');
  },
  getValue: function(el) {
    return $(el).find('input').checked;
  },
  setValue: function(el, value) {
    $(el).find('input').checked = value;
  },
  subscribe: function(el, callback) {
    $(el).on('change.saCheckboxBinding', function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.sa-input-checkbox');
  },
  getState: function(el) {

  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      $(el).find('input').checked = data.value;

    if (data.hasOwnProperty('label'))
      $(el).find('label').text(data.label);

    $(el).trigger('change');
  }
});
inputBindings.register(saCheckboxBinding, 'shiny.saCheckboxBinding');
