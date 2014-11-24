var map;
var ajaxRequest;
//var plotlist;
//var plotlayers=[];
var markerMap = {};
var featureGroupMarkers = L.featureGroup();
var featureGroupRectangle = L.featureGroup();
var drawControl;
//var defaultMarker = new L.Icon.Default;
/*var highlightMarker = new L.Icon.Default({
  iconUrl: '/assets/marker-icon-highlight.png',
  iconRetinaUrl: '/assets/marker-icon-highlight-2x.png'
});*/


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
  var osm = new L.TileLayer(osmUrl, {maxZoom: 16, attribution: osmAttrib, zIndex: 4});
  map.addLayer(osm);
  featureGroupMarkers.addTo(map);
  featureGroupRectangle.addTo(map);

  map.on('draw:created', function(e) {
    type = e.layerType;
    layer = e.layer;
    if (type === 'marker') {
      // Add coordinates to active field.
      pointId = getNewPointAndId(layer);
      featureGroupMarkers.addLayer(layer);
      // Map new marker to newer Point.
      markerMap[featureGroupMarkers.getLayerId(layer)] = pointId;
      enforcePointsLimit();
    } else if (type === 'rectangle') {
      // Cap number of rectangles at 1.
      if (featureGroupRectangle.getLayers().length == 1) {
        disableDrawing();
      }
      setBoxFields(layer);
      featureGroupRectangle.addLayer(layer);
    }
  });
  map.on('draw:edited', function(e) {
    layers = e.layers;
    layers.eachLayer( function (layer) {
      if (layer instanceof L.Marker) {
        setPointCoords(layer);
      } else if (layer instanceof L.Rectangle) {
        setBoxFields(layer);
      }
    });
  });
  map.on('draw:deleted', function(e) {
    layers = e.layers;
    layers.eachLayer( function (layer) {
      if (layer instanceof L.Marker) {
        layerId = layers.getLayerId(layer);
        pointId = markerMap[layerId];
        $(pointId+'__destroy').val('1');
        $(pointId).remove();
        delete markerMap[layerId];
        enforcePointsLimit();
      } else if (layer instanceof L.Rectangle) {
        // Clear out box fields.
        $('#record_geoLocationBox_attributes_sw_lat').val('');
        $('#record_geoLocationBox_attributes_sw_lng').val('');
        $('#record_geoLocationBox_attributes_ne_lat').val('');
        $('#record_geoLocationBox_attributes_ne_lng').val('');
        enableDrawing();
      }
    });
  });
}

function getDrawTool(geoType) {
  // If applicable, remove previous toolbar before 
  //  replacing it.
  if (drawControl !== undefined) {
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
    // Show markers and hide rectangle.
    featureGroupMarkers.eachLayer(function (marker) {
      marker.setOpacity(1);
    });
    featureGroupRectangle.setStyle({ 
      opacity: 0, 
      fillOpacity: 0
    });
    drawControl.addTo(map);
    enforcePointsLimit();
  } else if (geoType == 'box') {
    // Cap number of rectangles at 1.
    if (featureGroupRectangle.getLayers().length == 1) {
      disableDrawing();
    }
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
    // Hide markers and show rectangle.
    featureGroupMarkers.eachLayer(function (marker) {
      marker.setOpacity(0);
    });
    featureGroupRectangle.setStyle({ 
      opacity: 0.5, 
      fillOpacity: 0.3
    });
    drawControl.addTo(map);
  }
  else {
    drawControl = new L.Control.Draw({
      position: 'topright',
      draw: false,
      edit: false
    });
    drawControl.addTo(map);
  }
}

function enforcePointsLimit() {
  if ($('.fields.geopoint').length <= 25) {
    enableDrawing();
    $('.add_fields.geopoint').off('click', disableAddingPoints);
  } else {
    disableDrawing();
    $('.add_fields.geopoint').on('click', disableAddingPoints);
  }
}
function disableAddingPoints (e) {
  e.preventDefault();
  $(this).prop('disabled', true);
  alert("Only 25 points allowed.");
}
function disableDrawing() {
  $('.leaflet-draw-toolbar-top').hide();
}
function enableDrawing() {
  $('.leaflet-draw-toolbar-top').show();
}

// Build fields for a new, marker-linked Point coordinate pair.
function getNewPointAndId(marker) {
  time = new Date().getTime();
  regexp = new RegExp($('.add_fields.geopoint').data('id'), 'g');
  addPointsButton = $('.add_fields.geopoint');
  addPointsButton.before(addPointsButton.data('fields').replace(regexp, time));
  newId = '#record_geoLocationPoints_attributes_'+time;
  $(newId + '_lat').val(marker.getLatLng().lat).attr('readonly', 'readonly');
  $(newId + '_lng').val(marker.getLatLng().lng).attr('readonly', 'readonly');
  $(newId).find('.remove_fields').addClass('markerPt').attr('data-baseId', newId).on('click', function (e) {
    featureGroupMarkers.removeLayer(marker);
  });
  return newId;
}

function setPointCoords(marker) {
  pointId = markerMap[featureGroupMarkers.getLayerId(marker)];
  $(pointId + '_lat').attr('value',marker.getLatLng().lat);
  $(pointId + '_lng').attr('value',marker.getLatLng().lng);
}
function setBoxFields(layer) {
  // Set SW coordinates.
  $('#record_geoLocationBox_attributes_sw_lat').val(layer.getBounds().getSouthWest().lat);
  $('#record_geoLocationBox_attributes_sw_lng').val(layer.getBounds().getSouthWest().lng);
  // Set NE coordinates.
  $('#record_geoLocationBox_attributes_ne_lat').val(layer.getBounds().getNorthEast().lat);
  $('#record_geoLocationBox_attributes_ne_lng').val(layer.getBounds().getNorthEast().lng);
}
/*function redrawBox() {
  if ( allBoxFieldsFilled() ) {
    // Get SW coordinates.
    sw = [ document.getElementById("record_geoLocationBox_attributes_sw_lat").value, document.getElementById("record_geoLocationBox_attributes_sw_lng").value ];
    // Get NE coordinates.
    ne = [ document.getElementById("record_geoLocationBox_attributes_ne_lat").value, document.getElementById("record_geoLocationBox_attributes_ne_lng").value ];
    // Test if rectangle exists to be redrawn on map.
    if (featureGroupRectangle.getLayers().length == 1) {
      // There should only be one layer in the feature group.
      featureGroupRectangle.eachLayer( function (layer) {
        layer.setBounds([ sw, ne ]);
      });
      disableDrawing();
    } else {
      // Create new rectangle.
      featureGroupRectangle.addLayer(L.rectangle([ sw, ne ], {color: 'orange'}));
      disableDrawing();
    };
  }
}
function allBoxFieldsFilled() {
  if ( record_geoLocationBox_attributes_sw_lat.value != '' && record_geoLocationBox_attributes_sw_lng.value != '' && record_geoLocationBox_attributes_ne_lat.value != '' && record_geoLocationBox_attributes_ne_lng.value != '' )
    return true;
  else return false;
}*/

function clearGeoData() {
  $('#geoLocPoint').hide();
  $('#geoLocBox').hide(); 
  $('#record_geospatialType_point').prop('checked', false);
  $('#record_geospatialType_box').prop('checked', false); 
  getDrawTool('none');
  $('.destroyer').parent('#geoLocationPoint').val('1');
  $('.fields.geopoint').remove(); 
  featureGroupMarkers.clearLayers(); 
  featureGroupRectangle.clearLayers(); 
  markerMap = {};
}
