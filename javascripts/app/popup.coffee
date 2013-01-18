$(document).ready ->
  $("form").submit ->
    apply($('#search').val(), false)
    false

_gaq = _gaq or []
_gaq.push ["_setAccount", "UA-13128274-10"]
_gaq.push ["_trackPageview"]
(->
  ga = document.createElement("script")
  ga.type = "text/javascript"
  ga.async = true
  ga.src = "https://ssl.google-analytics.com/ga.js"
  s = document.getElementsByTagName("script")[0]
  s.parentNode.insertBefore ga, s
)()

