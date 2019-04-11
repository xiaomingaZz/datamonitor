<%@ page language="java" contentType="text/html;charset=utf-8"
	pageEncoding="utf-8"%>
<html>
	<head>
		<title>通大海审判业务系统控制台</title>
		<%@ include file="../common/ext-js.jsp"%>
		<script src="js/adminconsole.js"></script>
		<script>
		 	
function confirmLogout() {
	if (confirm("\u786e\u8ba4\u6ce8\u9500\uff1f")) {
		top.location.href = "../loginout";
	}
}
		</script>
	</head>
	<body>
		<div id="north">
			<p>
				通大海审判业务系统控制台
			</p>
			<table width="100%">
				<tr>
					<td align="right">
						<a href="#" onclick="confirmLogout();return false;">注销</a>
					</td>
				</tr>
			</table>
		</div>
		<div id="cl" style="text-align: center;">
			<p>
				<a href="#" target="console">功能1</a>
			</p>
			<p>
				<a href="#" target="console">功能2</a>
			</p>
			<p>
				<a href="#" target="console">功能3</a>
			</p>
		</div>
	</body>
</html>
