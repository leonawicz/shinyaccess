Shiny.addCustomMessageHandler("access_lang", html_lang);

function html_lang(lang){
  $(document).ready($('html').attr('lang', lang));
}
