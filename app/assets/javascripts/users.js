$(function(){

  $('.deletePhoto').hide();

  if ($('.profilePhoto').length){
    $('.photoPreview').hide()
  }

  $('.profilePhoto').click(function(){
    $('.profilePhoto').hide();
    $('.photoPreview').show().trigger('click');
  })
    $('.photoPreview').click(function(){
      $(this).attr('disabled', 'true');
      $('#uploadAvatar').trigger('click');
      $("#uploadAvatar").change(function(){
          $('.photoPreview').removeAttr('disabled');
          readURL(this);
      });
  })

  function readURL(input) {
      if (input.files && input.files[0]) {
          var reader = new FileReader();
          reader.onload = function (e) {
              $('.photoPreview').css('background', 'url(' + e.target.result + ')');
              $('.photoUpload, #uploadClick').hide();
          }
          $('.deletePhoto').show();
          reader.readAsDataURL(input.files[0]);
      }
  }

  $('.deletePhoto').click(function() {
    $('.deletePhoto').hide();
        $('#uploadAvatar').val('');
        $('.photoPreview').css('background', '');
        if ($('.profilePhoto').length){
          $('.profilePhoto').show();
          $('.photoPreview').hide()
        }else{
          $('.photoUpload, #uploadClick').show();
        }
  });


})