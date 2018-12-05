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

memberID = String.format("%03d", Integer.parseInt(memberID));
//memberID = "070";
Logger LOGGER = Logger.getLogger(com.nsc.mst.controller.MSTUtils.class);

//int member = Integer.parseInt(memberID);
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

//Check the Valid flag and the Already Setup flag to check boxes if line item required feilds are not filled out or the item is already setup 
//SQL Query to write the request to the SAPFMTIPT DB

	
%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--  <h2>${requestScope.message}</h2>-->
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
	<td align="left"><img src="./images/logo.png" /></td>
	<td align="left"><h1 style="font-size:30px"><strong><font color= "#3a728a">MATERIAL SETUP TOOL</font></strong></h1></td>
	<td></td>
</tr>
</table>
</br>
<ul>
	<li><a href="./index.jsp">Home</a></li>
	<li><a href="./UserMyRequests.jsp">My Requests</a></li>
	<li><a href="./ReqCompleted.jsp">View Completed Requests</a></li>
</ul>
<br>
<form enctype="text/plain">
<table width ="100%">
<tbody>
    <tr>
      <td></td>
      <td align="center" width="50%"><h2><strong>Your request was submitted successfully.<br>You will recieve an email confirmation of this submission.<br>You will also receive an email once your request has been completed.</strong></h2></td>
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

try {       
        oRS = oStmt.executeQuery("Select RequestID, CustomerNbr, RequestorEmail, CCEmail, CCEmail1, CCEmail2, Comments FROM SAPFMTIPT.dbo.MST_Request Where RequestID = "+requestID+"");
			while (oRS.next()){  		
        		requestID = oRS.getString("RequestID");
        		acctValues = oRS.getString("CustomerNbr");
        		reqEmail = oRS.getString("RequestorEmail");
        		addEmail = oRS.getString("CCEmail");
        		addEmail1 = oRS.getString("CCEmail1");
        		addEmail2 = oRS.getString("CCEmail2");
        		notes = oRS.getString("Comments");
 %>
   <tr bgcolor="<%=alternatingColors[j%2]%>" valign="top">
	<td align="center" width="10%"><%=requestID%></td>
	<td align="center" width="20%"><%=acctValues%>&nbsp;</td>
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
  </tbody>
 </table>
<table>
 <tbody>
   <tr>
    <td></td>
    <td align="center"><h1 style="font-size:20px"><strong><font color= "#FF000">Submitted Item(s) Already Setup</font></strong></h1></td>
    <td></td>
   </tr>
  </tbody>
 </table>
 <table>
  <tbody>
   <tr>
     <th align="center">SAP Item Number:</th>
     <th align="center">UPC:</th>
     <th align="center">Supplier Name:</th>
     <th align="center">Manufacturer Item #:</th>
     <th align="center">Item Description:</th>
     <th align="center">Unit of Measure:</th>
   </tr>
<% 

		oRS = oStmt.executeQuery("Select DISTINCT si.SAPItemNbr, si.UPC, ss.SupplierName, si.ManufItemNbr,si.ItemDescr, si.UOM From SAPFMTIPT.dbo.SAP_Item si JOIN SAPFMTIPT.dbo.SAP_Supplier ss on si.SupplierNbr = ss.SupplierNbr Where EXISTS (Select UPC From SAPFMTIPT.dbo.MST_RequestDtl Where RequestID = '"+requestID+"' and UPC = si.UPC)");
			while (oRS.next()){
				sapID = oRS.getString("SAPItemNbr");
				upc = oRS.getString("UPC");
				supplierName = oRS.getString("SupplierName");
				manfItem = oRS.getString("ManufItemNbr");
				itemDesc = oRS.getString("ItemDescr");
				uom = oRS.getString("UOM");
%>      
   <tr bgcolor="<%=alternatingColors[j%2]%>" valign="top">
	<td align="center" width="10%"><%=sapID%></td>
	<td align="center" width="10%"><%=upc%></td>
	<td align="center" width="20%"><%=supplierName%>&nbsp;</td>
	<td align="center" width="20%"><%=manfItem%>&nbsp;</td>
	<td align="center" width="20%"><%=itemDesc%>&nbsp;</td>
	<td align="left" width="20%"><%=uom%></td>
   </tr>
<%
		} 
			
			
}	catch(Exception exc)
	 {
  	//LOGGER.error("MST " + exc.getMessage(), exc);
      System.out.println("This is the Exception" + exc);
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
                 			System.out.println("This is the Exception" + exc);
						}
				
			}
	
%>
	</tr>
  </tbody>
 </table>
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
