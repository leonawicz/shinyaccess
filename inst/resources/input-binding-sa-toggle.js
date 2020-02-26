const saToggleBinding = new Shiny.InputBinding();

$.extend(saToggleBinding, {
  find: function(scope) {
    return $(scope).find('.sa-input-toggle');
  },
  getValue: function(el) {
    console.log(el)
    return el.lastElementChild.getAttribute('aria-checked');
  },
  setValue: function(el, value) {
    el.lastElementChild.getAttribute('aria-checked') = value;
  },
  subscribe: function(el, callback) {
    console.log(el)
    $(el).change('saToggleBinding', function(event) {
      callback();
    }).click(function(event) {
      let isChecked = event.currentTarget.children[1].getAttribute('aria-checked') === 'true';
      event.currentTarget.children[1].setAttribute('aria-checked', !isChecked);
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.sa-input-toggle');
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      el.children[1].setAttribute('aria-checked', data.value);

    if (data.hasOwnProperty('label')){
      $(el).find('label').text(data.label);
    }

    if (data.hasOwnProperty('value_labels')){
      $(el).find('span').eq(0).text(data.value_labels[0]);
      $(el).find('span').eq(1).text(data.value_labels[1]);
    }

    $(el).trigger('change');
  }
});

Shiny.inputBindings.register(saToggleBinding, 'shinyaccess.saToggleBinding');
