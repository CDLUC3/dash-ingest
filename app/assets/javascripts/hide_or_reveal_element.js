function hideOrReveal(name) {
  var n = document.getElementsByClassName(name);
  for (var i = 0; i < n.length; i++) {
    if (n[i].style.display == 'block')
      n[i].style.display='none';
    else if (n[i].style.display == 'none')
      n[i].style.display='block';
  }
}
