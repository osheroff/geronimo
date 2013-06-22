var $ = jQuery;
$(document).ready(function () {
  var currentHash = null;

  var rewireJS = function () {
    $('.show-syntax-errors').click(function (event) {
      $(event.target).next('.geronimo-syntax-errors').show();
      return false;
    });
  };

  var fetchFileInfo = function() { 
    $.get('/file_info', function(data) { 
      $('#geronimo').html(data);
      rewireJS();
    });
  };

  var poll = function() { 
    $.getJSON('/poll', {hash: currentHash}, function(data) { 
      if ( data.update ) {
        currentHash = data.hash;
        fetchFileInfo();
        setTimeout(poll, 100);
      } else {
        setTimeout(poll, 100);
      }
    });
  }

  $(document).ready(poll);
});

var app = Sammy('#main', function() {
  this.get(/\/#\/open_file\/(.*)/, function() {
    var file = this.params['splat'];
  });
});

// start the application
app.run('#/');
