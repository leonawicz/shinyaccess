const dsmCheckboxGroupInputBinding = new Shiny.InputBinding();

$.extend(dsmCheckboxGroupInputBinding, {
  find: function(scope) {
    console.log("HERE")
    return $(scope).find('.dsm-input-checkboxgrp');
  },
  getValue: function(el) {
    let children = Array.from(el.currentTarget.children);
    let values = children.filter(child => child.nodeName === 'INPUT').filter(child => child.checked === true).map(child => child.value)
    return values;
  },
  subscribe: function(el, callback) {
    $(el).on('change.dsmCheckboxGroupInputBinding', function(event) {
      callback();
    });
  }
});

Shiny.inputBindings.register(dsmCheckboxGroupInputBinding, 'shinyaccess.dsmCheckboxGroupInputBinding');
