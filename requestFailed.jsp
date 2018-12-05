<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ page import ="java.util.*" %>
<%@ page import ="com.nsc.mst.utils.Constants.*" %>
<%@ page import="com.nsc.mst.utils.*, com.nsc.mst.dataaccess.*, com.nsc.mst.*"%>
<%@ page import="java.lang.*, java.lang.String, java.io.*, java.sql.*, java.text.*"%>
<%@ page import="com.nsc.SSOfilter.*" %>
<%@ page import= "org.apache.log4j.Logger"%>
<%@ page import= "org.apache.log4j.PropertyConfigurator"%>

<%
//SSOfilter filter = new SSOfilter(); //Comment out to debug
//filter.doFilter(request, response);  //Comment out to debug
/* String portalUser = "srussell";    ///////Fill this in when testing locally!
 String memberID = "127";
 String userEmail = "srussell@networkdistribution.com";
String userName = "Sean Russell";*/

String portalUser = "";
String memberID = "";
String userEmail = "";
String userName = "";

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

/*portalUser = request.getParameter("portalUser");
memberID = request.getParameter("memberID");
userEmail = request.getParameter("userEmail");
userName = request.getParameter("userName");*/

request.getSession().setAttribute("memberID", memberID);
memberID = String.format("%03d", Integer.parseInt(memberID));
//memberID = "127";
Connection oConn = ConnectionFactory.getInstance().getConnection(Constants.SAPFMTIPT_DATASOURCE);
Statement oStmt =null;
ResultSet oRS = null;
oStmt = oConn.createStatement();
%>
<script>

function ValidateForm() {
     var setup = document.home.SetupType
	 
	 if ((emailID.value==null)||(emailID.value=="")){
		alert("Please enter your email address.")
		emailID.focus()
		return false	
	 }
	 
	 return true	
	
}

</script>


<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title>NETWORK Material Setup Request</title>
   
<link href="../../NSCMemUtils/web/css/NewItemSetup.css" rel="stylesheet" type="text/css" />
<link href="NewItemSetup.css" rel="stylesheet" type="text/css" />
</head>

<body id="wrapper" style="border: 5px solid #4f758b; border-radius: 25px;">



<table width="80%" align="center">
 <tbody>
 	<input type="hidden" name="subject" id="subject" value="New Material Setup Request" />
 	<input type="hidden" name="portalUser" id="portalUser" value="<%=portalUser%>"/>
 	<input type="hidden" name="memberID" id="memberID" value="<%=memberID%>"/>
 	<input type="hidden" name="userEmail" id="userEmail" value="<%=userEmail%>"/>
 	<input type="hidden" name="userName" id="userName" value="<%=userName%>"/>

   <tr>
	<td align="left" width="25%"><img src="./images/logo.png" /></td>
	<td align="center" width="40%"><h1 style="font-size:30px"><strong><font color= "#3a728a">MATERIAL SETUP TOOL</font></strong></h1><br/></td>
	<td width="25%">&nbsp;</td>
</tr>
   <tr>
     <td width="25%"></td>
     <td align="center" width="40%"><strong><font color= "#3a728a">
<%


try{
		String memberName = "";
			
	oRS = oStmt.executeQuery("Select Name3 from SAPFMTIPT.dbo.SAP_Member Where CompanyCode = 2000 and DeleteFlag='N' and HQFlag ='Y' and GeoAppDisplay = 'Y' and MbrMajNbr = '"+memberID+"'");  
	 if (oRS.next())
			{ 
           		memberName = oRS.getString("Name3");
%>   
    
    <h1>Request Failed To Submit - <%=memberName%></h1></font></strong></td>
    	   <%}else{
%> 
    <h1>Request Failed To Submit</h1></font></strong></td> 
    	  <% } %> 
     <td width="25%">&nbsp;</td>
  </tr>
 </tbody>
</table>
<br>
</br>
<ul>
	<li><a href="./index.jsp">Home</a></li>
	<li><a href="./myRequests.jsp">Requests</a></li>
	<li><a href="./completedRequests.jsp">View Completed Requests</a></li>
	<li><a href="http://www.networkdistribution.com/MemberPortal/Operations/MST Tutorial.pdf" target="_blank">User Guide</a></li>
</ul>
<br>
<form name="home" id="home">
<table>
<tbody>
     <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td></td>
      <td align="center"><h2><strong>Your request failed to submit because required fields were left blank.<br>Please ensure that all required fields are filled out.<br/>Required fields are:<br><br><font color="red">Manufacturer Name<br>Manufacturer Item #<br>Full Description<br>Customer Brand<br>Member Private Label<br>Selling Unit<br>Case Pack of UOM</font><br></strong></h2></td>
      <td></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
	  <td></td>
      <td></td>
      <td></td>
</tr>
 <tr>
      <td>&nbsp;</td>
    </tr>
 <tr>
	  <td></td>
      <td></td>
      <td></td>
</tr>
  </tbody>
 </table>
</form>
<% 
			
			
}	catch(Exception exc)
	 {
  	//LOGGER.error("MST " + exc.getMessage(), exc);
      System.out.println("Request Failed page Exception = " + exc);
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
                 			//LOGGER.error("MST " + exc.getMessage(), exc);
                 			System.out.println("Request Failed fianlly/try page Exception = " + exc);
						}
				
			}
	
%>
<br />
<br />
<br />
<br />
<p align="center"><a href="./index.jsp">Return To Home Page</a></p>
<br />
<br />
</body>
</html>
