var map;
var ajaxRequest;
var plotlist;
var plotlayers=[];
var featureGroupMarkers = L.featureGroup();
var featureGroupRectangle= L.featureGroup();
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

function allowMapDraw(geoType) {
  featureGroupMarkers.addTo(map);
  featureGroupRectangle.addTo(map);
	getDrawTool(geoType);
  
  map.on('draw:created', function(e) {
    type = e.layerType;
    layer = e.layer;
    if (type === 'marker') {
      // Add coordinates to active field.
      
      featureGroupMarkers.addLayer(e.layer);
    } else if (type === 'rectangle') {
      // Get SW coordinates.
      document.getElementById("record_geoLocationBox_attributes_sw_lat").value = layer.getBounds().getSouthWest().lat;
      document.getElementById("record_geoLocationBox_attributes_sw_lng").value = layer.getBounds().getSouthWest().lng;
      // Get NE coordinates.
      document.getElementById("record_geoLocationBox_attributes_ne_lat").value = layer.getBounds().getNorthEast().lat;
      document.getElementById("record_geoLocationBox_attributes_ne_lng").value = layer.getBounds().getNorthEast().lng;
      // Disable the draw toolbar.
      $('.leaflet-draw-inner-toolbar').show();
    }
    featureGroupRectangle.addLayer(e.layer);
  });
  
  map.on('draw:deleted', function(e) {
    // Allow use of the draw toolbar.
    $('.leaflet-draw-inner-toolbar').hide();
  });

}

function getDrawTool(geoType) {
  // Create hidden div element which grays out the 
  //  draw tool when the layer limit is reached.
  $('.leaflet-draw-section:first').append('<div class="leaflet-draw-inner-toolbar" title="No more layers can be added for this geospatial type."></div>');
  
  // If applicable, remove previous toolbar before 
  //  replacing it.
  if (drawControl != null) {
    map.removeControl(drawControl);
  }
  // Only show the draw tool relevant to the
  //   current geoLocation type.
  if (geoType == 'point') {
    drawControl = new L.Control.Draw({
      position: 'topright',
      draw: {
        polyline: false,
        polygon: false,
        circle: false,
        rectangle: false
      },
      edit: {
        featureGroup: featureGroupMarkers
      }
    });
    // Cap number of markers at 25.
    if (featureGroupMarkers.getLayers().length == 25) {
      $('.leaflet-draw-inner-toolbar').show();
    }
    // Show markers and hide rectangle.
    featureGroupMarkers.eachLayer(function (marker) {
      marker.setOpacity(1);
    });
    featureGroupRectangle.setStyle({ 
      opacity: 0, 
      fillOpacity: 0
    });
    drawControl.addTo(map);
  } else if (geoType == 'box') {
    drawControl = new L.Control.Draw({
      position: 'topright',
      draw: {
        polyline: false,
        polygon: false,
        circle: false,
        marker: false,
        rectangle: {
          shapeOptions: {
            color: 'orange'
          }
        }
      },
      edit: {
        featureGroup: featureGroupRectangle
      }
    });
    // Cap number of rectangles at 1.
    if (featureGroupRectangle.getLayers().length == 1) {
      $('.leaflet-draw-inner-toolbar').show();
    }
    // Hide markers and show rectangle.
    featureGroupMarkers.eachLayer(function (marker) {
      marker.setOpacity(0);
    });
    featureGroupRectangle.setStyle({ 
      opacity: 0.5, 
      fillOpacity: 0.3
    });
    /*featureGroupRectangle.setStyle( {
      opacity: 1;
    };*/
    drawControl.addTo(map);
  }
}

function redrawBox() {
  // Get SW coordinates.
  sw = [ document.getElementById("record_geoLocationBox_attributes_sw_lat").value, document.getElementById("record_geoLocationBox_attributes_sw_lng").value ];
  // Get NE coordinates.
  ne = [ document.getElementById("record_geoLocationBox_attributes_ne_lat").value, document.getElementById("record_geoLocationBox_attributes_ne_lng").value ];
  featureGroupRectangle.eachLayer( function (layer) {
    layer.setBounds([ sw, ne ]);
  });
    
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
