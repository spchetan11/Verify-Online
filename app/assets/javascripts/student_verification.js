$(document).on('turbolinks:load', function(event) {
  var MAX_FILE_SIZE = 512; //kB
  var table_data = new Array();
  var verification_amount = 0;
  var verification_amount_total = 0;
  var lookup;
  var verifications_ids_to_send = {};
  verifications_ids_to_send.ids = [];

  var tax_percent = parseFloat($("#rails-data").data("tax-percent"));
  var default_verf_amount = parseFloat($("#rails-data").data("default-verf-amount"));
  
  var dataToSend = {};
  dataToSend["ids"] = [];
  dataToSend["verification_requests"] = []; 

  // Init
  // $(".hasDatepicker").datepicker();
  // console.log("datepicker initialized");


  // Validates if file exists and filesize < MAX_FILE_SIZE
  $.fn.fileValidate = function(file){
    if(file == undefined){
      // console.log("No file selected");
      $('#error_explanation').css("display","inherit");
      $('#error_explanation').html("No file selected");
      return false;
    }
    // console.log("filesize : " + file.size);
    if(file.size > MAX_FILE_SIZE * 1024){
      // console.log("File size exceeds limit : " + (file.size/1024) + "KB");
      $("#error_explanation").css("display","inherit");
      $("#error_explanation").html("File size exceeds 512 KB");
      return false;
    }
    
    return true;
  }

  // Make AJAX call to get verification amount and display it below select box.
  // Handles loader also.
  $.fn.loadVerificationAmount = function(id){
    if(id != ''){
      $('#verification_amount_loader').fadeIn(50);
    
      $.ajax({
        type: 'GET',
        url: 'colleges/' + id + '.json',
        cache: false,
      })
          .done( function(response) {
            verification_amount = response.verification_amount;
            $('#verification_amount_lable').text(verification_amount + "");
          })

          .always( function(response) {
            $('#verification_amount_loader').fadeOut(50);
      });
    
    } else {
    
      verification_amount = 0;
      $('#verification_amount_lable').text(verification_amount + "");
    }
  
  }


  // Converts base64 string to Blob
  $.fn.b64toBlob = function(b64DataString) {
    var b64DataArray = b64DataString.split(";")
    var b64Data = b64DataArray[1].split(",")[1]
    var contentType = b64DataArray[0].split(":")[1]
    var sliceSize = 512;
      contentType = contentType || '';
      sliceSize = sliceSize || 512;

      var byteCharacters = atob(b64Data);
      var byteArrays = [];

      for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
          var slice = byteCharacters.slice(offset, offset + sliceSize);

          var byteNumbers = new Array(slice.length);
          for (var i = 0; i < slice.length; i++) {
              byteNumbers[i] = slice.charCodeAt(i);
          }

          var byteArray = new Uint8Array(byteNumbers);

          byteArrays.push(byteArray);
      }

      var blob = new Blob(byteArrays, {type: contentType});
      return blob;
  }

  // End of Helper methods

  // Update verification amount when a college is selected from select box
  $('#college').on('change', function() {
    $().loadVerificationAmount($('#college')[0].value);
  });

  // Set default college if set in GET parameters. Check $('#rails-data') element for this.
  $("#college").val($("#rails-data").data("college-id"));
  $("#college").trigger('change');

  // Prevent form submit and locally cache data so that it can be posted later.
  $('#form').on('submit', function(event){
    event.preventDefault();
    $("#error_explanation").css("display","none");

    var fr = new FileReader();
    var verification_stub = new Array();
    
    // Validate file nil and filesize manually.
    if(!$.fn.fileValidate($('#verify_document')[0].files[0])){
      // console.log('File validation failed.');
      return;
    }

    verification_stub['id'] = table_data.length;
    verification_stub['college_id'] = $('#college')[0].value;
    verification_stub['college_name'] = $("#college option")[$("#college")[0].selectedIndex].text;
    verification_stub['verification_amount'] = verification_amount;
    verification_stub['name'] = $('#name').val();
    verification_stub['hallticket_no'] = $('#hallticket_no').val();
    verification_stub['file_link'] = URL.createObjectURL(($('#verify_document')[0]).files[0]);
    verification_stub['file_name'] = ($('#verify_document')[0]).files[0].name;
    
    fr.readAsDataURL(document.getElementById('verify_document').files[0]);
    fr.onloadend = function(){
      verification_stub['file_obj'] = $().b64toBlob(fr.result);
    }

    table_data.push(verification_stub);

    // reset fields
    verification_amount = 0;
    $('#verification_amount_lable').text(verification_amount + "");
    $("#form").trigger('reset');

    // add row to table
    $().renderTable();
    

  });

  $.fn.renderTable = function(){
    if(table_data.length == 0 && $("#filler-box").css("display") == 'none'){
      $("#filler-box").css("display","inherit");
      $("#verifications-table").css("display","none");
    } else {
      $("#filler-box").css("display","none");
      $("#verifications-table").css("display","inherit");
    }

    $('#verifications_tbody').html('');
    verification_amount_total = 0;

    for (var i = 0; i < table_data.length; i++) {
      verification_stub = table_data[i];
      var tax = Math.round(default_verf_amount * ( 1 + tax_percent / 100));
      $('#verifications_tbody').append('<tr>' +
        '<td>' + (i + 1) + '</td>' + 
        '<td>' + verification_stub['college_name'] + '</td>' + 
        '<td>' + verification_stub['name'] + '</td>' + 
        '<td>' + verification_stub['hallticket_no'] + '</td>' + 
        '<td><a href="' + verification_stub['file_link'] + '" target="blank"><i class="fa fa-download dark"></i></a></td>' + 
        '<td>Rs ' + verification_stub['verification_amount'] + '</td>' + 
        '<td>Rs ' + tax + '</td>' + 
        '<td>Rs ' + (verification_stub['verification_amount'] + tax) + '</td>' + 
        '<td class="ver-delete"><a style="cursor:pointer;"><i class="fa fa-times dark"></i></a></td>' + 
        '<td class="ver-progress" style="display: none; width: 0px; background-color: rgba(49, 175, 28, 0.258824); position: absolute;"></td>' +
        '</tr>');

        verification_amount_total += (verification_stub['verification_amount'] + tax);
    };
    

    $('#verification_amount_total_lable').text(verification_amount_total + "");


    $('.ver-delete').on('click', function(){
      // console.log('del pressed');
      indexToDelete = $(this).parent().index();
      table_data = jQuery.grep(table_data, function(value, i) {
        return i != indexToDelete;
      });
      $().renderTable();
    });
  }

  $("#btnProceedToPay").on('click', function(){
    if(!$('#agreement').is(':checked')){
      alert("You have to accept terms of agreement to proceed");
      return;
    }
    // Disable $("#btnProceedToPay")
    $(this).prop('disabled', true);

    // Show Loaders
    $("#loader_msg").html("Sending verification request(s)<br>Please wait...");
    $('#ptp_loader, #ptp_loader div').show();

    lookup = {};
    for (var i = 0, len = table_data.length; i < len; i++) {
        lookup[table_data[i].id] = table_data[i];
    }
    // console.log("Lookup generated");
    // console.log(lookup);

    // Initiate file upload to AWS S3
    $().fileUploadToS3();
  });

  $.fn.checkAndUpload = function(numFilesUploaded, temp_id){
    // Construct row data to be sent
    var data_to_send = {};
    var verification_request = {};
    verification_request["user_id"] = $("#rails-data").data("user-id");
    verification_request["college_id"] = lookup[temp_id].college_id;
    verification_request["name"] = lookup[temp_id]["name"];
    verification_request["hallticket_no"] = lookup[temp_id].hallticket_no;
    verification_request["document_link"] = lookup[temp_id].document_link;
    data_to_send.verification_request = verification_request;

    // console.log("Data row prepared to be sent: ");
    // console.log(data_to_send);

    $.ajax({
      url: "/add_verification",
      type: 'POST',
      data: JSON.parse(JSON.stringify(data_to_send)),
      context: document.body
      }).done(function(data){
        verifications_ids_to_send.ids.push(data["id"]);

        if(table_data.length == numFilesUploaded){
          // console.log("All data collected until now. Use this to create form and execute a submit --> ");
          // console.log(table_data);

          // console.log("Verification IDs to be sent --> ");
          // console.log(verifications_ids_to_send);

          ids_to_send = {};
          ids_to_send["verification_ids"] = verifications_ids_to_send.ids.toString();

          // $("#loader_msg").html("Processing your request. Please wait, this could take a while.");
          

          $.ajax({
            url: "/proceed_to_pay",
            type: 'POST',
            data: JSON.parse(JSON.stringify(ids_to_send)),
            context: document.body
            }).done(function(data){
              
              // Redirect to the payment link received from server
              window.location.replace(data["url"]);

            }).always(function() {
              // Hide loader
            }
          );
        }

      }).always(function() {
        // Hide loader
      }
    );

  }

  $.fn.fileUploadToS3 = function(){
    var numFilesUploaded = 0;

    // console.log("All data collected until now.");
    // console.log(table_data);

    for(var i = 0; i < table_data.length; i++) {

      // Initialize file upload to S3. 
      // NOTE: doesn't start the upload since no files have been provided yet

      // var progressBar = $('.ver-progress');
      // $(progressBar).css("display", "inherit");
      // $(progressBar).css("height", $(progressBar).parent().height());

      $("body").fileupload({
        url:             $("#rails-data").data('url'),
        type:            'POST',
        autoUpload:       true,
        formData:         $("#rails-data").data('form'),
        paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
        dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
        replaceFileInput: false,
        progressall: function (e, data) {
           // console.log(parseInt(data.loaded / data.total * 100, 10));
           // $(progressBar).css("width", $(progressBar).parent().width() * (data.loaded / data.total));
           var progressPercent = Math.round(data.loaded / data.total * 100);
           $("#loader_msg").html("Uploading file(s)...<br>" + progressPercent + "%");
           if(progressPercent == 100){
            $("#loader_msg").html("Please wait while you're redirected to payment gateway<br>Do not press Back / Refresh buttons");
           }

        },
        start: function (e) {
          // console.log("started");
          $("#loader_msg").html("Uploading file(s)...<br>0%");

        },
        done: function(e, data) {
          // console.log("Uploading done");

          // extract key and generate URL from response
          var key   = $(data.jqXHR.responseXML).find("Key").text();
          var url   = 'https://' + $("#rails-data").data('host') + '/' + key;
          var url_parts = key.split('/');
          var temp_id = url_parts[url_parts.length - 1].split("_")[0] + "";

          // console.log(data);

          // save new file URL from S3 in the stub
          lookup[temp_id].document_link = url;

          // Upload row to db Check if all files have been uploaded and proceed accordingly
          $().checkAndUpload(++numFilesUploaded, temp_id);
        },
        fail: function(e, data) {
          // console.log("failed");
        }
      });

      // Add files to be uploaded. This auto-uploads them. Given in initialization
      $("body").fileupload('add',{
        files: [new File([table_data[i]['file_obj']], table_data[i].id + "_" + table_data[i]['file_name'])]}
      );


    }
  }

  // STATUS page code here
  $(".show_verification_details").on('click',function(){
    currentDisplay = $(this).parent().parent().next("tr").css("display");
    if(currentDisplay == "none")
      $(this).closest("tr").next("tr").show();
    else
      $(this).closest("tr").next("tr").hide();
  });
  
});
