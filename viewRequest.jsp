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
String status = "";

/*portalUser = request.getParameter("portalUser");
memberID = request.getParameter("memberID");
userEmail = request.getParameter("userEmail");
userName = request.getParameter("userName");*/

request.getSession().setAttribute("memberID", memberID);
memberID = String.format("%03d", Integer.parseInt(memberID));
//memberID = "127";

String reqID = request.getParameter("reqID");
//System.out.println(reqID);
//String status = request.getParameter("status");
//System.out.println(status);
String [] alternatingColors = {"#e5e5e5","#cccccc"};
int rowN=0;
int j = 0;

Connection oConn = ConnectionFactory.getInstance().getConnection(Constants.SAPFMTIPT_DATASOURCE);
Statement oStmt =null;
ResultSet oRS = null;
oStmt = oConn.createStatement();

String corpAcct = "";
String reqSelect = request.getParameter("reqSelect");
//System.out.println("S.R. " + reqSelect);

try{
	
oRS=oStmt.executeQuery("Select CustomerNbr, Status from MST_Request Where RequestID="+reqID+"");
	while(oRS.next()){
		corpAcct = oRS.getString("CustomerNbr") + ",";
		//System.out.println(corpAcct);
		status = oRS.getString("Status");
	}
	
corpAcct = corpAcct.replaceAll(",$", "");
//System.out.println(corpAcct);
//System.out.println(status);
//System.out.println(reqID);
String custName = "'" + corpAcct.replaceAll(",", "','") + "'";
//System.out.println(custName);
custName = custName.replaceAll(",$", "");
//System.out.println(custName);
String customer = "";
String custID = "";
String cust = "";
String sapItem = "";

oRS=oStmt.executeQuery("Select CustMajNbr, CustomerName From SAP_Customer Where CustMajNbr IN ("+custName+") and CompanyCode = '2000' and CustMinNbr = 000000 order by CustomerName");
	while(oRS.next()){
		customer = oRS.getString("CustomerName");
		custID = oRS.getString("CustMajNbr");
		cust = cust + custID + " - " + customer + ", ";
		//System.out.println(customer);
		//System.out.println(cust);
		}
//System.out.println(customer);	
cust = cust.replaceAll(", $", "");
request.getSession().setAttribute("cust", cust);
//System.out.println(cust);
String alreadySetup = "";
String assignment = "";
String reassigned = "";
String firstName = "";
String lastName = "";

%>

<script>

function RadioValue(){
var reqSelect = document.getElementById('reqSelect').value;
var reqValue = null;

if(document.getElementById('reqSelect').checked) {
	reqValue = document.geElementById('reqSelect').value;
	alert(reqSelect);
		}
	return true
}


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


<table width="100%" align="center">
 <input type="hidden" name="portalUser" id="portalUser" value="<%=portalUser%>"/>
 <input type="hidden" name="memberID" id="memberID" value="<%=memberID%>"/>
 <input type="hidden" name="userEmail" id="userEmail" value="<%=userEmail%>"/>
 <input type="hidden" name="userName" id="userName" value="<%=userName%>"/>
<br />
<tr>
	<td align="left" width="25%"><img src="./images/logo.png" /></td>
	<td align="center" width="40%"><h1 style="font-size:30px"><strong><font color= "#3a728a">MATERIAL SETUP TOOL</font></strong></h1><br/></td>
	<td width="25%">&nbsp;</td>
</tr>
<tr>
<td width="25%"></td>
<td align="center" width="40%"><strong><font color= "#3a728a">
<% 
	
	String memberName = "";
	
	oRS = oStmt.executeQuery("Select Name3 from SAPFMTIPT.dbo.SAP_Member Where CompanyCode = 2000 and DeleteFlag='N' and HQFlag ='Y' and GeoAppDisplay = 'Y' and MbrMajNbr = '"+memberID+"'");  
	 if (oRS.next())
			{ 
           		memberName = oRS.getString("Name3");
%>   
    
    <h1>Request Details - <%=memberName%></h1></font></strong></td>
    	   <%}else{
 %> 
    <h1>Request Details</h1></font></strong></td> 
    	  <% }%> 
<td width="25%">&nbsp;</td>
</tr>
</tbody>
</table>
<br/>

<ul>
	<li><a href="./index.jsp?portalUser=<%=portalUser%>&memberID=<%=memberID%>&userEmail=<%=userEmail%>&userName=<%=userName%>">Home</a></li>
	<li><a href="./myRequests.jsp?portalUser=<%=portalUser%>&memberID=<%=memberID%>&userEmail=<%=userEmail%>&userName=<%=userName%>">My Requests</a></li>
	<li><a href="./completedRequests.jsp?portalUser=<%=portalUser%>&memberID=<%=memberID%>&userEmail=<%=userEmail%>&userName=<%=userName%>">View Completed Requests</a></li>
	<li><a href="http://www.networkdistribution.com/MemberPortal/Operations/MST Tutorial.pdf" target="_blank">User Guide</a></li>
</ul>
<%

//String sql = "Select mr.RequestID, mr.CustomerNbr, mr.Status, mr.RequestorEmail, mr.CCEmail, mr.CCEmail1, mr.CCEmail2, mr.AssignedTo, mr.RequestDate, mr.Filename, ms.StatusDate, ms.StatusNotes, mr.VelvetCustomer, mr.MemberNbr From SAPFMTIPT.dbo.MST_Request mr JOIN SAPFMTIPT.dbo.MST_Status ms on  ms.RequestID = mr.RequestID  Where mr.RequestID = "+reqSelect+"";
	//System.out.println(sql);
	//oRS = oStmt.executeQuery("Select mr.RequestID, mr.CustomerNbr, mr.Status, mr.RequestorEmail, mr.CCEmail, mr.CCEmail1, mr.CCEmail2, mr.AssignedTo, mr.RequestDate, mr.Filename, ms.StatusDate, mr.PSTComments, mr.VelvetCustomer, mr.MemberNbr, mr.Comments From SAPFMTIPT.dbo.MST_Request mr JOIN SAPFMTIPT.dbo.MST_Status ms on  ms.RequestID = mr.RequestID  Where mr.RequestID = "+reqID+" and mr.Status='"+status+"'");
	//oRS = oStmt.executeQuery("Select mr.RequestID, mr.CustomerNbr, mr.Status, mr.RequestorEmail, mr.CCEmail, mr.CCEmail1, mr.CCEmail2, mr.AssignedTo, mr.RequestDate, mr.Filename, mr.PSTComments, mr.VelvetCustomer, mr.MemberNbr, mr.Comments, ms.StatusDate From SAPFMTIPT.dbo.MST_Request mr INNER JOIN (Select RequestID, MAX(StatusDate) as StatusDate From SAPFMTIPT.dbo.MST_Status Group by RequestID) ms on  mr.RequestID = ms.RequestID Where mr.RequestID ="+reqID+"");
	oRS = oStmt.executeQuery("Select mr.RequestID, mr.CustomerNbr, mr.Status, mr.RequestorEmail, mr.CCEmail, mr.CCEmail1, mr.CCEmail2, mr.AssignedTo, mr.RequestDate, mr.Filename, mr.PSTComments, mr.VelvetCustomer, mr.MemberNbr, mr.Comments, ISNULL(mr.LastModifiedDate, mr.RequestDate) as LastModifiedDate From SAPFMTIPT.dbo.MST_Request mr Where mr.RequestID ="+reqID+"");
	while (oRS.next()) {
		reqID = oRS.getString ("RequestID");
		//request.getSession().setAttribute("reqID", reqID);
		
		corpAcct = oRS.getString ("CustomerNbr");
		//System.out.println(corpAcct);
		status= oRS.getString ("Status");
		String reqEmail= oRS.getString ("RequestorEmail");
		String addEmail = oRS.getString ("CCEmail");
		String addEmail1 = oRS.getString ("CCEmail1");
		String addEmail2 = oRS.getString ("CCEmail2");
		int assigned = oRS.getInt("AssignedTo");
		//System.out.println(assigned);
		String dateSub = oRS.getString ("RequestDate");
		String string = dateSub;
		String[] parts = string.split("-|:| ");
		String parts0 = parts[0];
		//System.out.println(parts0);
		String parts1 = parts[1];
		//System.out.println(parts1);
		String parts2 = parts[2];
		//System.out.println(parts2);
		String parts3 = parts[3];
		//System.out.println(parts3);
		String parts4 = parts[4];
		dateSub =  parts1+"/"+parts2+"/"+parts0 +" "+parts3+":"+parts4;
		//System.out.println(dateSub);
		String form = oRS.getString("Filename");
		String dateMod = oRS.getString("LastModifiedDate");
		String modDate = dateMod;
		String[] part = modDate.split("-|:| ");
		String part0 = part[0];
		String part1 = part[1];
		String part2 = part[2];
		String part3 = part[3];
		String part4 = part[4];
		dateMod = part1+"/"+part2+"/"+part0 +" "+part3+":"+part4;
		//System.out.println(dateMod);
		String reqNotes = oRS.getString("PSTComments");
		if (reqNotes == null){
			reqNotes = "";
		}
		String velvet = oRS.getString ("VelvetCustomer");
		String mbrNbr = oRS.getString ("MemberNbr");
		String notes = oRS.getString("Comments");
		request.getSession().setAttribute("corpAcct", corpAcct);
		request.getSession().setAttribute("status", status);
		request.getSession().setAttribute("reqEmail", reqEmail);
		request.getSession().setAttribute("addEmail", addEmail);
		request.getSession().setAttribute("addEmail1", addEmail1);
		request.getSession().setAttribute("addEmail2", addEmail2);
		request.getSession().setAttribute("assigned", assigned);
		request.getSession().setAttribute("dateSub", dateSub);
		request.getSession().setAttribute("reqNotes", reqNotes);
		request.getSession().setAttribute("form", form);
		request.getSession().setAttribute("dateMod", dateMod);
					
		
%>
<br>
<form action="./UpdateRequest.jsp" method="post">
<table width="100%" align="center">
	<tbody align="center">
	<tr> 
	  <th align="left" width="20%" >Request ID:</th>
	  <td align="left" width="30%"><%=reqID%></div></td>
	  <th align="left" width="20%">Material Setup Form:</th>
	  <!--<td align="left"><a href="C:/users/srussell/MSTworkspace/MST1/WebContent/UploadFiles/<%=form%>"><%=form%></a></td>-->
	   <!--<td width="30%" align="left"><a href="http://www.nscqa.com/MST/<%=form%>">Download</a></td>--> 
	  <td width="30%" align="left"><a href="http://www.nsconline.com/MST/<%=form%>">Download</a></td>
	</tr>
	<tr>
	 <td>&nbsp;</td>
	 <td>&nbsp;</td>
	</tr>
	<tr>
	  <th align="left">Distributor:</th>
<%  if(memberID.equals("001")){
%> <td align="left">Network Generated Request</td>	
	<%}else{
	//String sql = "Select Name3 from SAPFMTIPT.dbo.SAP_Member Where CompanyCode = 2000 and DeleteFlag='N' and HQFlag ='Y' and GeoAppDisplay = 'Y' and MbrMajNbr = '"+memberID+"'";
		//System.out.println(sql);
		
	oRS=oStmt.executeQuery("Select Name3 from SAPFMTIPT.dbo.SAP_Member Where CompanyCode = 2000 and DeleteFlag='N' and HQFlag ='Y' and GeoAppDisplay = 'Y' and MbrMajNbr = '"+memberID+"'");
		while(oRS.next()){
		String mbrName = oRS.getString("Name3");
		//System.out.println(mbrName);
%>		
		<td align="left"><%=memberID%> - <%=mbrName%></td>	

<% 		} 
	}
%>
	  <th align="left">Status:</th>
	  <td align="left"><%=status%></td>
	</tr>
	<tr>
	 <td>&nbsp;</td>
	 <td>&nbsp;</td>
	</tr>
	<tr>
	<th align="left">Corporate Account:</th>
	<%if(corpAcct.equals("0")){%>
	 <td align="left" width="25%">N/A</td>	
	<%}else{ %>
	 <td align="left" width="25%"><%=cust%></td>	
	 <%} %>
	 <th align="left">Assigned To:</th>
<%
	//String sql = "Select FirstName, LastName From formularymanagement.dbo.FormularyUser Where UserID = "+assigned+"";
		//System.out.println(sql);
	oRS = oStmt.executeQuery("Select FirstName, LastName From formularymanagement.dbo.FormularyUser Where UserID = "+assigned+"");
		if(oRS.next()){
			firstName = oRS.getString("FirstName");
			lastName = oRS.getString("LastName");
			%>			
			<td align="left"><%=firstName%> <%=lastName%></td>	
			 <%
		}
		else {		
%>		 
			 <td align="left">Unassigned</td>				
<%		} 			
	 
	    %>
	</tr>
	<tr>
	 <td>&nbsp;</td>
	 <td>&nbsp;</td>
	</tr>
	<tr>
	  <th align="left">Requester Email:</th>
	  <td align="left"><%=reqEmail%></td>
	  <th align="left">Date Submitted:</th>
	  <td align="left"><%=dateSub%></td>
	</tr>
	<tr>
	 <td>&nbsp;</td>
	 <td>&nbsp;</td>
	</tr>
	<tr>
	  <th align="left">CC'd Email Address:</th>
	  <td align="left"><%=addEmail%></td>
	  <th align="left">Date Modified:</th>
	  <td align="left"><%=dateMod%></td> 
	</tr>
	<tr>
	 <td>&nbsp;</td>
	 <td>&nbsp;</td>
	</tr>
	<tr>
	  <th align="left">CC'd Email Address:</th>
	  <td align="left"><%=addEmail1%></td>
	  <th align="left">Comments:<br /></th>
	  <td align="left"><%=notes%><br/><%=reqNotes%></td>
	</tr> 
	<tr>
	 <td>&nbsp;</td>
	 <td>&nbsp;</td>
	</tr> 
	<tr> 
	  <th align="left">CC'd Email Address:</th>
	  <td align="left"><%=addEmail2%></td>
	  <th></th>
	  <td></td>
	</tr>
    <tr>
	 <td>&nbsp;</td>
	 <td>&nbsp;</td>
	</tr>
	<tr>
	 
	 <th></th>
	 <td></td>
	 <!--  <th align="left">Additional Notes:<br /></th>-->
	  <!--  <td align="left"><textarea class="Desc" name="Desc" id="Desc" type="text" tabindex="" rows="7" cols="50" size="50" maxlength="400"></textarea><br /><br /></td>-->
	</tr>
  </tbody>
</table>

<table>
 <tbody>
 <tr>
  <td></td>
  <td align="center" style="font-size:15px"><strong>Submitted Item Details:</strong></td>
  <td></td>
 </tr>
 </tbody>
 </table>
 <table>
 <tbody>
 <tr>
  <td align="left" style="font-size:11px"><strong><font style="color:red">*</font>If 'Y' is listed in Possible Item Match column,<br>check for item in Item Lookup application.</strong></td>
  <td></td>
  <td></td>
 </tr>
  </tbody>
 </table>
 <table width="100%">
  <tbody>
  <tr>
   <th>Line #:</th>
   <th>Possible<br>Item<br>Match:</th>
   <th>Need<br/>Additional<br/>Information:</th>
   <th>UPC:</th>
   <th>SAP Item #:</th>
   <th>MFG Item #:</th>
   <th>Item Description:</th>
   <th>MFG Name:</th>
   <th>UOM:</th>
   <th>CasePack:</th>
  </tr>
 <%
 
 //oRS = oStmt.executeQuery("Select DISTINCT rd.RequestID,rd.ItemExistFlag, ms.Status, rd.LineItemNbr,rd.UPC,rd.SAPItemNbr,rd.ManufItemNbr,rd.ItemDescr,rd.SupplierName,rd.UOM From dbo.MST_RequestDtl rd JOIN  dbo.MST_Status ms on ms.RequestID = rd.RequestID Where rd.RequestID ="+reqID+" and ms.Status = '"+status+"' Order By rd.LineItemNbr");
 oRS = oStmt.executeQuery("Select rd.LineItemNbr,rd.UPC,rd.ItemExistFlag,rd.MoreInfoFlag,rd.SAPItemNbr,rd.ManufItemNbr,rd.ItemDescr,rd.SupplierName,rd.UOM,rd.CasePack From SAPFMTIPT.dbo.MST_RequestDtl rd where rd.RequestID ="+reqID+" Order By rd.LineItemNbr");
	while (oRS.next()) {
		//reqID = oRS.getString ("RequestID");
		//request.getSession().setAttribute("reqID", reqID);
		//status= oRS.getString ("Status");
		int lineItem = oRS.getInt("LineItemNbr");
		String upc = oRS.getString("UPC");
		String itemExists = oRS.getString ("ItemExistFlag");
		String moreInfo = oRS.getString("MoreInfoFlag");
		String sapItemNbr = oRS.getString("SAPItemNbr");
		if((sapItemNbr == null)||(sapItemNbr.equals("0"))){
			sapItemNbr = "";
		}
		String manfNbr = oRS.getString("ManufItemNbr");
		String itemDesc = oRS.getString("ItemDescr");
		String manfName = oRS.getString("SupplierName");
		String uom = oRS.getString("UOM");
		String casePack = oRS.getString("CasePack");
		if(casePack == null){
			casePack = "";
		}
		//if(itemExists.equals("Y")){
			//alreadySetup = "Checked='Checked'"; 
		//} else {
			//alreadySetup = "";
		//}
		
 %>
  <tr bgcolor="<%=alternatingColors[j%2]%>" valign="top">
   <td align="center" width ="3%"><%=lineItem%></td>
   <td align="center" width ="3%"><%=itemExists%></td>
   <td align="center" width ="3%"><%=moreInfo%></td>
   <td align="left" width ="10%"><%=upc%></td>
   <td align="left" width ="10%"><%=sapItemNbr%></td>
   <td align="left" width ="10%"><%=manfNbr%></td>
   <td align="left" width ="20%"><%=itemDesc%></td>
   <td align="left" width ="10%"><%=manfName%></td>
   <td align="left" width ="10%"><%=uom%></td>
   <td align="left" width ="5%"><%=casePack%></td>
 <%
 	j++;
	}
%>	
</tr>
</tbody>
</table>
<br>
<table>
 <tbody>
 <tr>
  <td></td>
  <td align="center" style="font-size:15px"><strong>Product Support Item Details:</strong></td>
  <td></td>
 </tr>
  </tbody>
 </table>
 <table width="100%">
  <tbody>
  <tr>
   <th>Line #:</th>
   <th>Possible<br>Item<br>Match:</th>
   <th>Item<br/>Rejected:</th>
   <th>UPC:</th>
   <th>SAP Item #:</th>
   <th>MFG Item #:</th>
   <th>Item Description:</th>
   <th>MFG Name:</th>
   <th>UOM:</th>
   <th>CasePack:</th>
  </tr>
 <%
 
 //oRS = oStmt.executeQuery("Select DISTINCT rd.RequestID,rd.ItemExistFlag, ms.Status, rd.LineItemNbr,rd.UPC,rd.SAPItemNbr,rd.ManufItemNbr,rd.ItemDescr,rd.SupplierName,rd.UOM From dbo.MST_RequestDtl rd JOIN  dbo.MST_Status ms on ms.RequestID = rd.RequestID Where rd.RequestID ="+reqID+" and ms.Status = '"+status+"' Order By rd.LineItemNbr");
 oRS = oStmt.executeQuery("Select rd.LineItemNbr,rd.RejectFlag,rd.PST_UPC,rd.ItemExistFlag,rd.SAPItemNbr,rd.PST_ManufItemNbr,rd.PST_ItemDescr,rd.PST_SupplierName,rd.PST_UOM,rd.PST_CasePack From SAPFMTIPT.dbo.MST_RequestDtl rd where rd.RequestID ="+reqID+" Order By rd.LineItemNbr");
	while (oRS.next()) {
		//reqID = oRS.getString ("RequestID");
		//request.getSession().setAttribute("reqID", reqID);
		//status= oRS.getString ("Status");
		int lineItem = oRS.getInt("LineItemNbr");
		String pstUpc = oRS.getString("PST_UPC");
		if(pstUpc ==null){
			pstUpc = "";
		}
		//System.out.println(pstUpc);
		String itemExists = oRS.getString ("ItemExistFlag");
		
		String rejected = oRS.getString("RejectFlag");
		String sapItemNbr = oRS.getString("SAPItemNbr");
		if((sapItemNbr == null)||(sapItemNbr.equals("0"))){
			sapItemNbr = "";
		}
		//System.out.println(sapItemNbr);
		String pstManfNbr = oRS.getString("PST_ManufItemNbr");
		if(pstManfNbr ==null){
			pstManfNbr = "";
			}	
		//System.out.println(pstManfNbr);
		String pstItemDesc = oRS.getString("PST_ItemDescr");
		if(pstItemDesc ==null){
			pstItemDesc = "";
			}
		//System.out.println(pstItemDesc);
		String pstManfName = oRS.getString("PST_SupplierName");
		if(pstManfName ==null){
			pstManfName = "";
			}
		//System.out.println(pstManfName);
		String pstUom = oRS.getString("PST_UOM");
		if(pstUom ==null){
			pstUom = "";
			}
		//System.out.println(pstUom);
		String pstCasePack = oRS.getString("PST_CasePack");
		if(pstCasePack == null){
			pstCasePack = "";
		}
		//System.out.println(pstCasePack);
		//if(itemExists.equals("Y")){
			//alreadySetup = "Checked='Checked'"; 
		//} else {
			//alreadySetup = "";
		//}
		
 %>
  <tr bgcolor="<%=alternatingColors[j%2]%>" valign="top">
   <td align="center" width ="3%"><%=lineItem%></td>
   <td align="center" width ="3%"><%=itemExists%></td>
   <td align="center" width ="3%"><%=rejected%></td>
   <td align="left" width ="10%"><%=pstUpc%></td>
   <td align="left" width ="10%"><%=sapItemNbr%></td>
   <td align="left" width ="10%"><%=pstManfNbr%></td>
   <td align="left" width ="20%"><%=pstItemDesc%></td>
   <td align="left" width ="10%"><%=pstManfName%></td>
   <td align="left" width ="10%"><%=pstUom%></td>
   <td align="left" width ="5%"><%=pstCasePack%></td>
 <%
 	j++;
	}
%>	


  </tr>
 </tbody>
</table>
            
<%
	}
}

	catch(Exception e) {
	System.out.println("View Request page exception = "+e);
} 
	finally {

			try {
				if(oRS != null)
					oRS.close();
				if(oStmt != null)
					oStmt.close();
				if(oConn != null)
					oConn.close();

				} catch(Exception e) {
					System.out.println("View Request finally/try exception = "+e);
		   	} 

		}

%>

  </form>
  <br />
  <br />
  <br />
</body>
</html>
