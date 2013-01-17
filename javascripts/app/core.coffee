if localStorage["open_in"] is undefined
  localStorage["open_in"] = "1" # Same tab only tab url is *rubygems.org*

RubyGems = (name) ->
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
      beforeSend: ->
        $('#search').addClass('loading')
      error: ->
        that.exists = false

      success: (data) ->
        that.exists = true
        that.info = data


openTab = (url) ->
  if localStorage["open_in"] == "1"
    chrome.tabs.getSelected null, (tab) ->
      if (/rubygems\.org|chrome:\/\/newtab/).test(tab.url)
        chrome.tabs.update tab.id, url: url
        window.close()
      else
        chrome.tabs.create url: url
  else
    chrome.tabs.create url: url


window.apply = (query, omnibox = true) ->
  gem = new RubyGems query
  gem.fetch()

  $(document).ajaxComplete ->
    if gem.exists
      url = gem.info.project_uri
    else
      url = gem.configs.search + gem.query + "&source=chrome-extension"

    if omnibox
      chrome.tabs.getSelected undefined, (tab) ->
        chrome.tabs.update tab.id, url: url
    else
      openTab url
