$(document).on('turbolinks:load', function() {
  // console.log('aaa');
  $('#college-search').bind('focus', function() {
    $(this).trigger('keyup');
  });

  $('#college-search').bind('keyup', function() {
    var dataObject, searchText;
    searchText = $(this).val();
    dataObject = $("#colleges").data("url");
    // console.log('keypress');
    
    if (searchText !== '') {
      var arr = jQuery.grep(dataObject, function( n, i ) {
        // console.log(n['name'].toLowerCase().indexOf(searchText.toLowerCase()) == 0);
        // console.log(n['name'].toLowerCase() + "  :  " + searchText.toLowerCase());
        return n['name'].toLowerCase().indexOf(searchText.toLowerCase()) == 0;
      });
      // console.log(arr);

      var i = 0;
      $('#search-result').empty();
      $.each(arr, function(i, obj) {
        $('#search-result').append(
          '<div data-url="' + i + '" class="display_box search-result" style="padding: 0;">' +
            '<a class="search-result-acnhor" href="/apply?college_id=' + obj['id'] + '&college_name=' + obj['name'] + '">' + obj['name'] + 
            '</a></div>').show();
        i++;
        $('#search-result-' + i).on('click', function() {
          // console.log(i + ' ' + obj['name']);
        });
        return;
        if (i === 0) {
          return $('#search-result').empty().hide();
        } else {
          return 0;
        }
      });
        
    } else {
      $('#search-result').empty().hide();
    }
    return false;
  });

  // $(document).mouseup(function(e) {
  //   var container;
  //   container = $('#search-field');
  //   if (!container.is(e.target) && container.has(e.target).length === 0) {
  //     $('#search-result').empty().hide();
  //   }
  // });

  // Search page code

  $('.search-field-main').bind('keyup', function() {
    var dataString, searchbox;
    searchbox = $('.search-field-main').val();
    dataString = $("#colleges").data("url");
    // console.log('keypress main');
    
    // if (searchbox !== '') {
      // console.log('search not empty')
      var arr = jQuery.grep(dataString, function( n, i ) {
        return n['name'].toLowerCase().indexOf(searchbox.toLowerCase()) >=0 ;
      });

      $.each($('.college-box'),function(i, ele){
        var boxCollegeId = $(ele).data("college-id");
        var hasMatch = false;
        $.each(arr, function(k, obj){
          if(obj.id == boxCollegeId)
            hasMatch = true;
        });
        if(hasMatch)
          $(ele).show();
        else
          $(ele).hide();
      });

      //re fresh tile spacing
      initWorkFilter();
        
    // } else {
    //   $.each($('.college-box'),function(i, ele){
    //     $(ele).show();
    //   });
    // }
    return false;
  });

});