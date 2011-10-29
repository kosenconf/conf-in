//= require jquery
//= require jquery_ujs
//= require_tree .

function remove_fields(link) {
  $(link).prev(":hidden").val("1");
  $(link).parents(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(
    content.replace(regexp, new_id)
  );
}

