const toggles = document.querySelectorAll('[role="switch"]');

toggles.forEach.call(toggles, toggle => {
  // add event listener to all toggle buttons
  toggle.addEventListener('click', e => {
    // set the inverse value of 'aria-checked' as the new value
    let isChecked = toggle.getAttribute('aria-checked') === 'true';
    toggle.setAttribute('aria-checked', !isChecked);
  });
});
