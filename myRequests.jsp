<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ page import ="java.util.*" %>
<%@ page import ="com.nsc.mst.dataaccess.*" %>
<%@ page import ="com.nsc.mst.utils.*" %>
<%@ page import="java.lang.*, java.lang.String, java.io.*, java.sql.*, java.text.*"%>
<%@ page import="com.nsc.SSOfilter.*" %>
<%@ page import= "org.apache.log4j.Logger"%>
<%@ page import= "org.apache.log4j.PropertyConfigurator"%>
<%
SSOfilter filter = new SSOfilter(); //Comment out to debug
filter.doFilter(request, response);  //Comment out to debug
String portalUser = "";
String memberID = "";
String userEmail = "";
String userName = "";
String cust= "";
String custID = "";
String customer = "";

try {
portalUser =  (String)session.getAttribute("PortalUser");
memberID =  (String)session.getAttribute("MemberID");  
userEmail = (String)session.getAttribute("UserEmail");
userName = (String)session.getAttribute("UserFullName");
session.setAttribute("userName", portalUser);

if (memberID == null){
	response.sendRedirect("./index.jsp");
}

} catch (Exception ex) {
    ex.printStackTrace();
}

System.out.println("SPR-portalUser =  " + portalUser );
System.out.println("SPR-memberID =  " + memberID );
System.out.println("SPR-userEmail =  " + userEmail );
System.out.println("SPR-userName =  " + userName );

request.getSession().setAttribute("memberID", memberID);
memberID = String.format("%03d", Integer.parseInt(memberID));
//memberID = "127";

/*portalUser = request.getParameter("portalUser");
System.out.println("SR Testing= " +portalUser);
memberID = request.getParameter("memberID");
System.out.println("SR Testing= " +memberID);
userEmail = request.getParameter("userEmail");
System.out.println("SR Testing= " +userEmail);
userName = request.getParameter("userName");
System.out.println("SR Testing= " +userName);*/

//System.out.println(memberID);
System.out.println("This is the My Request Page");

String reqID = "";
String requester = "";
String corpAcct = "";
String status= "";
String dateSub = "";
String form = "";
String notes = "";

Logger LOGGER = Logger.getLogger(com.nsc.mst.controller.MSTUtils.class);

String [] alternatingColors ={"#e5e5e5", "#ffffff"}; 
int rowN=0;
int j = 0;

%>

<script>

function isOneChecked() {
     var chx = document.getElementsByTagName('input');
	 
	 for (var i=0; i<chx.length; i++){
		 if (chx[i].type == 'radio' && chx[i].checked){	 
		 return true;
		 }
	 }
	 alert("Please Select A Request.")
	 return false		
}

</script>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=10,9,7,8" />
<title>NETWORK Material Setup Request</title>
   
<link href="../../NSCMemUtils/web/css/NewItemSetup.css?v=1.0" rel="stylesheet" type="text/css" />
<link href="NewItemSetup.css" rel="stylesheet" type="text/css" />
</head>

<body id="wrapper" style="border: 5px solid #4f758b; border-radius: 25px;">
<br/>
<table width="90%" align="center">
<tbody>
 <input type="hidden" name="portalUser" value="<%=portalUser%>"/>
 <input type="hidden" name="memberID" value="<%=memberID%>"/>
 <input type="hidden" name="userEmail" value="<%=userEmail%>"/>
 <input type="hidden" name="userName" value="<%=userName%>"/>
 <input type="hidden" name="subject" value="New Material Setup Request" />

<tr>
	<td align="left" width="25%"><img src="./images/logo.png" /></td>
	<td align="center" width="40%"><h1 style="font-size:30px"><strong><font color= "#3a728a">MATERIAL SETUP TOOL</font></strong></h1><br/></td>
	<td width="25%">&nbsp;</td>
</tr>
<tr>
<td width="25%"></td>
<td align="center" width="40%"><strong><font color= "#3a728a">
<% 
Connection oConn = ConnectionFactory.getInstance().getConnection(Constants.SAPFMTIPT_DATASOURCE);
Statement oStmt =null;
ResultSet oRS = null;
oStmt = oConn.createStatement();

Statement oStmt1 =null;
ResultSet oRS1 = null;
oStmt1 = oConn.createStatement();

