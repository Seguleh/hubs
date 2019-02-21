$(document).ready(function() {
  function showLoading() {
    $('#data-load').html('<i class="fas fa-cog fa-spin"></i>')
    $('#data-load').attr('disabled', true)
  }

  function hideLoading() {
    $('#data-load').html('Loaded!')
  }

  $("#data-load").click(function() {
    showLoading()
    $.ajax({
      url:      '/load_data_external',
      type:     'GET',
      complete: function(result) {
        hideLoading()
      }
    })
  });
})
