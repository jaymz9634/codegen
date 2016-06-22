<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>META DATABASE</title>
</head>
<body>
<form method="post" action="retMetaInfo.jsp">
<input type="hidden" name="mode" value="0"/>
<table>
	<tr>
		<td>
			TABLE NAME : <input type='text' name="txtTbNm"/>
		</td>
		<td>
			<input type='submit' value="GET!"/>
		</td>
	</tr>
</table>
</form>
<hr/>
<form method="post" action="/easy/dev/proc/retMetaInfo.jsp">
<input type="hidden" name="mode" value="1"/>
<table width="100%">
	<tr>
		<td>
			QUERY : <input type='submit' value="GET!"/> 
			<br/><textarea name="txtQStr" cols="10" rows="10" style="width:100%;"></textarea>
		</td>
	</tr>
</table>
</form>
</body>
</html>
