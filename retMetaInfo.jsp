<%@ page contentType="text/html; charset=EUC_KR"%><%@ page
	import="java.sql.*,javax.sql.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<title>META DATABASE</title>
	<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.8.0/styles/default.min.css">
	<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.8.0/highlight.min.js"></script>
	<script>hljs.initHighlightingOnLoad();</script>
</head>
<body>
	<input type="button" value="BACK" onclick='location.href="/adv/dev/meta.jsp";'/>
<%
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	ResultSetMetaData md = null;
	String putStr = "";
	String whereStr = "";
	String paramsStr = "";
	String colsListStr = "";
	String txtTbNm = "";
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	String url = "YOUR CONNECTION";
	conn = DriverManager.getConnection(url);
	try {
		txtTbNm = (request.getParameter("txtTbNm") == null) ? "" : request.getParameter("txtTbNm");
		String mode = (request.getParameter("mode") == null) ? "" : request.getParameter("mode");
		String txtQStr = (request.getParameter("txtQStr") == null) ? "" : request.getParameter("txtQStr");
		System.out.println(txtTbNm);
		
		String sql = "";
		if(mode.equals("0")){
			sql = "";
			sql += "SELECT TOP 1 * ";
			//sql += "FROM " + dbSid.trim() + ".dbo." + txtTbNm;
			sql += "FROM " + txtTbNm;
			//sql += "WHERE NAME LIKE '%" + sKey + "%' ";
			//sql += "ORDER BY NAME,CODE ";
		}else{
			sql = txtQStr;
		}
		System.out.println(sql);

		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();

		md = rs.getMetaData();
		
		out.println("<hr/><h1>META INFO</h1>");
		// Print the column labels
		for (int i = 1; i <= md.getColumnCount(); i++){
			colsListStr += "sql += \""+md.getColumnLabel(i)+",\";<br/>";
			out.println(md.getColumnLabel(i) + " : ");
			out.println(md.getColumnTypeName(i) + " : ");
			out.println(md.getPrecision(i) + " ");
			out.println(md.getScale(i) + "<br/>");
			out.println();
		}
		
		out.println("<hr/><h1>GAUCE PUT GEN</h1>");
		
		putStr = "";
		
		for (int i = 1; i <= md.getColumnCount(); i++){
			/*
			out.println(md.getColumnLabel(i) + " : ");
			out.println(md.getColumnTypeName(i) + " : ");
			out.println(md.getPrecision(i) + " ");
			out.println(md.getScale(i) + "<br/>");
			out.println();
			*/
			
			if(md.getColumnTypeName(i).equals("nvarchar") || md.getColumnTypeName(i).equals("char") || md.getColumnTypeName(i).equals("varchar")){
				out.println("dSet.put(\""+md.getColumnLabel(i)+"\", rs.getString(\""+md.getColumnLabel(i)+"\"), "+md.getPrecision(i)+" );<br/>");
				putStr += "dSet.put(\""+md.getColumnLabel(i)+"\", rs.getString(\""+md.getColumnLabel(i)+"\"), "+md.getPrecision(i)+" );<br/>";
				whereStr += "if(!"+md.getColumnLabel(i)+".equals(\"\")) sql += \"";
				whereStr += "AND " + md.getColumnLabel(i) +" = '"+md.getColumnLabel(i)+"' \"; <br/>";				
				paramsStr += "String "+md.getColumnLabel(i)+" = (request.getParameter(\""+md.getColumnLabel(i)+"\") == null) ? \"\" : request.getParameter(\""+md.getColumnLabel(i)+"\");<br/>";
			}else if(md.getColumnTypeName(i).equals("numeric") || md.getColumnTypeName(i).equals("money") ){
				out.println("dSet.put(\""+md.getColumnLabel(i)+"\", rs.getDouble(\""+md.getColumnLabel(i)+"\"), "+md.getPrecision(i)+", "+md.getScale(i)+" );<br/>");
				putStr += "dSet.put(\""+md.getColumnLabel(i)+"\", rs.getDouble(\""+md.getColumnLabel(i)+"\"), "+md.getPrecision(i)+", "+md.getScale(i)+" );<br/>";
				whereStr += "if(!"+md.getColumnLabel(i)+".equals(\"\")) sql += \"";
				whereStr += "AND " + md.getColumnLabel(i) +" = '"+md.getColumnLabel(i)+"' \"; <br/>";
				paramsStr += "String "+md.getColumnLabel(i)+" = (request.getParameter(\""+md.getColumnLabel(i)+"\") == null) ? \"\" : request.getParameter(\""+md.getColumnLabel(i)+"\");<br/>";
			}else if(md.getColumnTypeName(i).equals("tinyint") || md.getColumnTypeName(i).equals("int")){
				out.println("dSet.put(\""+md.getColumnLabel(i)+"\", rs.getInt(\""+md.getColumnLabel(i)+"\"), "+md.getPrecision(i)+" );<br/>");
				putStr += "dSet.put(\""+md.getColumnLabel(i)+"\", rs.getInt(\""+md.getColumnLabel(i)+"\"), "+md.getPrecision(i)+" );<br/>";
				whereStr += "if(!"+md.getColumnLabel(i)+".equals(\"\")) sql += \"";
				whereStr += "AND " + md.getColumnLabel(i) +" = '"+md.getColumnLabel(i)+"' \"; <br/>";
				paramsStr += "String "+md.getColumnLabel(i)+" = (request.getParameter(\""+md.getColumnLabel(i)+"\") == null) ? \"\" : request.getParameter(\""+md.getColumnLabel(i)+"\");<br/>";
			}
		}
		
		out.println("<hr/><h1>GAUCE Grid Format GEN</h1><xmp>");
		String alignStr = "left";
		int suppressCnt = 100;
		out.println("<C>ID={currow}			name=\"No\"		width=40		sumtext=\"합계\"		align=right	 HeadBgColor=\"#F0E6CC\" readOnly=\"true\"	FontStyle={decode(curlevel,2,\"bold\",1,\"bold\")}	SubSumText={decode(curlevel,9999,\"총 계\",2,\"부분 계\")} SubBgColor={decode(curlevel,1,\"#F8F3E6\",2,\"#D2B48C\")} SumFontStyle=\"bold\" </C>");
		for (int i = 1; i <= md.getColumnCount(); i++){
			/*
			out.println(md.getColumnLabel(i) + " : ");
			out.println(md.getColumnTypeName(i) + " : ");
			out.println(md.getPrecision(i) + " ");
			out.println(md.getScale(i) + "<br/>");
			out.println();
			*/
			if(md.getColumnTypeName(i).equals("nvarchar") || md.getColumnTypeName(i).equals("char") || md.getColumnTypeName(i).equals("varchar")){
				alignStr = "left";				
			}else{
				alignStr = "right";
			}
			out.println("<C>ID=\""+md.getColumnLabel(i)+"\"		name=\""+md.getColumnLabel(i)+"\"	sumtext=\"@sum\"		width=100		align="+alignStr+"	 sort=true	suppress="+suppressCnt+" HeadBgColor=\"#F0E6CC\" BgColor={decode(currow-(currow/2)*2,0,\"#F8F3E6\",1,\"#FFFFFF\")}</C>");
			
			suppressCnt --;
		}
		out.println("</xmp>");
		
		out.println("<hr/><h1>GAUCE Bind Format GEN</h1><xmp>");
		for (int i = 1; i <= md.getColumnCount(); i++){
			out.println("<C>Col=\""+md.getColumnLabel(i)+"\"	Ctrl=\"txt_"+md.getColumnLabel(i)+"\"	Param=Value</C>");
		}
		out.println("</xmp>");		
		
		// Loop through the result set
		/*
		while (rs.next()) {
			for (int i = 1; i <= md.getColumnCount(); i++)
				System.out.print(rs.getString(i) + " ");
				System.out.println();
		}
		*/

		// Close the result set, statement and the connection
		rs.close();
		psmt.close();
		conn.close();
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (conn != null) {
			try {
				conn.close();
			} catch (Exception e) {
			}
		}

		if (psmt != null) {
			try {
				psmt.close();
			} catch (Exception e) {
			}
		}

		if (rs != null) {
			try {
				rs.close();
			} catch (Exception e) {
			}
		}
	}
