var $ = jQuery;
$(document).ready(function () {
  var currentFile = null;

  var fetchFileInfo = function() { 
    $.get('/file_info', function(data) { 
      $('#geronimo').html(data);
    });
  };

  var poll = function() { 
    $.getJSON('/poll', {file: currentFile}, function(data) { 
      if ( data.update ) {
        currentFile = data.file;
        fetchFileInfo();
        setTimeout(poll, 100);
      } else {
        setTimeout(poll, 100);
      }
    });
  }

  poll();
});

var app = Sammy('#main', function() {
  this.get(/\/#\/open_file\/(.*)/, function() {
    var file = this.params['splat'];
  });
});

// start the application
app.run('#/');
