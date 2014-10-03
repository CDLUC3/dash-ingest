var geoChecked = document.getElementById('geoLocationPlace');
var geospatial = getElementsByClass('geospatial');
for (var x = 0; x < geospatial.length; x++) {
  geospatial[x].style.display = geoChecked.checked ? 'block' : 'none';
}

function hideOrRevealClass(name) {
  n = getElementsByClassName(name);
  for (var i = 0; i < n.length; i++) {
    hideOrReveal(n[i]);
  }
}

function hideOrRevealId(name) {
  hideOrReveal(document.getElementById(name));
}

function hideOrReveal(element) {
  if (element.style.display == 'block')
    element.style.display='none';
  else if (element.style.display == 'none')
    element.style.display='block';
}

/* document.getElementsByClassName doesn't work in IE 8 or lower. */
function getElementsByClassName(className) {
  if (document.getElementsByClassName) { 
    return document.getElementsByClassName(className); 
  }
  else { 
    var a = [];
    var re = new RegExp('(^| )'+className+'( |$)');
    var els = document.getElementsByTagName("*");
    for(var i=0,j=els.length; i<j; i++)
        if(re.test(els[i].className))a.push(els[i]);
    return a;
  }
}
