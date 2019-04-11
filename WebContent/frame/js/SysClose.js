var isLogout = false;
//window.onbeforeunload=function(e){
  // e=e||window.event;
  //if(isLogout){
   	//   e.returnValue="确认注销系统?";
   	  // isLogout = false;  
   //}else{
	 //  e.returnValue="您确认离开系统?";  
	//} 
//}
/*
document.onkeypres= function(){
	if(window.event.keyCode==116) KeyF5Down();
}
function KeyF5Down(){
	 isF5 = true;
}*/

//window.onunload=function(){
	//alert(1);
//}


/*
function confirmLogout() {
   isLogout = true;
   top.location.href = "loginout"; 
}
*/
function confirmLogout() {
	if (confirm("\u786e\u8ba4\u6ce8\u9500\uff1f")) {
		top.location.href = "loginout";
	}
}