
$(document).ready(function () {
	$("#split").toggle(function () {
		$("#leftmenu").hide();
		$(this).attr("src", "frame/images/main/splitbutton2.gif");
		$(this).attr("title", "\u663e\u793a\u83dc\u5355\u680f");
	}, function () {
		$("#leftmenu").show();
		$(this).attr("src", "frame/images/main/splitbutton1.gif");
		$(this).attr("title", "\u9690\u85cf\u83dc\u5355\u680f");
	});
	$(window).resize(function(){
		 setTimeout('resizeTree()',300);
		 return true;
	}); 
});