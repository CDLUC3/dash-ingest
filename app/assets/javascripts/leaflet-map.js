var map;
var ajaxRequest;
var plotlist;
var plotlayers=[];
var featureGroup;
var drawControl;

function initMap(lat,lng) {
  map = L.map('map');
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
}

function allowMapDraw() {
	featureGroup = L.featureGroup().addTo(map);
  
  map.on('draw:created', function(e) {
    type = e.layerType;
    layer = e.layer;
    if (type === 'marker') {
      
    } else if (type === 'rectangle') {
      // Get SW coordinates.
      document.getElementById("record_geoLocationBox_attributes_sw_lat").value = layer.getBounds().getSouthWest().lat;
      document.getElementById("record_geoLocationBox_attributes_sw_lng").value = layer.getBounds().getSouthWest().lng;
      // Get NE coordinates.
      document.getElementById("record_geoLocationBox_attributes_ne_lat").value = layer.getBounds().getNorthEast().lat;
      document.getElementById("record_geoLocationBox_attributes_ne_lng").value = layer.getBounds().getNorthEast().lng;
    }
    
    featureGroup.addLayer(e.layer);
  });
}

function getDrawTool(geoType) {
  if (drawControl != null) {
    map.removeControl(drawControl);
  }
	// Add Leaflet.draw toolbars and functionality.
  drawControl = new L.Control.Draw({
      position: 'topright',
      draw: {
        polyline: false,
        polygon: false,
        circle: false,
      },
      edit: {
        featureGroup: featureGroup
      }
    });
  if (geoType == 'point') {
    drawControl.setDrawingOptions({
      rectangle: false
    });
  } else if (geoType == 'box') {
    drawControl.setDrawingOptions({
      marker: false
    });
  }
  
  drawControl.addTo(map);
}

function onMapClick(e) {
  var popup = L.popup()
    .setLatLng(e.latlng)
    .setContent("You clicked on the map at " + e.latlng.toString())
    .openOn(map)
}

/*function onMapClick(e) {
  document.getElementById("record_geoLocationPoint_attributes_*_lat").value = e.latlng.lat;
  document.getElementById("record_geoLocationPoint_attributes_*_lng").value = e.latlng.lng;
}*/
