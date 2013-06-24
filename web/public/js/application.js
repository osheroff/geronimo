var $ = jQuery;
$(document).ready(function () {
  var currentHash = null;

  var rewireJS = function () {
    $('.show-syntax-errors').click(function (event) {
      $(event.target).next('.geronimo-syntax-errors').show();
      return false;
    });

    $('.open-editor-file').click(function (event) { 
      var href = $(event.target);
      $.getJSON('/open_file_in_editor', {uuid: href.data('uuid'), filename: href.data('filename')}, function(data) { 

      });
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

