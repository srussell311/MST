<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ page import ="java.util.*" %>
<%@ page import ="java.util.Scanner.*" %>
<%@ page import="java.lang.*, java.lang.String, java.io.*, java.sql.*, java.text.*"%>
<%@ page import="com.nsc.mst.utils.*, com.nsc.SSOfilter.*, com.nsc.mst.dataaccess.*, com.nsc.mst.*"%>
<%@ page import="com.nsc.SSOfilter.*" %>
<%@ page import= "org.apache.log4j.Logger"%>
<%@ page import= "org.apache.log4j.PropertyConfigurator"%>
<%@ page import= "com.nsc.mst.readexcel.*"%>
<%@ page import= "org.apache.commons.fileupload.FileItem" %>
<%
String requestID = (String)session.getAttribute("requestID");
//System.out.println("requestId is " + requestID);
//SSOfilter filter = new SSOfilter(); //Comment out to debug
//filter.doFilter(request, response);  //Comment out to debug
 String portalUser = "srussell";    ///////Fill this in when testing locally!
 String memberID = "127";
 String userEmail = "srussell@networkdistribution.com";
String userName = "Sean Russell";

/*String portalUser = "";
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
}*/

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
//Logger LOGGER = Logger.getLogger(com.nsc.mst.controller.MSTUtils.class);

int member = Integer.parseInt(memberID);
//System.out.println(member);
String itemExistFlag = (String)session.getAttribute("itemExistFlag");
//System.out.println(itemExistFlag);

String acctValues = (String)session.getAttribute("acctValues");
//System.out.println(acctValues);
String custValues = acctValues.replaceAll("\\D+",",");
custValues = custValues.substring(1);
//System.out.println(custValues);
String reqEmail = userEmail;
String corpAcct2 = (String)session.getAttribute("corpAcct2");
String addEmail = (String)session.getAttribute("addEmail");
String addEmail1 = (String)session.getAttribute("addEmail1");
String addEmail2 = (String)session.getAttribute("addEmail2");
String notes = (String)session.getAttribute("notes");
String subject = (String)session.getAttribute("subject");
String [] alternatingColors ={"#e5e5e5", "#ffffff"}; 
String sapID = "";
String upc = "";
String supplierName = "";
String manfItem = "";
String itemDesc = "";
String uom = "";
String customer = "";
String custID = "";
String cust = "";

int rowN=0;
int j = 0;
//System.out.println(subject);
int assigned = 0;
String status = "Submitted";
String velvet= "";

String filename = (String)session.getAttribute("filename");

//System.out.println("filename = " + filename);

Connection oConn = ConnectionFactory.getInstance().getConnection(Constants.SAPFMTIPT_DATASOURCE);
Statement oStmt =null;
ResultSet oRS = null;
oStmt = oConn.createStatement();
	
%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>NETWORK Material Setup Request</title>
   
<link href="../../NSCMemUtils/web/css/NewItemSetup.css" rel="stylesheet" type="text/css" />
<link href="NewItemSetup.css" rel="stylesheet" type="text/css" />
</head>

<body id="wrapper" style="border: 5px solid #4f758b; border-radius: 25px;">
<table width="90%" align="center">
<br />

 <tr>
   <input type="hidden" name="subject" id="subject" value="New Material Setup Request" />
 </tr>
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
    
    <h1>Request Submitted - <%=memberName%></h1></font></strong></td>
    	   <%}else{
%> 
    <h1>Request Submitted</h1></font></strong></td> 
    	  <% } %> 
     <td width="25%">&nbsp;</td>
  </tr>
 </tbody>
</table>
</br>
 <ul>
	<li><a href="./index.jsp">Home</a></li>
	<li><a href="./myRequests.jsp">My Requests</a></li>
	<li><a href="./completedRequests.jsp">View Completed Requests</a></li>
	<li><a href="http://www.networkdistribution.com/MemberPortal/Operations/MST Tutorial.pdf" target="_blank">User Guide</a></li>
 </ul>
<br>
<form enctype="text/plain">
<table width ="100%">
 <tbody>
   <tr>
     <td></td>
     <td align="center" width="50%"><h2><strong>Your request was submitted successfully.<br>When your request is completed you will receive<br>an email from NETWORK's Product Support team.</strong></h2></td>
     <td></td>
   </tr>
 </tbody>
</table>
<table width="100%">
  <tbody>
   <tr>
     <th align="center">Request ID:</th>
     <th align="center">Corporate Account(s):</th>
     <th align="center">Email Address:</th>
     <th align="center">Additional Email Addresses:</th>
     <th align="center">Notes:</th>
   </tr>
<%    
		oRS=oStmt.executeQuery("Select DISTINCT CustMajNbr, CustomerName From SAP_Customer Where CustMajNbr IN ("+acctValues+")");
			while(oRS.next()){
				customer = oRS.getString("CustomerName");
				custID = oRS.getString("CustMajNbr");
				cust = cust + custID + " - " + customer + ", ";
				//System.out.println(customer);
				//System.out.println(cust);
				}
			cust = cust.replaceAll(", $", "");
           
        oRS = oStmt.executeQuery("Select RequestID, CustomerNbr, RequestorEmail, CCEmail, CCEmail1, CCEmail2, Comments FROM SAPFMTIPT.dbo.MST_Request Where RequestID = "+requestID+"");
			while (oRS.next()){  		
        		requestID = oRS.getString("RequestID");
        		//acctValues = oRS.getString("CustomerNbr");
        		reqEmail = oRS.getString("RequestorEmail");
        		addEmail = oRS.getString("CCEmail");
        		addEmail1 = oRS.getString("CCEmail1");
        		addEmail2 = oRS.getString("CCEmail2");
        		notes = oRS.getString("Comments");
 %>
   <tr bgcolor="<%=alternatingColors[j%2]%>" valign="top">
	<td align="center" width="10%"><%=requestID%></td>
	<td align="center" width="20%"><%=cust%>&nbsp;</td>
	<td align="center" width="20%"><%=reqEmail%>&nbsp;</td>
	<td align="center" width="20%"><%=addEmail%> <%=addEmail1%> <%=addEmail2%>&nbsp;</td>
	<td align="left" width="30%"><%=notes%></td>
   </tr>
 <%} %>
   <tr>
 	<td></td>
 	<td>&nbsp;</td>
 	<td></td>
   </tr>
 <% 
			
			
}	catch(Exception exc)
	 {
  	//LOGGER.error("MST " + exc.getMessage(), exc);
      System.out.println("Request Submitted page Exception = " + exc);
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
                 			System.out.println("Request submitted finally/try Exception = " + exc);
						}
				
				}
	
%>
	</tr>
  </tbody>
 </table>
 <input type="hidden" name="portalUser" id="portalUser" value="<%=portalUser%>"/>
 <input type="hidden" name="memberID" id="memberID" value="<%=memberID%>"/>
 <input type="hidden" name="userEmail" id="userEmail" value="<%=userEmail%>"/>
 <input type="hidden" name="userName" id="userName" value="<%=userName%>"/>
</form>
<br />
<br />
<br />
<br />
<p align="center"><a href="./index.jsp">Return To Home Page</a></p>
<br />
<br />
</body>
</html>
