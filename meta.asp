<!-- #include virtual="/_$common_include/oledbcon.asp" -->
<%
Session.CodePage = 949
Response.Charset = "euc-kr"
proc = Request.Form("proc")
stbl = Request.Form("stbl")

Function fnRtnTypeName( typeCode )
	rtnNm = "몰라"
	Select Case typeCode
		Case 3
			rtnNm = "INT"
		Case 129
			rtnNm = "CHAR"
		Case 200
			rtnNm = "VARCHAR"
		Case 131
			rtnNm = "NUMERIC"
		Case 202
			rtnNm = "NVARCHAR"
		Case Else
			rtnNm = "몰라"
	End Select

	fnRtnTypeName = rtnNm
End Function

Function fnChkFieldType(fdNm, fdType)
	rtnNm = ""
	Select Case fdType
		Case 129
			rtnNm = "'" & fdNm & "'"
		Case 200
			rtnNm = "'" & fdNm & "'"
		Case 202
			rtnNm = "'" & fdNm & "'"
		Case Else
			rtnNm = fdNm
	End Select

	fnChkFieldType = rtnNm
End Function
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>ASP DATABASE META INFO</title>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<link rel="stylesheet" href="http://bootstrapk.com/dist/css/bootstrap.min.css" media="screen">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.11.3.js"></script>
<script type="text/javascript" src="http://bootstrapk.com/dist/js/bootstrap.min.js"></script>
<script type="text/javascript" src="http://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
<script type="text/javascript">
function fnRetMeta(){
	var sKey = $("#stbl").val();
	if(sKey=="") return false;
	
	document.forms[0].submit();
}
</script>
</head>

<body>
<form method="post" action="meta.asp">
<fieldset style="padding-left:10px;">
	<legend>TABLE Name</legend>
	<legend>
		<input type="search" name="stbl" id="stbl" value="<%=stbl%>" />
		<button class="btn btn-primary" onClick="fnRetMeta();">Search</button>
	</legend>
</fieldset>
</form>
<fieldset style="padding-left:10px;">
	<legend>
		Field Info
	</legend>
	<legend>
		<%
		sqlCodeInit = "sql = " & Chr(14) & Chr(14)

		if stbl <> "" then
			sql = "SELECT TOP 1 * FROM " & stbl & ";"
			Set Rs = dbcon.Execute(sql)
			
			selectSql = "SELECT "
			selectCode = "sql = """" <br/>"
			selectCode = selectCode & "sql = sql & """ & selectSql & " "" <br/>"
			
			srcAspSelectSampleCode = ""
			
			insertSql = "INSERT INTO " & stbl & "("
			insertParam = ""
			insertCode = "sql = """" <br/>"
			insertCode = insertCode & "sql = sql & "" " & insertSql & " "" <br/> " 			
			insertCodeParam = ""
			
			updateSql = "UPDATE " & stbl & " SET "
			updateParam = ""
			updateCode = "sql = """" <br/>"
			updateCode = updateCode & "sql = sql & ""UPDATE "&stbl&" SET "" "
			
			deleteCode = ""
			
			sampleListCnt = 0
			if Not(Rs.EOF) then
				Response.Write("<ul>")
				For Each objField in rs.Fields
					Response.Write "<li>"
					Response.Write (objField.Name & ":")					
					Response.Write (fnRtnTypeName(objField.Type) & "(")
					Response.Write (objField.DefinedSize & "):")					
					Response.Write ("Precision:"&objField.Precision & "||")
					Response.Write "</li>"
					
					selectSql = selectSql & "<br/>" & objField.Name & ", "
					selectCode =  selectCode & "sql = sql & """ &objField.Name & ", "";<br/>"
					srcAspSelectSampleCode = srcAspSelectSampleCode & "<li>" & objField.Name & "= arrTemp("&sampleListCnt&",i)</li>"
					
					insertSql = insertSql & "<br/>" & objField.Name & ", "
					insertParam = insertParam & "<br/>" & fnChkFieldType(objField.Name, objField.Type) & ", "
					
					insertCode = insertCode & "sql = sql & """ &objField.Name & ", "" <br/>"
					insertCodeParam = insertCodeParam  & "<br/>sql = sql & "" " & fnChkFieldType(objField.Name, objField.Type) & ", "" "
					
					updateSql = updateSql & "<br/>" & objField.Name & " = "&fnChkFieldType(objField.Name, objField.Type)&", "
					updateCode = updateCode & "<br/>sql = sql & """ & objField.Name & " = "&fnChkFieldType(objField.Name, objField.Type)&", " & " "" "
					
					sampleListCnt = sampleListCnt + 1
				Next
				
				selectSql = LEFT(selectSql, InstrRev(selectSql, ",")-1)
				selectSql = selectSql & "<br/>" & " FROM " & stbl
				selectSql = selectSql & "<br/>" & " WHERE 1=1 "				
				selectCode = LEFT(selectCode, InstrRev(selectCode, ",")-1) & " ""; "
				selectCode = selectCode & "<br/>" & "sql = sql & ""FROM " & stbl & " "" "
				selectCode = selectCode & "<br/>" & "sql = sql & ""WHERE 1=1 "" "
				
				insertSql = LEFT(insertSql, InstrRev(insertSql, ",")-1)
				insertParam = LEFT(insertParam, InstrRev(insertParam, ",")-1)
				insertSql = insertSql & "<br/>" & ") "&"" &"VALUES ( "&insertParam&" <br/>) "				
				
				insertCode = LEFT(insertCode, InstrRev(insertCode, ",")-1) & " "" "
				insertCode = insertCode & "<br/>sql = sql & "") VALUES ( "" "
				insertCodeParam = LEFT(insertCodeParam, InstrRev(insertCodeParam, ",")-1) & " "" "
				insertCode = insertCode & insertCodeParam & "<br/>sql = sql & "" ) "" "
				
				updateSql = LEFT(updateSql, InstrRev(updateSql, ",")-1)
				updateSql = updateSql & "<br/>" & "WHERE 1=1 "
				
				updateCode = LEFT(updateCode, InstrRev(updateCode, ",")-1) & " "" "
				updateCode = updateCode & "<br/>" & "sql = sql & ""WHERE 1=1 "" "
				
				
				deleteSql = "DELETE  "&"<br/>" &"FROM "&stbl & "<br/>" &"WHERE 1=1"
				deleteCode = "sql = """" <br/>"
				deleteCode = deleteCode & "sql = sql & ""DELETE  "";"&"<br/>" &"sql = sql & ""FROM "&stbl & " "";<br/>" &"sql = sql & ""WHERE 1=1 "" "
				Response.Write("</ul>")
			end if
			Rs.Close : Set Rs = Nothing
		end if
		%>
	</legend>
</fieldset>
<fieldset style="padding-left:10px;">
	<legend class="text-primary">SELECT</legend>
	<legend>
		<table class="table table-bordered">
			<tr>
				<td width="33%" class="success">Query</td>
				<td class="success">ASP</td>
				<td class="success">JSP/JAVA</td>
			</tr>
			<tr>
				<td class="warning"><%=selectSql%></td>
				<td class="warning"><%=Replace(selectCode,""";","""")%></td>
				<td class="warning">
					<%
						tmpStr = replace(replace(selectCode, """ ", """;"),"&", "+")
						tmpStr = replace(tmpStr, "sql = sql + ", "sql += ")
						Response.Write(tmpStr)
					%>
				</td>
			</tr>			
			<tr>
				<td>&nbsp;</td>
				<td class="danger">
				Set Rs = dbcon.Execute(sql)<br>
				if not rs.EOF then arrTemp=rs.getrows<br>rs.close : set rs = nothing<br>
				if isArray(arrTemp) then<br>
				<ul style="margin:0; padding:0; list-style-type:none; text-indent:10px;">
					for i=0 to Ubound(arrTemp,2)
					<li>
						<ul style="list-style-type:none;" id="srcAspSelectSampleList">
							<%=srcAspSelectSampleCode%>
						</ul>						
					</li>
					<li>
						next
					</li>
				</ul>
				end if<br>
				</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</legend>