try{
	
	String memberName = "";
	//String sql = "Select Name3 from SAPFMTIPT.dbo.SAP_Member Where CompanyCode = 2000 and DeleteFlag='N' and HQFlag ='Y' and GeoAppDisplay = 'Y' and MbrMajNbr = '"+memberID+"'";
		//System.out.println(sql);
	oRS = oStmt.executeQuery("Select Name3 from SAPFMTIPT.dbo.SAP_Member Where CompanyCode = 2000 and DeleteFlag='N' and HQFlag ='Y' and GeoAppDisplay = 'Y' and MbrMajNbr = '"+memberID+"'");  
	 if (oRS.next())
			{ 
           		memberName = oRS.getString("Name3");
%>   
    
    <h1>My Requests - <%=memberName%></h1></font></strong></td>
    
    	   <%}else{
%> 
    <h1>My Requests</h1></font></strong></td> 
    	  <% } %> 
<td width="25%">&nbsp;</td>
</tr>
</tbody>
</table>
<br>
<div name="menu" id="menu" align="right">
<ul>
	<li><a href="./index.jsp">Home</a></li>
	<li><a href="./myRequests.jsp">My Requests</a></li>
	<li><a href="./completedRequests.jsp">View Completed Requests</a></li>
	<li><a href="http://www.networkdistribution.com/MemberPortal/Operations/MST Tutorial.pdf" target="_blank">User Guide</a></li>
</ul>
</div>
<br>
<table align="center" width="90%">
 
	<tbody>
	<tr>
	  <th>Request ID:</th>
	  <th>Requester</th>
	  <th>Corporate Account:</th>
	  <th>Status:</th>
	  <th>Date Submitted:</th>
	  <!--  <th>Material Setup Form:</th>-->
	  <th>Notes:</th>
	</tr>
<% 
	//sql ="Select RequestID, Status, Requestor, CustomerNbr, RequestDate, Filename, Comments From SAPFMTIPT.dbo.MST_Request  Where MemberNbr ="+memberID+" and Status = 'Submitted' or Status = 'In Progress' or Status = 'Pending' or Status = 'Partial'";
		//System.out.println(sql);
	oRS = oStmt.executeQuery("Select RequestID, Status, Requestor, CustomerNbr, RequestDate, Filename, Comments From SAPFMTIPT.dbo.MST_Request  Where MemberNbr ="+memberID+" and Status != 'Completed' and Status != 'Withdrawn' ");
	while (oRS.next()){	
		//System.out.println("SQL in MyRequestPage");
		cust = "";
		reqID = oRS.getString("RequestID");
		requester = oRS.getString("Requestor");
		corpAcct = oRS.getString("CustomerNbr");
		System.out.println(corpAcct);
		request.getSession().setAttribute("corpAcct", corpAcct);
		status = oRS.getString("Status");
		request.getSession().setAttribute("status", status);
		dateSub = oRS.getString("RequestDate");
		String string = dateSub;
		String[] parts = string.split("-|:| ");
		String parts0 = parts[0];
		String parts1 = parts[1];
		String parts2 = parts[2];
		String parts3 = parts[3];
		String parts4 = parts[4];
		dateSub =  parts1+"/"+parts2+"/"+parts0; //+" "+parts3+":"+parts4;
		//System.out.println(dateSub);
		form = oRS.getString ("Filename");
		notes = oRS.getString("Comments");
		
							//sql ="Select DISTINCT CustMajNbr, CustomerName From SAPFMTIPT.dbo.SAP_Customer Where CustMajNbr IN ("+corpAcct+") order by CustomerName";
									//System.out.println(sql);
		oRS1=oStmt1.executeQuery("Select CustMajNbr, CustomerName From SAPFMTIPT.dbo.SAP_Customer Where CustMajNbr IN ("+corpAcct+") and CompanyCode = '2000' and CustMinNbr = '000000' order by CustomerName");
		while(oRS1.next()){
			custID = oRS1.getString("CustMajNbr");
			customer = oRS1.getString("CustomerName");
			cust = cust + custID + " - " + customer + ", ";
			System.out.println(cust);
			//System.out.println(customer);
			//System.out.println(cust);
		}
		
		cust = cust.replaceAll(", $", "");
		
		if(cust.equals("")){
			cust = "N/A";
		}
		
%>
	<tr bgcolor="<%=alternatingColors[j%2]%>" valign="top">
	  <td width="5%" align="center"><a href="./viewRequest.jsp?reqID=<%=reqID%>" name="reqID" id ="reqID" value="<%=reqID%>"><%=reqID%></a></td>
	  <td width="10%" align="center"><%=requester%></td>
	  <td width="20%" align="left"><%=cust%></td>
	  <td width="10%" align="center"><%=status%></td>
	  <td width="10%" align="center"><%=dateSub%></td>
	  <!--<td align="center"><a href="C:/users/srussell/MSTworkspace/MST1/WebContent/UploadFiles/<%=form%>"><%=form%></a></td>-->
	  <!--<td align="center"><a href="./UploadFiles/<%=form%>"><%=form%></a></td>-->
	  <td width="20%" align="left"><%=notes%></td>
<% 
		
		j++;
    	}
	
   
%>
	</tr>
	<tr>
	  <td></td>
	  <td>&nbsp;</td>
	  <td></td>
	</tr>
	</tbody>
</table>
	<table>
	<tr>
	  <td></td>
	  <td>&nbsp;</td>
	  <td></td>
	</tr>
	<tr>
	  <td></td>
	  <td align="center"><a href="mailto:ProductSupportGroup@networkdistribution.com">Email Product Support</a></td>
	  <td></td>
	</tr>
	<tr>
	  <td></td>
	  <td>&nbsp;</td>
	  <td></td>
	</tr>
	<tr>
	  <td></td>
	  <td>&nbsp;</td>
	  <td></td>
	</tr>
   </tbody>
  </table>
<%    
	}

 		catch(Exception exc) 
		{
            LOGGER.error("MST " + exc.getMessage(), exc);
            System.out.println("MST myRequest Page Exception = "+exc);
		}

		finally {

				try {
					if(oRS != null)
						oRS.close();
					if(oStmt != null)
						oStmt.close();
					if(oConn != null)
						oConn.close();

					} catch(Exception exc) 
						{
							System.out.println("MST myRequest fianlly/try Exception = "+exc);
							LOGGER.error("MST " + exc.getMessage(), exc); 
						}
						

			}
%>  
</body>
</html>