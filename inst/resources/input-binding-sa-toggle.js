const saToggleBinding = new Shiny.InputBinding();

$.extend(saToggleBinding, {
  find: function(scope) {
    return $(scope).find('.sa-input-toggle');
  },
  getValue: function(el) {
    return el.lastElementChild.getAttribute('aria-checked');
  },
  setValue: function(el, value) {
    el.lastElementChild.getAttribute('aria-checked') = value;
  },
  // WORK ON THIS
  subscribe: function(el, callback) {
    $(el).on('change.checkboxInputBinding', function(event) {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off('.sa-input-toggle');
  },
  // do we need this?
  getState: function(el) {
    return {
      label: "COMPLETE THIS",
      value: el.lastElementChild.getAttribute('aria-checked')
    };
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      el.lastElementChild.getAttribute('aria-checked') = data.value;

    // checkboxInput()'s label works different from other
    // input labels...the label container should always exist
    // WORK ON THIS
    if (data.hasOwnProperty('label'))
      $(el).parent().find('span').text(data.label);

    $(el).trigger('change');
  }
});

Shiny.inputBindings.register(saToggleBinding, 'shinyaccess.saToggleBinding');
