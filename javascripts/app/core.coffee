if localStorage["open_in"] is undefined
  localStorage["open_in"] = "1" # Same tab only tab url is *rubygems.org*

if localStorage["show_search"] is undefined
  localStorage["show_search"] = "1"

RubyGems = (name, omnibox = true) ->
  query: name
  omnibox: omnibox
  configs:
    search: "https://rubygems.org/search?query="
    api: {
      gems: "https://rubygems.org/api/v1/gems/",
      search: "https://rubygems.org/api/v1/search.json?query="
    }

  exists: false
  info: {}
  searchUrl: ""
  fetch: ->
    that = this
    $.ajax
      url: @configs.api.gems + @query + ".json"
      beforeSend: ->
        $('#search').addClass('loading')
      error: ->
        that.exists = false
      success: (data) ->
        that.exists = true
        that.info = data
      complete: (data)->
        that.fetchComplete()

  results: []
  search: ->
    that = this
    $.ajax
      url: @configs.api.search + @query
      success: (data)->
        that.results = data
      complete: (data)->
        that.searchComplete()
        $("#search").removeClass('loading')
        $('.results_wrapper .loading').html("")

  fetchComplete: ->
    if this.exists
      url = this.info.project_uri
    else
      url = this.searchUrl = this.configs.search + this.query + "&source=chrome-extension"

    if this.omnibox
      chrome.tabs.getSelected undefined, (tab) ->
        chrome.tabs.update tab.id, url: url
    else
      if localStorage["show_search"] == "1" and not this.exists
        this.search()
      else
        $("#search").removeClass('loading')
        this.openTab url

  searchComplete: ->
    that = this
    $('.results_wrapper').show()
    $('.results_wrapper .results').html('')

    if this.results.length == 0
      $('.results_wrapper .results').html("No entries found at RubyGems.org")
      return

    $.each this.results, (index, value)->
      $('.results_wrapper .results').append that.itemHtml(value)

    $('.link_rubygems').click (event)->
      that.openTab that.searchUrl

    $('.link').click (event)->
      that.openTab $(event.target).attr('href')

    $(document).unbind('keydown')
    $(document).on 'keydown', (event)->
      if event.keyCode == 40
        that.selectNextLink()
        false
      else if event.keyCode == 38
        that.selectPrevLink()
        false

    $('.results_wrapper').unbind('keydown')
    $('.results_wrapper').on 'keydown', (event)->
      if event.keyCode == 74
        that.selectNextLink()
        false
      else if event.keyCode == 75
        that.selectPrevLink()
        false

  selectNextLink: ->
    if $("a.link:focus").length > 0
      $(".link:focus").next('a').focus()
    else
      $(".link").first().focus()

  selectPrevLink: ->
    if $("a.link:focus").length > 0
      $(".link:focus").prev('a').focus()
    else
      $(".link").last().focus()

  itemHtml: (item) ->
    "<a class=\"link\" href=\"#{item.project_uri}\" taget=\"_blanck\">#{item.name} <small>#{item.version}</small></a>"

  openTab: (url) ->
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
  return if query is ""
  gem = new RubyGems query, omnibox
  gem.fetch()
