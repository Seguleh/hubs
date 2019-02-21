function initMap() {
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 8,
    center: {lat: 11.240, lng: -74.211}
  });
  var geocoder = new google.maps.Geocoder();

  document.getElementById('coordinatesClick').addEventListener('click', function() {
    geocodeAddress(geocoder, map);
  });
}

function geocodeAddress(geocoder, resultsMap) {
  $.ajax({
    url:      '/find_nearest',
    dataType: 'json',
    data:     {'address': document.getElementById('address').value},
    type:     'GET',
    success: function(response) {
      console.log(response)
      if (response.status === 'OK') {
        var nearest = {lat: response.nearest[1], lng: response.nearest[2]}
        resultsMap.setCenter(nearest);
        var marker = new google.maps.Marker({
          map: resultsMap,
          position: nearest
        });
        $('.nearest-distance').html(Math.trunc(response.nearest[0]))
        $('.nearest-name').html(response.info.name)
        $('.nearest-cc').html(response.info.country_code)
      } else {
        $('.nearest-name').html('Sadly there are no hubs near, please try a different address');
      }
    },
    error: function(){
      alert('Oops, sorry about this');
    }
  })
}
