Shiny.addCustomMessageHandler("add_lang", set_attr_lang);

function set_attr_lang(lang){
  $(document).ready($('html').attr('lang', lang));
}

Shiny.addCustomMessageHandler("add_roles", set_attr_role);

function set_attr_role(x){
  $(document).ready($('.tabbable ul').attr('role', 'tablist'));
  $(document).ready($('.tabbable ul li').attr('role', 'tab'));
}
