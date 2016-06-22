<%@ page contentType="text/html; charset=EUC_KR"%><%@ page
	import="java.sql.*,javax.sql.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<title>META DATABASE</title>
</head>
<body>
	<input type="button" value="BACK" onclick='location.href="meta.jsp";'/>
<%
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	String url = "Scribe Your DB Connection Info";
	conn = DriverManager.getConnection(url);
	try {
		String txtTbNm = (request.getParameter("txtTbNm") == null) ? "" : request.getParameter("txtTbNm");
		String mode = (request.getParameter("mode") == null) ? "" : request.getParameter("mode");
		String txtQStr = (request.getParameter("txtQStr") == null) ? "" : request.getParameter("txtQStr");

		String sql = "";
		if(mode.equals("0")){
			sql = "";
			sql += "SELECT TOP 1 * ";
			sql += "FROM " + txtTbNm;
		}else{
			sql = txtQStr;
		}
		System.out.println(sql);

		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();

		ResultSetMetaData md = rs.getMetaData();
		
		out.println("<hr/><h1>META INFO</h1>");
		// Print the column labels
		for (int i = 1; i <= md.getColumnCount(); i++){
			out.println(md.getColumnLabel(i) + " : ");
			out.println(md.getColumnTypeName(i) + " : ");
			out.println(md.getPrecision(i) + " ");
			out.println(md.getScale(i) + "<br/>");
			out.println();
		}
		
		out.println("<hr/><h1>GAUCE PUT GEN</h1>");
		
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
			}else if(md.getColumnTypeName(i).equals("numeric")){
				out.println("dSet.put(\""+md.getColumnLabel(i)+"\", rs.getDouble(\""+md.getColumnLabel(i)+"\"), "+md.getPrecision(i)+", "+md.getScale(i)+" );<br/>");
			}else if(md.getColumnTypeName(i).equals("tinyint")){
				out.println("dSet.put(\""+md.getColumnLabel(i)+"\", rs.getInt(\""+md.getColumnLabel(i)+"\"), "+md.getPrecision(i)+" );<br/>");
			}
		}

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
</body>
</html>
