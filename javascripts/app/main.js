RubyGems = function(name){
  return {
    query: name,
    configs: {
      search: "https://rubygems.org/search?query=",
      api: "https://rubygems.org/api/v1/gems/"
    },
    exists: false,
    info: {},
    fetch: function(){
      var that = this;
      $.ajax({
        url: this.configs.api + this.query + ".json",
        error: function(){
          that.exists = false;
        },
        success: function(data){
          that.exists = true;
          that.info = data;
        }
      });
    }
  }
};



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
