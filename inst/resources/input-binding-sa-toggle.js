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
    /*$(el).on('change.saToggleBinding', function(event) {
      callback(true);
    });
    */
    $(el).on("click", function(e) {
      console.log(e.target.find('span').getAttribute('aria-checked'));
      let isChecked = e.target.getAttribute('aria-checked') === 'true';
      e.target.setAttribute('aria-checked', !isChecked);
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.sa-input-toggle');
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      el.lastElementChild.getAttribute('aria-checked') = data.value;
    // Refactor reassigning labels
    if (data.hasOwnProperty('value_labels')){
      $(el).find('span').eq(0).text(data.value_labels[0]);
      $(el).find('span').eq(1).text(data.value_labels[1]);
    }

    $(el).trigger('change');
  }
});

Shiny.inputBindings.register(saToggleBinding, 'shinyaccess.saToggleBinding');
