$(document).ready ->
  $("form").submit ->
    apply($('#search').val(), false)
    false
