// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
// require jquery-ui
//= require jquery.easing.1.3
//= require bootstrap
//= require SmoothScroll
//= require jquery.scrollTo.min
//= require jquery.localScroll.min
//= require jquery.viewport.mini
//= require jquery.countTo
//= require jquery.appear
//= require jquery.sticky
//= require jquery.parallax-1.1.3
//= require owl.carousel.min
//= require isotope.pkgd.min
//= require imagesloaded.pkgd.min
//= require jquery.magnific-popup.min
//= require wow.min
//= require masonry.pkgd.min
//= require jquery.simple-text-rotator.min
//= require all
//= require placeholder
//= require_directory .
//= require turbolinks

$(document).on('turbolinks:load', function() {
	$('#verify-status').bind('submit', function(e) {
	    e.preventDefault();
	    var id = $('#everify')[0].value;
	    if(id != ''){
			$('#e_verification_loader').fadeIn(50);
				$.ajax({
					type: 'GET',
					url: 'verification_status.json?id=' + id,
					cache: false,
				}).done( function(response) {
				    response = response[0];
				    // console.log(response);
				    if(typeof response === 'undefined' || response.length == 0){
			    		$('#ev_success_content').hide();
			    		$('#ev_verify_status').html("Verification ID <strong>" + ($('#everify')[0].value.toUpperCase()) + "</strong> is <strong>INVALID</strong>");
				    }else { 
						$('#ev_success_content').show();
						$('#ev_verify_status').html("Verification ID <strong>" + ($('#everify')[0].value.toUpperCase()) + "</strong> is <strong>VALID</strong>");
						$('#ev_name').text(response.name + "");
						$('#ev_hallticket_no').text(response.hallticket_no + "");
				    }
				    $("#eVerifyModal").modal();
				 }).always( function(response) {
				    $('#e_verification_loader').fadeOut(50);
			});
	    
	    }
  
  	});

});






