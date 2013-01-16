$(document).ready ->
  chrome.tabs.getSelected null, (tab) ->
    window.current_tab = tab

  $("form").submit ->
    app = new window.RubyGems($("#search").val())
    app.fetch()
    $(document).ajaxComplete ->
      if app.exists
        url = app.info.project_uri
      else
        url = app.configs.search + app.query + "&source=chrome-extension"
      if (/rubygems\.org/).test(current_tab.url)
        chrome.tabs.update current_tab.id,
          url: url

        window.close()
      else
        chrome.tabs.create url: url

    false
