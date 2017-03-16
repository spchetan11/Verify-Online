$(document).on('turbolinks:load', function(event) {
	function readURL(input, target) {

	    if (input.files && input.files[0]) {
	        var reader = new FileReader();

	        reader.onload = function (e) {
	            target.attr('src', e.target.result);
	        }

	        reader.readAsDataURL(input.files[0]);
	    }
	}

	$("#report_datum_header").change(function(){
	    readURL(this, $('#header_preview'));
	});

	$("#report_datum_signature").change(function(){
	    readURL(this, $('#signature_preview'));
	});

	$('#header_preview, #cib1').on('click', function(e){
        e.preventDefault();
        $('#report_datum_header')[0].click();
    });
	$('#signature_preview, #cib2').on('click', function(e){
        e.preventDefault();
        $('#report_datum_signature')[0].click();
    });
});