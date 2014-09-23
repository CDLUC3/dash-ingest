var map;
var ajaxRequest;
var plotlist;
var plotlayers=[];

function initMap(lat,lng) {
  var map = L.map('map')
	// Initialize the map using the given coordinates.
	// Otherwise, use Orange County.
  lat = lat || 33.6409;
  lng = lng || -117.77;
	map.setView([lat, lng], 10);

	// Create the tile layer with correct attribution.
	var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
	var osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
	var osm = new L.TileLayer(osmUrl, {maxZoom: 16, attribution: osmAttrib});
	map.addLayer(osm);
	
	map.on('click', onMapClick);
}

/*function onMapClick(e) {
  var popup = L.popup()
    .setLatLng(e.latlng)
    .setContent("You clicked on the map at " + e.latlng.toString())
    .openOn(map)
}*/

function onMapClick(e) {
  document.getElementById("record_geoLocation_attributes_geospatial_lat").value = e.latlng.lat;
  document.getElementById("record_geoLocation_attributes_geospatial_lng").value = e.latlng.lng;
}
