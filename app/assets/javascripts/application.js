// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require jquery3
//= require datatables
//= require popper
//= require bootstrap
//= require adminlte.min.js
//= require jquery.overlayScrollbars.min
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require datatables
//= require bs-stepper.min.js
//= require flatpickr
//= require jquery.inputmask.min.js
//= require active_storage_drag_and_drop



$(document).on('turbolinks:load', function(){
  $("#student_photo").change(function(data){

    var imageFile = data.target.files[0];
    var reader = new FileReader();
    reader.readAsDataURL(imageFile);

    reader.onload = function(evt){
      $('#imagePreview').attr('src', evt.target.result);
      $('#imagePreview').hide();
      $('#imagePreview').fadeIn(650);
    }
    
  });
  //Datemask dd/mm/yyyy
  $('#datemask').inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
    //Datemask2 mm/dd/yyyy
  $('#datemask2').inputmask('mm/dd/yyyy', { 'placeholder': 'mm/dd/yyyy' })
    //Money Euro
  $('#student_student_address_attributes_cell_phone').inputmask()
  $('#student_student_address_attributes_house_phone').inputmask()
  $('#student_emergency_contact_attributes_cell_phone').inputmask()
  $('#student_emergency_contact_attributes_office_phone_number').inputmask()
  $('#student_emergency_contact_attributes_email_of_employer').inputmask()
})


// BS-Stepper Init
document.addEventListener('turbolinks:load', function () {
  window.stepper = new Stepper(document.querySelector('.bs-stepper'))
})

document.addEventListener('turbolinks:load', function() {
  var a = new Date().getFullYear() - 18
  var b = a + "-15"
  flatpickr('.datepicker',{
    maxDate: b
  });
})