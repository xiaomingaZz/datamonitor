/*************************************
*		iframe 内存溢出补丁
*    防止IE6下iframe释放不完全的问题
**************************************/
(function() {
	if (window.attachEvent && !window.addEventListener) {
		// check Version
	    var ua = navigator.userAgent.toLowerCase();
	    // if 6 or 7
	    if (ua.indexOf('msie 6.') >= 0 || ua.indexOf('msie 7.') >= 0) {
	      // bind
	      window.attachEvent("onunload", function() {
	            if (window.frames && window.frames.length > 0) {
	              for (var i = 0; i < window.frames.length; i++) {
		                window.frames[i].document.write("");
		                window.frames[i].document.close();
	              }
	              CollectGarbage();
	            }
	          });
	    }
	}
})(window);