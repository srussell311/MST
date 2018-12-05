package com.nsc.mst.FileUpload;

import java.nio.file.Paths;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang3.ArrayUtils;

import java.util.*;
import java.util.Scanner.*;
import java.lang.*;
import java.io.*;
import java.io.File;
import java.sql.*; 
import java.text.*;
import com.nsc.mst.utils.*;
import com.ibm.wsdl.util.StringUtils;
import com.nsc.SSOfilter.*; 
import com.nsc.mst.dataaccess.*; 
import com.nsc.mst.*;
import com.nsc.SSOfilter.*;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.ss.usermodel.DataFormatter;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nsc.mst.controller.MSTWebMain.*;
import com.nsc.mst.dataaccess.*;
import com.nsc.mst.mailservice.*;
import com.nsc.mst.utils.*;
import org.apache.poi.hssf.util.CellReference;
import org.apache.poi.sl.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.NumberToTextConverter;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.struts2.ServletActionContext;
import org.apache.poi.ss.usermodel.*;

import com.nsc.mst.readexcel.*;
import org.apache.commons.fileupload.FileItem;
@WebServlet(urlPatterns={"/UploadServlet"})
@MultipartConfig(fileSizeThreshold=1024*1024*2, // 2MB
                 maxFileSize=1024*1024*10,      // 10MB
                 maxRequestSize=1024*1024*50)   // 50MB

