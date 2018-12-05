<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">-->
<!--  <html xmlns="http://www.w3.org/1999/xhtml">-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 

<title>NETWORK Material Setup Request</title>
   
<link href="../../NSCMemUtils/web/css/NewItemSetup.css?v=1.0" rel="stylesheet" type="text/css" />
<link href="NewItemSetup.css" rel="stylesheet" type="text/css" />
</head>


<%@ page import ="java.util.*" %>
<%@ page import ="com.nsc.mst.utils.Constants.*" %>
<%@ page import="com.nsc.mst.utils.*, com.nsc.mst.dataaccess.*, com.nsc.mst.*"%>
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

try {
portalUser =  (String)session.getAttribute("PortalUser");
memberID =  (String)session.getAttribute("MemberID");
userEmail = (String)session.getAttribute("UserEmail");
userName = (String)session.getAttribute("UserFullName");
session.setAttribute("userName", portalUser);

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

//System.out.println(memberID);
//System.out.println("This is the Landing Page");
//System.out.println(memberID);
Logger LOGGER = Logger.getLogger(com.nsc.mst.controller.MSTUtils.class);
String var = "./index.jsp?portalUser="+portalUser+"&memberID="+memberID+"&userEmail="+userEmail+"&userName="+userName+"";
%>

<script>

//JS controlling the dual list /combo box functionality.
function SelectMoveRows(SS1,SS2)
{
    var SelID='';
    var SelText='';
    // Move rows from SS1 to SS2 from bottom to top
    for (i=SS1.options.length - 1; i>=0; i--)
    {
        if (SS1.options[i].selected == true)
        {
            SelID=SS1.options[i].value;
            SelText=SS1.options[i].text;
            var newRow = new Option(SelText,SelID);
            SS2.options[SS2.length]=newRow;
            SS1.options[i]=null;
        }
    }
    SelectSort(SS2);
   
}

function SelectMoveRowsAdd(SS1,SS2)
{
    var SelID='';
    var SelText='';
    // Move rows from SS1 to SS2 from bottom to top
    for (i=SS1.options.length - 1; i>=0; i--)
    {
        if (SS1.options[i].selected == true)
        {
            SelID=SS1.options[i].value;           //////////////////////////
            //alert(SelID);                          ///////////Need to grab just the value only and pass that to the servlet SR - 6/30/17
            SelText=SS1.options[i].text;          //////////////////////////
            //alert(SelText);
            var newRow = new Option(SelText,SelID);
            SS2.options[SS2.length]=newRow;
            SS1.options[i]=null;
        }
    }
   
    for (i=SS2.options.length - 1; i>=0; i--){
    	SS2.options[i].selected = true;
    }
    SelectSort(SS1);
}


function SelectSort(SelList)
{
    var ID='';
    var Text='';
    for (x=0; x < SelList.length - 1; x++)
    {
        for (y=x + 1; y < SelList.length; y++)
        {
            if (SelList[x].text > SelList[y].text)
            {
                // Swap rows
                ID=SelList[x].value;
                Text=SelList[x].text;
                SelList[x].value=SelList[y].value;
                SelList[x].text=SelList[y].text;
                SelList[y].value=ID;
                SelList[y].text=Text;
            }
        }
    }
}

//Iterate through the Customers that the user has selected
function GetValues(){
	var x = document.getElementById("corpAcct2"); 
	var optionVal = new Array();
	
	
	for (i = 0; i < x.length; i++) { 
    	optionVal.push(x.options[i].value);      ///////////changed from .text to .value to grab just Customer Major Numbers
		}
	
	//alert(optionVal);
	//alert("new alert " + optionVal);
	document.reqSubmit.acctValues.value = optionVal;
	
}


//Validate a Corporate account has been selected, and a file has been selected for upload.
function ValidateForm(){
	 var browseID = document.reqSubmit.file;
     var corpacctID = document.getElementById("corpAcct2");
     
     if ((corpacctID.value=="")){
  		alert("Please Select a Corporate Account.")
  		corpacctID.focus()
  		return false	
  	 }
	  	 
	 if ((browseID.value==null)||(browseID.value=="")){
		alert("Please Upload A Material Setup Request Form.")
		browseID.focus()
		return false	
	}
	 GetValues();
	 return true		
}

//disables the submit and cancel button when the form has been submitted.
function disableSubmit(){
	document.getElementById('submit').disabled=true;
}

function disableCancel(){
	document.getElementById('myReset').disabled=true;
}

</script>



<body id="wrapper" style="border: 5px solid #4f758b; border-radius: 25px;">
<table width="90%" align="center">

<tbody>
<br />

 <input type="hidden" name="subject"  value="New Material Setup Request" />

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

try{
		String memberName = "";
			
	oRS = oStmt.executeQuery("Select Name3 from SAPFMTIPT.dbo.SAP_Member Where CompanyCode = 2000 and DeleteFlag='N' and HQFlag ='Y' and GeoAppDisplay = 'Y' and MbrMajNbr = '"+memberID+"'");  
	 if (oRS.next())
			{ 
           		memberName = oRS.getString("Name3");
%>   
    
    <h1>Submit Request - <%=memberName%></h1></font></strong></td>
    	    <%}else{
%> 
    <h1>Submit Request</h1></font></strong></td> 
    	  <% } %> 
     <td width="25%">&nbsp;</td>
</tr>
</tbody>
</table>

<br>
<div name="menu" id="menu" align="right">
    <ul>
    <li ><a href="./index.jsp">Home</a></li>
	<li><a href="./myRequests.jsp">My Requests</a></li>
	<li><a href="./completedRequests.jsp">View Completed Requests</a></li>
	<li><a href="http://www.networkdistribution.com/MemberPortal/Operations/MST Tutorial.pdf" target="_blank">User Guide</a></li>
</ul>
</div>
<br>
<form action="UploadServlet" method="post" enctype="multipart/form-data" name="reqSubmit" id="reqSubmit" onSubmit="return (disableSubmit() & disableCancel());" >
<table width="80%">
<input type="hidden" name="acctValues" id="acctValues"/>
<input type="hidden" name="subject" id="subject" value="New Material Setup Request" />
<tbody>
 <br/>
  <tr>
   <td align="left"><strong>New Material Setup Request Form:</strong></td>
   <td style="padding:0px 0px 0px 60px"><input type="button" value="Download" onclick="window.location.href='./MSTTemplate.xlsx'" target="_blank" tabindex="4"/> </td>
   <td></td>
   <td></td>
  </tr>
  <tr>
   <td>&nbsp;</td>
  </tr>
  <tr>
   <td>&nbsp;</td>
  </tr>
 <tr>
 <td width="20%" valign="top"><strong><font color="#4f758b">Name of NETWORK&reg; Corporate Account:</font></strong><br /> <br />Select a NETWORK&reg; customer.<br />Hold Ctrl button to select multiple customers</td>
          <td valign="top"><select multiple name="corpAcct" id="corpAcct" size="8" tabindex="5">
              <option value="0">Not Applicable</option> 
<%			
			String customerID = "";
			String custName = "";
			//System.out.println(memberID);
	if(memberID.equals("001")){		
     oRS = oStmt.executeQuery("Select distinct(cast(a.CustMaj as int)) customerNbr, a.CustMaj, b.CustomerName from sapfmtipt.dbo.sap_customervendor a inner join sapfmtipt.dbo.sap_customer b on a.custmaj = right('0000'+ b.custmajnbr,4)where b.companycode = 2000 and b.custminnbr='000000' and a.vendorType='VN' and a.deleteflag='N' and b.DeleteFlag='N' order by b.CustomerName");  
    		while (oRS.next())
          		{
		     		customerID = oRS.getString("customerNbr");
             		custName = oRS.getString("CustomerName");
%>   
            
   <option value="<%=customerID%>"><%=custName%></option>
<%      		 }
		  } else {
			oRS = oStmt.executeQuery("Select distinct(cast(a.CustMaj as int)) customerNbr, a.CustMaj, b.CustomerName from sapfmtipt.dbo.sap_customervendor a inner join sapfmtipt.dbo.sap_customer b on a.custmaj = right('0000'+ b.custmajnbr,4)where b.companycode = 2000 and b.custminnbr='000000'and a.mbrmaj='"+memberID+"' and a.vendorType='VN' and a.deleteflag='N' and b.DeleteFlag='N' order by b.CustomerName");    
			//oRS = oStmt.executeQuery("Select CustmajNbr, CustomerName From SAPFMTIPT.dbo.SAP_Customer Where CompanyCode = 2000 and DeleteFlag='N' and CustMinNbr = '000000' Order By CustomerName");
    		while (oRS.next())
          		{
		     		customerID = oRS.getString("customerNbr");
             		custName = oRS.getString("CustomerName");
   
%>   
            
   <option value="<%=customerID%>"><%=custName%></option>
<%      		 }
		}
  %>   
             </select><br /><br />
     </td>
  <td align="left" valign="middle">
   <input type="button" value="Add >>" style="width:100px" onClick="SelectMoveRowsAdd(document.reqSubmit.corpAcct,document.reqSubmit.corpAcct2)" tabindex="6"/><br>
   <br>
  <input type="button" value="<< Remove" style="width:100px" onClick="SelectMoveRows(document.reqSubmit.corpAcct2,document.reqSubmit.corpAcct)" tabindex="7"/></td>
  <td><select multiple disabled style="width:250px" name="corpAcct2" id="corpAcct2" size="8"></select></td>
</tr>
  <tr>
<td>&nbsp;</td>
</tr>
 <tr>
   <td width="10%" valign="top"><strong>Form Upload:</strong></td>
   <td width="25%" valign="top"><input type="file" name="file" id="file" tabindex="8"/></td>
   <td width="20%" valign="top"><strong>Add Additional Email Addresses to Receive<br>Notifications Regarding This Request:</strong><br /><br /></td>
   <td width="25%" valign="top"><input type="email" name="addEmail" id="addEmail" size="40" maxlength="50" autocomplete="off" tabindex="10"><br /><br /><br /><input type="email" name="addEmail1" id="addEmail1" size="40" maxlength="50" autocomplete="off" tabindex="11"/></td>    
  </tr>
  <tr>
   <td>&nbsp;</td>
  </tr>
  <tr>
   <td>&nbsp;</td>
  </tr>
  <tr>
   <td valign="top"><strong><font color="#4f758b">Request Notes:<br /></font></strong></td>
   <td valign="top"><textarea class="notes" name="notes" id="notes" rows="8" cols="50" size="100" maxlength="400" tabindex="9"></textarea><br /><br /></td>
   <td></td>
   <td valign="top"><input type="email" name="addEmail2" id="addEmail2" size="40" maxlength="50" autocomplete="off" tabindex="12"/></td> 
  </tr>
  <tr>
   <td>&nbsp;</td>
   </tr>
  <tr>
   <td>&nbsp;</td>
  </tr>
  </tbody>  
 </table> 
<p align="center"><input type="submit" name="submit" id="submit" value="Submit Request" onClick="return ValidateForm()" tabindex="13"/>&nbsp;&nbsp;&nbsp;&nbsp;<input class="reset" name="myReset" id="myReset" type="reset" value="Cancel" onClick="window.location.reload()" tabindex="14"/></p>
<br>
<!--<p align="center"><a href="http://www.networkdistributionqa.com/MemberPortal/Operations/MST Tutorial.pdf" target="_blank" tabindex="15">User Guide</a></p>-->
 <!-- <p align="center"><a href="http://www.networkdistribution.com/MemberPortal/Operations/MST Tutorial.pdf" target="_blank" tabindex="15">User Guide</a></p>-->

 <%    
	}

 		catch(Exception exc) 
{
            //LOGGER.error("MST " + exc.getMessage(), exc);
            System.out.println("This is the Index page Exception = " + exc);
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
                   			System.out.println("MST Index page finally catch exception is = " + exc);
						}
						
			}
%>  
<br />
<br />
 <input type="hidden" name="portalUser" id="portalUser" value="<%=portalUser%>"/>
 <input type="hidden" name="memberID" id="memberID" value="<%=memberID%>"/>
 <input type="hidden" name="userEmail" id="userEmail" value="<%=userEmail%>"/>
 <input type="hidden" name="userName" id="userName" value="<%=userName%>"/>
</form>
</body>
</html>
