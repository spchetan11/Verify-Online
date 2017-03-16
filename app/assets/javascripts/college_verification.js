$(document).on('turbolinks:load', function() {
	$(".update_verification_button").on('click',function(){
		currentDisplay = $(this).parent().parent().next("tr").css("display");
		if(currentDisplay == "none")
			$(this).closest("tr").next("tr").show();
		else
			$(this).closest("tr").next("tr").hide();
	});
	console.log("Initializing datepickers");

	var nowTemp = new Date();
	var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
	var dtStart = new Date(2016, 6, 1, 0, 0, 0, 0);

	$('#todate').datepicker({
		minDate: dtStart,
		maxDate: now,
		dateFormat: 'yy-mm-dd',
		onSelect: function(selectedDate, datepickerInst) {
			$(datepickerInst).hide();
		}
	});

	$("#fromdate").datepicker({
		minDate: dtStart,
		maxDate: now,
		dateFormat: 'yy-mm-dd',
		onSelect: function(selectedDate, datepickerInst) {
			$(datepickerInst).hide();
			// $('#todate').datepicker("show");
		}
	});
});