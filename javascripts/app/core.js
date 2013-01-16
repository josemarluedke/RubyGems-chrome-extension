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
