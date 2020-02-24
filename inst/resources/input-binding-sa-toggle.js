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
  subscribe: function(el, callback) {
    $(el).on('change.saToggleBinding', function(event) {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off('.sa-input-toggle');
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      el.lastElementChild.getAttribute('aria-checked') = data.value;
    // Refactor reassigning labels
    if (data.hasOwnProperty('label')){
      $(el).find('span').eq(0).text(data.label[0]);
      $(el).find('span').eq(1).text(data.label[1]);
    }

    $(el).trigger('change');
  }
});

Shiny.inputBindings.register(saToggleBinding, 'shinyaccess.saToggleBinding');