public class UploadServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/**
     * Name of the directory where uploaded files will be saved, relative to
     * the web application directory.
     */
    private static final String SAVE_DIR = "UploadFiles/";
     
    /**
     * handles file upload
     */
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	   //String corpAcct2 = request.getParameter("corpAcct2"); 
	   //System.out.println(corpAcct2);
	   //String portalUser = request.getParameter("portalUser");
	   //String memberID = request.getParameter("memberID");
	  // String userEmail = request.getParameter("userEmail");
	   //String userName = request.getParameter("userName");
	    String itemExistsFlag = "";
	    String requestID = "";
		String acctValues = "";
        String addEmail = "";
        String addEmail1 = "";
    	String addEmail2 = "";
    	String notes = "";
    	String notesDB = "";
    	String subject = "New Material Setup Request ";
    	String corpAcct2 = "";
    	//String custValues = "";
    	String filename = "";
    	String page = "";
    	String emailFrom = "ProductSupportGroup@networkdistribution.com";
    	
    	//String appPath = ("C:/users/srussell/MSTworkspace/MST1/WebContent/");////////////////////////////////////////////////////////////////////////////////////
    	String appPath = ("C:/Program Files/Apache Software Foundation/Tomcat 8.0/webapps/MST1/");                 
    	//System.out.println("App Path - " + appPath);
        // constructs path of the directory to save uploaded file
        String savePath = (appPath + SAVE_DIR);
        //System.out.println("Save Path - " + savePath);
      
        if(ServletFileUpload.isMultipartContent(request)){
        	
            try {
        	 	//This code parses through the multipart form elements on the index.jsp.   
            	List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);     
            	String timeStamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());
            	//this code grabs the file from the input field type="file"
            	
            	for(FileItem item : multiparts){
            		if(!item.isFormField()){     
            			filename = new File(item.getName()).getName();
            			filename = new String("MSTRequestForm" + timeStamp + ".xlsx");
            			//System.out.println("File Name " + filename);
            			//String filename1 = request.getParameter("filename");
            			item.write(new File(savePath + filename));
            			//System.out.println("File writing to path:");
            			//System.out.println(( new File(File.separator + filename)));
            			boolean f = new File("C:/Program Files/Apache Software Foundation/Tomcat 8.0/webapps/MST1/UploadFiles/"+filename).exists(); 
            			//boolean f = new File("C:/Users/srussell/MSTworkspace/MST1/WebContent/UploadFiles/"+filename).exists();//////////////////////////////////////////////////////////
            			//System.out.println(f);
            		} 
            		if (item.isFormField()){
                    // here get value of other parameter which is NOT input type="file
            		//placed variables in session to avoid "request" contention
                            
            				if(item.getFieldName().equalsIgnoreCase("subject")){
            					subject = item.getString();
            					//System.out.println(subject);
            				}
            			    if(item.getFieldName().equalsIgnoreCase("acctValues")){
            			    	acctValues = item.getString();
            			    	//System.out.println(acctValues);
            			    }
            			    if(item.getFieldName().equalsIgnoreCase("addEmail")){
            			    	addEmail = item.getString();
            			    	//System.out.println(addEmail);
            			    }
            			    if(item.getFieldName().equalsIgnoreCase("addEmail1")){
            			    	addEmail1 = item.getString();
            			    	//System.out.println(addEmail1);
            			    }
            			    if(item.getFieldName().equalsIgnoreCase("addEmail2"))
            			    	addEmail2 = item.getString();
            			    	//System.out.println(addEmail2);
            				}
            				if(item.getFieldName().equalsIgnoreCase("notes")){
            					notes = item.getString();
            					notesDB = notes.replaceAll("[-+.^:;&,'!?]","");
            					//System.out.println(notesDB);
            				}
            			}
            		} catch(Exception exc) 
								{
                 			//LOGGER.error("MST " + exc.getMessage(), exc);
                 			System.out.println("This is the Upload Exception" + exc);
								}                     
            			
        HttpSession session = request.getSession(true);
        request.getSession().setAttribute("filename", filename);
        request.getSession().setAttribute("subject", subject);
        request.getSession().setAttribute("corpAcct2", corpAcct2);
        request.getSession().setAttribute("acctValues", acctValues);
        request.getSession().setAttribute("addEmail", addEmail);
        request.getSession().setAttribute("addEmail1", addEmail1);
        request.getSession().setAttribute("addEmail2", addEmail2);
        request.getSession().setAttribute("notesDB", notesDB);
        //System.out.println(acctValues);
       // System.out.println(addEmail);
        //System.out.println(addEmail1);
        //System.out.println(addEmail2);
        //System.out.println(notesDB);
        //System.out.println(filename);
 
        	try {
        		//This code reads the excel file that is uploaded and validates that all required fields have been filled in, else it fails and redirects to the requestFailed.jsp
        		//XSSFWorkbook workbook1 = new XSSFWorkbook(new FileInputStream("C:/users/srussell/MSTworkspace/MST1/WebContent/UploadFiles/"+filename));///////////////////////////////////////////
                XSSFWorkbook workbook1 = new XSSFWorkbook(new FileInputStream("C:/Program Files/Apache Software Foundation/Tomcat 8.0/webapps/MST1/UploadFiles/"+filename));
        		XSSFSheet sheet1 = workbook1.getSheetAt(0);
        		Iterator<?> rows = sheet1.rowIterator();
        		int parseCount = 0;
        		DataFormatter df = new DataFormatter();
        		
        		while (rows.hasNext()) {
        			XSSFRow row1 = (XSSFRow) rows.next();
        			//System.out.println(row1);
        			Cell cell0 = row1.getCell(0, Row.CREATE_NULL_AS_BLANK);
        			//System.out.println(cell0);
        			Cell cell2 = row1.getCell(2, Row.CREATE_NULL_AS_BLANK);
        			//System.out.println(cell2);
        			Cell cell3 = row1.getCell(3, Row.CREATE_NULL_AS_BLANK);
        			//System.out.println(cell3);
        			Cell cell4 = row1.getCell(4, Row.CREATE_NULL_AS_BLANK);
        			//System.out.println(cell4);
        			Cell cell5 = row1.getCell(5, Row.CREATE_NULL_AS_BLANK);
        			//System.out.println(cell5);
        			Cell cell6 = row1.getCell(6, Row.CREATE_NULL_AS_BLANK);
        			//System.out.println(cell6);
        			Cell cell7 = row1.getCell(7, Row.CREATE_NULL_AS_BLANK);
        			//System.out.println(cell7);
        			//System.out.println(parseCount);
        			
        			if(row1.getRowNum()==0 || row1.getRowNum()==1 || row1.getRowNum()==2){
        				continue;
        			}
        			if(row1.getCell(0).toString() != ""){//(row1.getCell(0).getCellType() == XSSFCell.CELL_TYPE_STRING){
     	 			//System.out.println(row1.getCell(0).getStringCellValue());
        			String manfName = df.formatCellValue(row1.getCell(0));
     	 			//System.out.println(manfName);
        			}
        				else if ((row1.getCell(0).toString().equals("")) & (parseCount==0) || (row1.getCell(0) == cell0) & (parseCount == 0)){//(row1.getCell(0).getCellType() == XSSFCell.CELL_TYPE_BLANK & parseCount == 0 || row1.getCell(0) == cell0 & parseCount == 0 ){
        					request.getRequestDispatcher("./requestFailed.jsp").forward(request, response);
        					return;
        				}
        				else if ((row1.getCell(0).toString().equals("")) & (parseCount > 0) || (row1.getCell(0) == cell0) & (parseCount > 0)){//(row1.getCell(0).getCellType() == XSSFCell.CELL_TYPE_BLANK & parseCount > 0 || row1.getCell(0) == cell0 & parseCount > 0){
        					if ((row1.getCell(2).toString().equals("")) & 
        						(row1.getCell(3).toString().equals("")) & 
        						(row1.getCell(4).toString().equals("")) &
        						(row1.getCell(5).toString().equals("")) &
        						(row1.getCell(6).toString().equals("")) &
        						(row1.getCell(7).toString().equals(""))){
        						break;
        					}else{
        						request.getRequestDispatcher("./requestFailed.jsp").forward(request, response);
        						return;
        					}
        							
        				}
        			//if(row1.getCell(2).getCellType() == XSSFCell.CELL_TYPE_STRING){
     				//System.out.println(row1.getCell(2).getStringCellValue());	
        			//}
        			if(row1.getCell(2).toString() != ""){
            			//(row1.getCell(7).getCellType() == XSSFCell.CELL_TYPE_STRING){
            				String manfItemNbr = df.formatCellValue(row1.getCell(2));
             				//System.out.println(row1.getCell(7).getStringCellValue());	
            				System.out.println(manfItemNbr);
                		}
        				else if (row1.getCell(2).getCellType() == XSSFCell.CELL_TYPE_BLANK & parseCount >= 0 || row1.getCell(2) == cell2 & parseCount >= 0){
        					request.getRequestDispatcher("./requestFailed.jsp").forward(request, response);
        					return;
    					}
        			if(row1.getCell(3).toString() != ""){//(row1.getCell(3).getCellType() == XSSFCell.CELL_TYPE_STRING){
     				//System.out.println(row1.getCell(3).getStringCellValue());
        				String fullDesc = df.formatCellValue(row1.getCell(3));
        				System.out.println(fullDesc);
        			}
        				else if(row1.getCell(3).getCellType() == XSSFCell.CELL_TYPE_BLANK & parseCount >= 0 || row1.getCell(3) == cell3 & parseCount >= 0){
        					request.getRequestDispatcher("./requestFailed.jsp").forward(request, response);
        					return;
    					}
        			if(row1.getCell(4).toString() != ""){//(row1.getCell(4).getCellType() == XSSFCell.CELL_TYPE_STRING){
         				//System.out.println(row1.getCell(4).getStringCellValue());	
        				String custBrand = df.formatCellValue(row1.getCell(4));
        				System.out.println(custBrand);
            		}
        				else if (row1.getCell(4).getCellType() == XSSFCell.CELL_TYPE_BLANK & parseCount >= 0 || row1.getCell(4) == cell4 & parseCount >= 0){
        					request.getRequestDispatcher("./requestFailed.jsp").forward(request, response);
        					return;
    					}
        			if(row1.getCell(5).toString() != ""){//(row1.getCell(5).getCellType() == XSSFCell.CELL_TYPE_STRING){
         				//System.out.println(row1.getCell(5).getStringCellValue());
        				String memPrivate = df.formatCellValue(row1.getCell(5));
        				System.out.println(memPrivate);
            		}
        				else if (row1.getCell(5).getCellType() == XSSFCell.CELL_TYPE_BLANK & parseCount >= 0 || row1.getCell(5) == cell5 & parseCount >= 0){
        					request.getRequestDispatcher("./requestFailed.jsp").forward(request, response);
        					return;
    					}
        			if(row1.getCell(6).toString() != ""){//(row1.getCell(6).getCellType() == XSSFCell.CELL_TYPE_STRING){
         				//System.out.println(row1.getCell(6).getStringCellValue());
         				String suom = df.formatCellValue(row1.getCell(6));
        				System.out.println(suom);
            		}
        				else if (row1.getCell(6).getCellType() == XSSFCell.CELL_TYPE_BLANK & parseCount >= 0 || row1.getCell(6) == cell6 & parseCount >= 0){
        					request.getRequestDispatcher("./requestFailed.jsp").forward(request, response);
        					return;
    					}
        			
        	        /////////////////////////This code section checks to make sure that the UOM field only contains numeric values.////////////////////////
        			String alphaNum = df.formatCellValue(cell7);
        			//String string = "12345.15";
        	        boolean numeric = true;

        	        try {
        	            Double num = Double.parseDouble(alphaNum);
        	        } catch (NumberFormatException e) {
        	            numeric = false;
        	        }

        			df.formatCellValue(cell7);

        			if(numeric == true){//(!row1.getCell(7).toString().contains("[A-Za-z]+")){//("^([A-Za-z]|[0-9])+$")){  //row1.getCell(7).toString() != "" & 
        								//(row1.getCell(7).getCellType() == XSSFCell.CELL_TYPE_STRING){
        				String casePackUom = df.formatCellValue(row1.getCell(7));
         				//System.out.println(row1.getCell(7).getStringCellValue());	
        				System.out.println(casePackUom);
            		}
        				else if (numeric == false){//(row1.getCell(7).getCellType() == XSSFCell.CELL_TYPE_BLANK & parseCount >= 0 || row1.getCell(7) == cell7 & parseCount >= 0){
        					request.getRequestDispatcher("./requestFailed.jsp").forward(request, response);
        					return;
    					}
        			
     				parseCount++;   
        			workbook1.close();
     	    
     	    		}
        		
        	}  catch(Exception exc){
        				//LOGGER.error("MST " + exc.getMessage(), exc);
        				System.out.println("This is the MST Exception SPR = " + exc);
        				request.getRequestDispatcher("./requestFailed.jsp").forward(request, response);
        				return;
	 		 	   } 
        	// Comment   
         String portalUser = "";    ///////Fill this in when testing locally!
         String memberID = "";
         String userEmail = "";
         String userName = "";

        try {
            	portalUser =  (String)session.getAttribute("PortalUser");
            	memberID =  (String)session.getAttribute("MemberID");  
            	userEmail = (String)session.getAttribute("UserEmail");      ////Comment try statement out when testing locally
            	userName = (String)session.getAttribute("UserFullName");
            	session.setAttribute("userName", portalUser);

            	} catch (Exception ex) {
            	 	     ex.printStackTrace();
            	  }
            	 	

        System.out.println("SPR-portalUser =  " + portalUser );
        System.out.println("SPR-memberID =  " + memberID );
        System.out.println("SPR-userEmail =  " + userEmail );
        System.out.println("SPR-userName =  " + userName );
        
        memberID = String.format("%03d", Integer.parseInt(memberID));/////////////////////////////////////////////////////////////////
        //int member = Integer.parseInt(memberID); ///This value is not used!!!!!!
        //System.out.println(memberID);
        
        String custValues = acctValues.replaceAll("\\D+",",");
       // System.out.println(custValues);
        custValues = custValues.startsWith(",") ? custValues.substring(1) : custValues;
        //System.out.println(custValues);
        custValues = custValues.replaceAll(",$", "");
       // System.out.println(custValues);
        
        int assigned = 0;
        String status = "Submitted";
        String velvet= "";
        
        Connection oConn = null;
        Statement oStmt =null;
        ResultSet oRS = null;
        oStmt = null;
        
        Statement oStmt1 =null;
        ResultSet oRS1 = null;
        oStmt1 = null;
        
        Statement oStmt2 =null;
        ResultSet oRS2 = null;
        oStmt2 = null;
        
    
              
            	 	 //Check the Valid flag and the Already Setup flag to check boxes if line item required fields are not filled out or the item is already setup 
            	 	 
            try {
                         	
            	oConn = ConnectionFactory.getInstance().getConnection(Constants.SAPFMTIPT_DATASOURCE);
            	oStmt = oConn.createStatement();
            	velvet = "N";
            	int custID = 0;
            		//This code checks if the request is for a customer that requires product enrichment, and changes the velvet variable to Y if it does.
            		//System.out.println("This is right before the velvet flag SQL query.");
            	 	//String sql = "Select COUNT (*) AS VelvetCust FROM SAPFMTIPT.dbo.MST_Customer_CrossRef Where CustMajNbr IN ("+custValues+")";
            	 	//System.out.println(sql);
            	 	oRS = oStmt.executeQuery("Select COUNT (*) AS VelvetCust FROM SAPFMTIPT.dbo.MST_Customer_CrossRef Where CustMajNbr IN ("+custValues+")");
            	 	 	while (oRS.next()){
            	 	 		custID = oRS.getInt("VelvetCust");  
            	 	 		//System.out.println(custID);
            	 	 		if (custID > 0) {
            	 	 					velvet = "Y";
            	 	 		}
            	 	 	}
            	 	 	
            	 	//System.out.println("custID = " + custID);
            	 	//SQL Query to write the request to the MST_Request table
            	 	oStmt.executeUpdate("Insert INTO SAPFMTIPT.dbo.MST_Request (RequestDate, Requestor, RequestorEmail, MemberNbr, CustomerNbr, CCEmail, Status, AssignedTo, VelvetCustomer, Filename, CCEmail1, CCEmail2, Comments) VALUES (GetDate(),'"+userName+"','"+userEmail+"','"+memberID+"','"+custValues+"','"+addEmail+"','"+status+"','"+assigned+"','"+velvet+"','"+filename+"','"+addEmail1+"','"+addEmail2+"','"+notesDB+"')");				
            	 	//SQL query to pull Request ID to be included in email
            	 	 	oRS = oStmt.executeQuery("SELECT MAX (RequestID) AS MaxRequest FROM SAPFMTIPT.dbo.MST_Request Where RequestorEmail = '"+userEmail+"' and Requestor = '"+userName+"'");
            	 	 			while(oRS.next()){
            	 	 			requestID = oRS.getString("MaxRequest");
            	 	 			request.getSession().setAttribute("requestID", requestID);
            	 	 			//System.out.println(requestID);
            	 	 			}
            	 //This code parses through the uploaded excel file and INSERTS it into the MST_RequestDtlImport table temporarily.	 			
            	 //XSSFWorkbook workbook1 = new XSSFWorkbook(new FileInputStream("C:/users/srussell/MSTworkspace/MST1/WebContent/UploadFiles/"+filename));////////////////////////////////////////
            	 XSSFWorkbook workbook1 = new XSSFWorkbook(new FileInputStream("C:/Program Files/Apache Software Foundation/Tomcat 8.0/webapps/MST1/UploadFiles/"+filename));
            	 XSSFSheet sheet1 = workbook1.getSheetAt(0);
            	 Iterator<?> rows = sheet1.rowIterator();
            	 String manfName = "";
	 	     	 String manfNbr = "" ;
	 	     	 String fullDesc = "";
	 	     	 String upc = "";
	 	     	 String brandName = "";
	 	     	 String memLabel = "";
	 	     	 String custBrand = "";
	 	     	 String suom = "";
	 	     	 String casePack = "";
	 	     	 //String manfNumb = "";
	 	     	 DataFormatter df = new DataFormatter();
	 	     	 //int parseCount = 0;   	
            	 	    while (rows.hasNext()) {
            	 	    	XSSFRow row1 = (XSSFRow) rows.next();
            	 	    	Cell cell = row1.getCell(1, Row.CREATE_NULL_AS_BLANK);
            	 	    	Cell cell0 = row1.getCell(0, Row.CREATE_NULL_AS_BLANK);
                			Cell cell2 = row1.getCell(2, Row.CREATE_NULL_AS_BLANK);
                			Cell cell3 = row1.getCell(3, Row.CREATE_NULL_AS_BLANK);
                			Cell cell4 = row1.getCell(4, Row.CREATE_NULL_AS_BLANK);
                			Cell cell5 = row1.getCell(5, Row.CREATE_NULL_AS_BLANK);
                			Cell cell6 = row1.getCell(6, Row.CREATE_NULL_AS_BLANK);
                			Cell cell7 = row1.getCell(7, Row.CREATE_NULL_AS_BLANK);
            	 	    	//System.out.println(parseCount);
            	 	     	    	
            	 	     		if(row1.getRowNum()==0 || row1.getRowNum()==1 || row1.getRowNum()==2){
            	 	     	        	 continue;
            	 	     	    }
            	 	    		//if((row1.getCell(0).toString().equals(null)) || (row1.getCell(0).toString().equals("")) || (row1.getCell(0) == cell0)){
         	 	     	 			//break;
         	 	     	 		//}
            	 	     	    if(row1.getCell(0).toString() != ""){//(row1.getCell(0).getCellType() == XSSFCell.CELL_TYPE_STRING){
            	 	     	 		//System.out.println(row1.getCell(0).getStringCellValue());
            	 	     	 		//manfName = row1.getCell(0).toString();
            	 	     	    	manfName = df.formatCellValue(row1.getCell(0));
            	 	     	 		//System.out.println(manfName);
            	 	     	 	}else {
            	 	     	 		break;
            	 	     	 	}
            	 	     	    if (cell == null){
            	 	     	    	continue;
            	 	     	    }
            	 	     	    if(row1.getCell(1).toString() == null){
            	 	     	    	//upc = "";
            	 	     	    	upc = df.formatCellValue(row1.getCell(1));
            	 	     	    	//System.out.println(upc);
              	 	     	    }
            	 	     	    if(row1.getCell(1).getCellType() == XSSFCell.CELL_TYPE_BLANK){
            	 	     	    	upc = "";
          	 	     	    	upc = df.formatCellValue(row1.getCell(1));
            	 	     	    	System.out.println(upc);
            	 	     	    }
            	 	     	    if(row1.getCell(1).toString() != ""){
            	 	     	    	upc = df.formatCellValue(row1.getCell(1));
            	 	     	    	//upc = String.format("%014d", upc);			//////////added 10/12/17//////////////
            	 	     	    	//upc = ("00000000000000" + upc).substring(upc.length());
                	 	     	    //System.out.println(upc);
            	 	     	    }
            	 	     	    if(row1.getCell(2).toString() != null){
            	 	     	    	manfNbr = df.formatCellValue(row1.getCell(2));
            	 	     			//System.out.println(manfNbr);
            	 	     				
            	 	     	    }
            	 	     	    if(row1.getCell(3).toString() != ""){//(row1.getCell(3).getCellType() == XSSFCell.CELL_TYPE_STRING){
          	 	     	 			//System.out.println(row1.getCell(3).getStringCellValue());
          	 	     	 			//fullDesc = row1.getCell(3).toString();
            	 	     	    	fullDesc = df.formatCellValue(row1.getCell(3));
          	 	     	 			//System.out.println(fullDesc);
            	 	     	    }
            	 	     	    if(row1.getCell(4).toString() != ""){//(row1.getCell(4).getCellType() == XSSFCell.CELL_TYPE_STRING){
            	 	     	    	//System.out.println(row1.getCell(4).getStringCellValue());
            	 	     	    	//custBrand = row1.getCell(4).toString();
            	 	     	    	custBrand =  df.formatCellValue(row1.getCell(4));
            	 	     	    	//System.out.println(custBrand);
            	 	     	    }
            	 	     	    if(row1.getCell(5).toString() != ""){//(row1.getCell(5).getCellType() == XSSFCell.CELL_TYPE_STRING){
            	 	     	    	//System.out.println(row1.getCell(5).getStringCellValue());
            	 	     	    	//memLabel = row1.getCell(5).toString();
            	 	     	    	memLabel = df.formatCellValue(row1.getCell(5));
            	 	     	    	//System.out.println(memLabel);
        	 	     	    	}
            	 	     	    if(row1.getCell(6).toString() != ""){//(row1.getCell(6).getCellType() == XSSFCell.CELL_TYPE_STRING){
          	 	     	    		//System.out.println(row1.getCell(6).getStringCellValue());
          	 	     	    		//suom = row1.getCell(6).toString();
            	 	     	    	suom = df.formatCellValue(row1.getCell(6));
          	 	     	    		//System.out.println(suom);
      	 	     	    		}
            	 	     	    if(row1.getCell(7).toString() != ""){
            	 	     	    	casePack = df.formatCellValue(row1.getCell(7));
            	 	     	    	//System.out.println(row1.getCell(9).getStringCellValue());
            	 	     	    	//casePack = row1.getCell(9).toString();
          	 	     	    		//System.out.println(casePack);
            	 	     	    }
            	 	     	    
            	 	     	    //parseCount++;
            	 	     	    String manfNameDB = manfName.replaceAll("[-+.^:;,%#!?'/]","");
          	 	     	        //System.out.println(manfNameDB);
            	 	     	    String upcDB = upc.replaceAll("[-+.^:;&,%#!?'/]","");
            	 	     	   // System.out.println(upcDB);
            	 	     	    if(upcDB != ""){
            	 	     	    upcDB = ("00000000000000" + upc).substring(upc.length());
            	 	     	    //System.out.println(upcDB);
            	 	     	    }
            	 	     	    String manfNbrDB = manfNbr.replaceAll("'","");
            	 	     	    //System.out.println(manfNbrDB);
            	 	     	    String fullDescDB = fullDesc.replaceAll("[']","");
            	 	     	    //System.out.println(fullDescDB);
            	 	     	    String custBrandDB = custBrand.replaceAll("[-+.^:;&,%#!?'/]","");
            	 	     	    //System.out.println(custBrandDB);
            	 	     	    String memLabelDB = memLabel.replaceAll("[-+.^:;&,%#!?'/]","");
            	 	     	    //System.out.println(memLabelDB);
            	 	     	    String suomDB = suom.replaceAll("[-+.^:;&,%#!?'/]","");
            	 	     	   // System.out.println(suomDB);
            	 	     	    String casePackDB = casePack.replaceAll("[-+.^:;&,%#!?'/]","");
            	 	     	    //System.out.println(casePackDB);
            	 	     	   
            	 	     	
            	 	     	    //Inserts data from the uploaded excel file into the MST_RequestDtlImport table on each iteration.
            	 	     	 //String sql = "INSERT INTO SAPFMTIPT.dbo.MST_RequestDtlImport (ImportReqID,Requestor,MemberNbr,UPC,ItemDescr,ManufItemNbr,UOM,SupplierName,CasePack,ValidFlag) Values ("+requestID+",'"+userName+"',"+memberID+",'"+upc+"','"+fullDescDB+"','"+manfNbrDB+"','"+suom+"','"+manfNameDB+"','"+casePackDB+"','Y' )";
            	 	     	    	//System.out.println(sql);
            	 	  oStmt.executeUpdate("INSERT INTO SAPFMTIPT.dbo.MST_RequestDtlImport (ImportReqID,Requestor,MemberNbr,UPC,ItemDescr,ManufItemNbr,UOM,SupplierName,CasePack,ValidFlag) Values ("+requestID+",'"+userName+"',"+memberID+",'"+upcDB+"','"+fullDescDB+"','"+manfNbrDB+"','"+suom+"','"+manfNameDB+"','"+casePackDB+"','Y' )");
            	 	     	 		    
            	 	     	    workbook1.close();
            	 	     	    
            	 	     }
            	 	    //Selects everything from the MST_RequestDtlImport table and INSERTS it into the MST_RequestDtl table.
            	   //String sql = "INSERT INTO SAPFMTIPT.dbo.MST_RequestDtl (RequestID,UPC,ItemDescr,ManufItemNbr,UOM,SupplierName,CasePack,ModifiedDate,LineItemNbr) SELECT ImportReqID, UPC, ItemDescr, ManufItemNbr,UOM, SupplierName,CasePack, GetDate(), row_number() over (order by (select NULL)) From SAPFMTIPT.dbo.MST_RequestDtlImport Where ImportReqID = "+requestID+" and Requestor='"+userName+"' and MemberNbr="+memberID+"";
            	 	  	//System.out.println(sql);
            oStmt.executeUpdate("INSERT INTO SAPFMTIPT.dbo.MST_RequestDtl (RequestID,UPC,ItemDescr,ManufItemNbr,UOM,SupplierName,CasePack,ModifiedDate,LineItemNbr) SELECT ImportReqID, UPC, ItemDescr, ManufItemNbr,UOM, SupplierName,CasePack, GetDate(), row_number() over (order by (select NULL)) From SAPFMTIPT.dbo.MST_RequestDtlImport Where ImportReqID = "+requestID+" and Requestor='"+userName+"' and MemberNbr="+memberID+"");  	     	    
            	 	 
            	 	   //Query against dbo.SAP_Item, UPC first else Manf. item number, Manf. Name, and Case pack  table based on requestID. Do a count first, if the count is > 1 grab all of the item details for the that UPC. Else 
            	 	   
            	 	//This SQL checks for existing items against the SAP_Item and SAP_Supplier Tables           	 	     	    
            	 	String supplierName = "";
           			String manfItem = "";
           			int itemCount = 0;
           			itemExistsFlag = "N";
           			oConn = ConnectionFactory.getInstance().getConnection(Constants.SAPFMTIPT_DATASOURCE);
                	oStmt = oConn.createStatement();
                	
                	
                	
                	
             ////////////NEW SQL validation code section///////////////////
             ///////////Check UPC first, then check Manf. Item Number, Manf. Name, Case Pack.
                	int upcCount = 0;
                	String upC = "";
                	
                	System.out.println("Connection 1");
                	//oStmt1 = null;
                    oRS1 = null;
                    oStmt1 = oConn.createStatement();
                    System.out.println("Connection 2");
                    //oStmt2 = null;
                	//oRS2 = null;
                	oStmt2 = oConn.createStatement();
                	        	
                	oRS = oStmt.executeQuery("Select COUNT (*) Total From MST_RequestDtl Where RequestID = "+requestID+" and UPC != ''");
                			if(oRS.next()){
                				upC = oRS.getString("Total");
                				
                			}
                			upcCount = Integer.parseInt(upC);
                			
                	if(upcCount > 0){
                		////Trying a new code by padding UPC with 0's added 10/12/17 ///oRS = oStmt.executeQuery("Select si.UPC from SAPFMTIPT.dbo.MST_RequestDtl md JOIN SAPFMTIPT.dbo.SAP_Item si on si.UPC = md.UPC Where CompanyCode=2000 and DeleteFlag='N' and RequestID = "+requestID+"");
                		oRS = oStmt.executeQuery("Select RIGHT('00000000000000' +  rtrim(si.UPC) ,14) as UPC from SAPFMTIPT.dbo.MST_RequestDtl md JOIN SAPFMTIPT.dbo.SAP_Item si on right('00000000000000' +  rtrim(si.UPC) ,14) = right('00000000000000' +  rtrim(md.UPC) ,14) Where CompanyCode=2000 and DeleteFlag='N' and RequestID = "+requestID+"");
  							while(oRS.next()){
  								
  								itemExistsFlag = "Y";
  								//System.out.println("Inside the UPC exists query");
  								//sql = "UPDATE MST_RequestDtl SET ItemExistFlag = '"+itemExistsFlag+"' From SAPFMTIPT.dbo.MST_RequestDtl md JOIN SAPFMTIPT.dbo.SAP_Item si on si.UPC = md.UPC Where si.UPC = md.UPC and md.RequestID ="+requestID+"";
  								//System.out.println(sql);
  								
  								oStmt1.executeUpdate("UPDATE MST_RequestDtl SET ItemExistFlag = '"+itemExistsFlag+"' From SAPFMTIPT.dbo.MST_RequestDtl md JOIN SAPFMTIPT.dbo.SAP_Item si on right('00000000000000' +  rtrim(si.UPC) ,14) = right('00000000000000' +  rtrim(md.UPC) ,14) Where md.RequestID ="+requestID+"");
  							}
                		
                	} 
                	
                	//System.out.println("Right after UPC Update");
                		  // sql = "Select si.CasePack, si.ManufItemNbr From SAPFMTIPT.dbo.MST_RequestDtl md JOIN SAPFMTIPT.dbo.SAP_Item si on si.ManufItemNbr = md.ManufItemNbr Where CompanyCode=2000 and DeleteFlag='N' and md.CasePack = si.CasePack and md.RequestID = "+requestID+")";
                			//System.out.println(sql);
                		
                		////SQL Query checks for ManfItemNbr and CasePack exists on the submitted request agains the SAP_Item table.
                	
                	
                	//////////////////////////Changes made 10/24/2017
                	String setupCounter = "";
                	int setCounter = 0;
                	
                	
                	//System.out.println("Right before the MAnfItemNbr validation");
                	//int x = 1;
                		oRS = oStmt.executeQuery("Select CasePack, ManufItemNbr, LineItemNbr From SAPFMTIPT.dbo.MST_RequestDtl  Where RequestID = "+requestID+"");
                			while(oRS.next()){
                				String csPack = oRS.getString("CasePack");
                				String mItemNum = oRS.getString("ManufItemNbr");
                				String line = oRS.getString("LineItemNbr");
                				itemExistsFlag =  "Y";
                				//System.out.println("In the first query for casepack and manfitemnbr");
                				
                				oRS1 = oStmt1.executeQuery("Select COUNT (*) as Total From SAP_Item Where CasePack ='"+csPack+"' and ManufItemNbr = '"+mItemNum+"' and CompanyCode = '2000' and DeleteFlag = 'N'");
                					while(oRS1.next()){
                						setupCounter = oRS1.getString("Total");
                						//System.out.println("In the SAP_item subbquery");
                						}
                					setCounter = Integer.parseInt(setupCounter);
                					

                					if(setCounter > 0){
                						
                						//oStmt.executeUpdate("UPDATE MST_RequestDtl SET ItemExistFlag = '"+itemExistsFlag+"' From SAPFMTIPT.dbo.MST_RequestDtl md JOIN SAPFMTIPT.dbo.SAP_Item si on si.ManufItemNbr = md.ManufItemNbr Where si.CasePack = md.CasePack and md.RequestID = "+requestID+"");
                						oStmt2.executeUpdate("UPDATE MST_RequestDtl SET ItemExistFlag = '"+itemExistsFlag+"' From SAPFMTIPT.dbo.MST_RequestDtl Where RequestID = "+requestID+" and LineItemNbr = "+line+"");
                						//System.out.println("In the Update item exists flag query");
                						}
                					//x++;
                			}
                		
                		////////////////Change made in this code block 10/24/2017
                	
                	
                	
                ////////////END OF NEW SQL validation code section///////////////////	
                	
                	
                	
                	
                	
                	
                	
          						//System.out.println(itemExistsFlag);
          						//System.out.println(requestID);
          			//SQL to update the MST_Status table			
          		
          			 oStmt.executeUpdate("INSERT INTO SAPFMTIPT.dbo.MST_Status (RequestID, Status, StatusDate, ModifiedBy) Values ("+requestID+",'"+status+"', GetDate(),'Unassigned')");
          			//SQL to update the MST_RequestComm table to keep track of email communications 
          			// sql = "INSERT INTO SAPFMTIPT.dbo.MST_RequestComm (RequestID, EmailTo, EmailFrom, DateSent, EmailComments) Values("+requestID+",'"+userEmail+"','"+emailFrom+"', GetDate(),'"+notesDB+"')";
          			// System.out.println(sql);
          			oStmt.executeUpdate("INSERT INTO SAPFMTIPT.dbo.MST_RequestComm (RequestID,EmailText, EmailTo, EmailFrom, DateSent, EmailComments) Values("+requestID+",'Request Submitted Successfully','"+userEmail+"','"+emailFrom+"',GetDate(),'"+notesDB+"')");
          			//SQL to Delete request info from MST_RequestDtlImport Table after it has been validated against SAP_ITEM and SAP_Supplier tables.
          			oStmt.executeUpdate("DELETE FROM dbo.MST_RequestDtlImport Where ImportReqID = "+requestID+"");
          
          			///Query for the Distributors name to be included in the confirmation email.		
          String memberName = "";			
          oRS = oStmt.executeQuery("Select Name3 from SAPFMTIPT.dbo.SAP_Member Where CompanyCode = 2000 and DeleteFlag='N' and HQFlag ='Y' and GeoAppDisplay = 'Y' and MbrMajNbr = '"+memberID+"'");  
          	if (oRS.next()){ 
          		   memberName = oRS.getString("Name3");
          		}
          ///query for the Corporate Account names to be included in the confirmation email.	
          String customerID = "";
          String customer = "";
          String cust = "";	
         oRS=oStmt.executeQuery("Select CustMajNbr, CustomerName From SAPFMTIPT.dbo.SAP_Customer Where CustMajNbr IN ("+custValues+") and CompanyCode = '2000' and CustMinNbr = 000000 order by CustomerName");
    		while(oRS.next()){
    			customerID = oRS.getString("CustMajNbr");
    			customer = oRS.getString("CustomerName");
    			cust = cust + customerID + " - " + customer + ", ";
    			//System.out.println(customer);
    			//System.out.println(cust);
    		}
    		
    		cust = cust.replaceAll(", $", "");
          						
        //request.getSession().setAttribute("itemExistsFlag", itemExistsFlag);  					
        String requestor = "ProductSupportGroup@networkdistribution.com";
       // String recipient = "srussell@networkdistribution.com";
       // String recipient1 = "srussell@networkdistribution.com";
        String EmailAddr1 = "ProductSupportGroup@networkdistribution.com";
        //String EmailAddr1 = "ProductSupportGroup@networkdistribution.com";
        subject = subject + "- RequestID #"+requestID;
        String title;
        String redirect;
        String required;
        String sort;
        String print_config;
        String env_report = request.getParameter("env_report");
        String print_blank_fields;
        
       // System.out.println(addEmail);
       // System.out.println(addEmail1);
        //System.out.println(addEmail2);

            sendEmailNotification email = new sendEmailNotification();
            	 	 	            	
            	 	 //send email to user submitting New Material Setup 			
            	 	 								
            	 	    email.sendIt("New Material Setup Request Has Been Received\n" 
            	 	    +"\n You will be notified of updates to your New Material Setup Request via email.  If you have any questions regarding your request please reply to this email.\n"
            	 	    +"\n Request ID: " +requestID
            	 	    +"\n\n Requester's Name: " +userName
            	 	    +"\n\n Requester's Email Address: "+userEmail
            	 	    +"\n\n Additional Email Address: "+addEmail
            	 	    +"\n\n Additional Email Address: "+addEmail1
            	 	    +"\n Additional Email Address: "+addEmail2
            	 	    //+"\n\n Distributor: "+memberName
            	 	    +"\n\n Corporate Account(s): "+cust
            	 	    +"\n\n Notes: "+notes+"",
            	 	      	userEmail,
            	 	    	subject,
            	 	        requestor);

            	 	 //send email to additional email address on the New Material Setup Request		
            	 	 	if(!addEmail.equals("")){	
            	 	 		email.sendIt("New Material Setup Request Has Been Received\n" 
            	 	    +"\n You will be notified of updates to your New Material Setup Request via email.  If you have any questions regarding your request please reply to this email.\n"
            	 	    +"\n Request ID: " +requestID
            	 	    +"\n\n Requester's Name: " +userName
            	 	    +"\n\n Requester's Email Address: "+userEmail
            	 	    +"\n\n Additional Email Address: "+addEmail
            	 	    +"\n\n Additional Email Address: "+addEmail1
            	 	    +"\n\n Additional Email Address: "+addEmail2
            	 	    +"\n\n Distributor: "+memberName
            	 	    +"\n\n Corporate Account(s): "+cust
            	 	    +"\n\n Notes: "+notes+"",
            	 	      	addEmail,
            	 	    	subject,
            	 	        requestor);
            	 	 	} else{
            	 	 		
            	 	 	}
            	 	 	
            	 	 	//send email to additional email address on the New Material Setup Request		
            	 	 		if(!addEmail1.equals("")){
            	 	 		email.sendIt("New Material Setup Request Has Been Received\n" 
            	 	 	+"\n You will be notified of updates to your New Material Setup Request via email.  If you have any questions regarding your request please reply to this email.\n"
            	 	 	+"\n Request ID: " +requestID
            	 	 	+"\n\n Requester's Name: " +userName
            	 	 	+"\n\n Requester's Email Address: "+userEmail
            	 	 	+"\n\n Additional Email Address: "+addEmail
            	 	 	+"\n\n Additional Email Address: "+addEmail1
            	 	 	+"\n\n Additional Email Address: "+addEmail2
            	 	 	+"\n\n Distributor: "+memberName
            	 	 	+"\n\n Corporate Account(s): "+cust
            	 	 	+"\n\n Notes: "+notes+"",
            	 	 		addEmail1,
            	 	 		subject,
            	 	 		requestor);
            	 	 		} else {
            	 	 			
            	 	 		}
            	 	 				//send email to additional email address on the New Material Setup Request		
            	 	 		if(!addEmail2.equals("")){		
            	 	 		email.sendIt("New Material Setup Request Has Been Received\n" 
            	 	 	+"\n You will be notified of updates to your New Material Setup Request via email.  If you have any questions regarding your request please reply to this email.\n"
            	 	 	+"\n Request ID: " +requestID
            	 	 	+"\n\n Requester's Name: " +userName
            	 	 	+"\n\n Requester's Email Address: "+userEmail
            	 	 	+"\n\n Additional Email Address: "+addEmail
            	 	 	+"\n\n Additional Email Address: "+addEmail1
            	 	 	+"\n\n Additional Email Address: "+addEmail2
            	 	 	+"\n\n Distributor: "+memberName
            	 	 	+"\n\n Corporate Account(s): "+cust
            	 	 	+"\n\n Notes: "+notes+"",
            	 	 		addEmail2,
            	 	 		subject,
            	 	 		requestor);
            	 	 		} else {
            	 	 			
            	 	 		}
            	 	 	//email sent to Product Support Group	
            	 	 		
            	 	 		//email to Sean during testing
            	 	 		email.sendIt("New Material Setup Request Has Been Received\n\n" 
            	 	    +"\n Request ID: " +requestID
            	 	    +"\n\n Requester's Name: " +userName
            	 	    +"\n\n Requester's Email Address: "+userEmail
            	 	    +"\n\n Additional Email Address: "+addEmail
            	 	    +"\n\n Additional Email Address: "+addEmail1
            	 	    +"\n\n Additional Email Address: "+addEmail2
            	 	    +"\n\n Distributor: "+memberName
            	 	    +"\n\n Corporate Account(s): "+cust
            	 	    +"\n\n Notes: "+notes+"",
            	 	      	EmailAddr1,
            	 	    	subject,
            	 	        EmailAddr1);
            	 	 		
            	 	    	//}		
            	 	 	
            	 	  } catch(Exception exc){
            	 	     	//LOGGER.error("MST " + exc.getMessage(), exc);
            	 		 System.out.println("This is the Exception" + exc);
            	 		 try{
            	 			 
         					//System.out.println(requestID);
         					
         					oRS = oStmt.executeQuery("Select * From SAPFMTIPT.dbo.MST_RequestDtl Where RequestID = "+requestID+"");
         						if(!oRS.next()){
         							oStmt.executeUpdate("Delete From SAPFMTIPT.dbo.MST_Request Where RequestID = "+requestID+"");
         							oStmt.executeUpdate("Delete From SAPFMTIPT.dbo.MST_RequestDtlImport Where ImportReqID = "+requestID+"");
         							getServletContext().getRequestDispatcher("/requestFailed.jsp").forward(request, response);
         						}

         			   }  catch(Exception ex){

         			              System.out.println("This is the Exception" + ex);
         			              getServletContext().getRequestDispatcher("/requestFailed.jsp").forward(request, response);
         			   }
            	 		  				
            	 	  }

            	 	 		finally {
            	 	 			try { 
        	 	 					if(oRS != null)
        	 	 						oRS.close();
        	 	 					if(oStmt != null)
        	 	 						oStmt.close();
        	 	 					if(oRS1 != null)
        	 	 						oRS1.close();
        	 	 					if(oStmt1 != null)
        	 	 						oStmt1.close();
        	 	 					if(oRS2 != null)
        	 	 						oRS2.close();
        	 	 					if(oStmt2 != null)
        	 	 						oStmt2.close();
        	 	 					if(oConn != null)
        	 	 						oConn.close();

        	 	 					} catch(Exception exce) 
        	 	 						{
        	 	                    			//LOGGER.error("MST " + exc.getMessage(), exc);
        	 	                    			System.out.println("This is the Exception" + exce);
        	 	                    			
        	 	 						}

            	 	 			   }
            	//System.out.println(itemExistsFlag);
         
            		getServletContext().getRequestDispatcher("/requestSubmitted.jsp").forward(request, response);
            		//request.getRequestDispatcher("./ReqSubmitted.jsp").forward(request, response);
            		return;
            	}
            	         
           } 
               
     }




   