%>
	<hr/>
	<pre>
		<code>
		&lt;@ page contentType="text/html; charset=EUC_KR"%&gt;&lt;%@ page
	import="com.gauce.*,com.gauce.db.*,com.gauce.io.*,com.gauce.http.*,com.gauce.filter.*,java.sql.*,javax.sql.*"%>
&lt;%
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	String url = "<%=url%>";
	conn = DriverManager.getConnection(url);
	try {
		GauceInputStream gis = ((HttpGauceRequest) request).getGauceInputStream();
		GauceOutputStream gos = ((HttpGauceResponse) response).getGauceOutputStream();
		
		<%=paramsStr%>
		String sql = "";
		
		sql = ""; 
		sql += "SELECT DISTINCT "; 
		<%
		colsListStr = colsListStr.substring(0,colsListStr.lastIndexOf(",")) + " \"; ";
		out.println(colsListStr);
		%>
		sql += "FROM "; 
		sql += "<%=txtTbNm%> "; 
		sql += "WHERE 1=1 ";		
		<%=whereStr%>
		
		System.out.println(sql);
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();		
		
		GauceDataSet dSet = new GauceDataSet();
		gos.fragment(dSet);
		
		while(rs.next()){
			
			<%=putStr%>
			
			dSet.heap();
		}
		
		rs.close();
		psmt.close();
		gos.write(dSet);
		gos.close();
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (conn != null) {
			try {
				conn.close();
			} catch (Exception e) {
			}
		}
		
		if (psmt != null) {
			try {
				psmt.close();
			} catch (Exception e) {
			}
		}
		
		if (rs != null) {
			try {
				rs.close();
			} catch (Exception e) {
			}
		}
	}
%&gt;
		</code>
	</pre>
	<input type="button" value="BACK" onclick='location.href="/easy/dev/meta.jsp";'/>
</body>
</html>
