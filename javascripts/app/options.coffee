saveOptions = ->
  if $(".sametab").is(":checked")
    localStorage["open_in"] = "1"
  else
    localStorage["open_in"] = "0"

  if $(".show_search").is(":checked")
    localStorage["show_search"] = "1"
  else
    localStorage["show_search"] = "0"

  $(".message").html("Options Saved.")
  setTimeout (->
    $(".message").html("")
  ), 1000

$(document).ready ->
  if localStorage["open_in"] == "1"
    $('.sametab').attr("checked", true)
  else
    $('.newtab').attr("checked", true)

  if localStorage["show_search"] == "1"
    $('.show_search').attr("checked", true)

  $("form").submit ->
    saveOptions()
    false
