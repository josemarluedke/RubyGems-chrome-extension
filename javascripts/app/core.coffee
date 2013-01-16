window.RubyGems = (name) ->
  query: name
  configs:
    search: "https://rubygems.org/search?query="
    api: "https://rubygems.org/api/v1/gems/"

  exists: false
  info: {}
  fetch: ->
    that = this
    $.ajax
      url: @configs.api + @query + ".json"
      error: ->
        that.exists = false

      success: (data) ->
        that.exists = true
        that.info = data

