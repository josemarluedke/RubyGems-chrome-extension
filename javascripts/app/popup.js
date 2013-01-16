$(document).ready(function(){
  chrome.tabs.getSelected(null, function(tab) {
    window.current_tab = tab
  });

  $('form').submit(function(){
    app = new RubyGems($('#search').val());
    app.fetch()
    $(document).ajaxComplete(function() {
      if(app.exists){
        var url = app.info.project_uri
      } else {
        var url = app.configs.search + app.query + "&source=chrome-extension"
      }
      if((/rubygems\.org/).test(current_tab.url)){
        chrome.tabs.update(current_tab.id, {url: url});
        window.close();
      } else {
        chrome.tabs.create({url: url});
      }
    });
    return false;
  });
});