</fieldset>
<fieldset style="padding-left:10px;">
	<legend class="text-primary">INSERT</legend>
	<legend>
		<table class="table table-bordered">
			<tr>
				<td width="33%" class="success">Query</td>
				<td class="success">ASP</td>
				<td class="success">JSP/JAVA</td>
			</tr>
			<tr>
				<td class="warning"><%=insertSql%></td>
				<td class="warning"><%=insertCode%></td>
				<td class="warning">
					<%
						tmpStr = replace(replace(insertCode, """ ", """;"),"&", "+")
						tmpStr = replace(tmpStr, "sql = sql + ", "sql += ")
						Response.Write(tmpStr)
					%>
				</td>
			</tr>
		</table>
	</legend>
</fieldset>
<fieldset style="padding-left:10px;">
	<legend class="text-primary">UPDATE</legend>
	<legend>
		<table class="table table-bordered">
			<tr>
				<td width="33%" class="success">Query</td>
				<td class="success">ASP</td>
				<td class="success">JSP/JAVA</td>
			</tr>
			<tr>
				<td class="warning"><%=updateSql%></td>
				<td class="warning"><%=updateCode%></td>
				<td class="warning">
					<%
						tmpStr = replace(replace(updateCode, """ ", """;"),"&", "+")
						tmpStr = replace(tmpStr, "sql = sql + ", "sql += ")
						Response.Write(tmpStr)
					%>
				</td>
			</tr>
		</table>
	</legend>
</fieldset>
<fieldset style="padding-left:10px;">
	<legend class="text-primary">DELETE</legend>
	<legend>
		<table class="table table-bordered">
			<tr>
				<td width="50%" class="success">Query</td>
				<td class="success">ASP</td>
				<td class="success">JSP</td>
			</tr>
			<tr>
				<td class="warning"><%=deleteSql%></td>
				<td class="warning"><%=deleteCode%></td>
				<td class="warning">
					<%
						tmpStr = replace(replace(deleteCode, """ ", """;"),"&", "+")
						tmpStr = replace(tmpStr, "sql = sql + ", "sql += ")
						Response.Write(tmpStr)
					%>
				</td>
			</tr>
		</table>
	</legend>
</fieldset>
</body>
</html>

<!-- #include virtual="/_$common_include/dbclose.asp" -->