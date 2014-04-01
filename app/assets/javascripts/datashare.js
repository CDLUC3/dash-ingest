jQuery(document).ready(function() {
  jQuery(".content").hide();
  var originalImage = $("#bg").attr('src');
  //toggle the componenet with class msg_body
  jQuery(".heading").click(function()
  {	
    jQuery(".content").slideToggle(500);
	var src = $("#bg").attr('src') == originalImage ? "images/collapseArrow.gif" : originalImage;
        $("#bg").attr('src',src);
        return false;
  });
});