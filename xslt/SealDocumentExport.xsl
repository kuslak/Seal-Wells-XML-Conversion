<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!-- $Id$ -->
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
 
  <xsl:output method="xml" version="1.0" omit-xml-declaration="yes" indent="yes"/>

   <xsl:param name="SealSHA" />  
  
  <!-- ==== -->
  <!-- root -->
  <!-- ==== -->
  <xsl:template match="iSDACSADocModel"> 
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
    
      <fo:layout-master-set>
         
        <!-- LAYOUT FOR SIGNATURE PAGE -->
        <fo:simple-page-master master-name="all" 
                               page-height="28cm" 
                               page-width="21.5cm" 
                               margin-top="1.0cm" 
                               margin-bottom="1.0cm" 
                               margin-left="1.5cm" 
                               margin-right="1.5cm">
          <fo:region-body/>
          <fo:region-before region-name="xsl-region-before"/>
          <fo:region-after region-name="xsl-region-after"/>
        </fo:simple-page-master>
        
        <!-- Define how layouts are sequenced when outputting the document -->
        <fo:page-sequence-master master-name="firstAndRest" >
             <fo:repeatable-page-master-alternatives>                
                  <!-- Use layout for the rest of the pages -->
                  <fo:conditional-page-master-reference master-reference="all" page-position="rest" />
                  
                  <!-- recommended fallback procedure -->
                  <fo:conditional-page-master-reference master-reference="all" />
             </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>
        
      </fo:layout-master-set>
            
       <!-- Processing of First Page Layout Regions use page-sequence-master -->     
       <fo:page-sequence master-reference="firstAndRest"> 
           	        
	        <!-- Header for all Pages -->
	        <fo:static-content flow-name="xsl-region-before">
		        <fo:block>         	  
	            </fo:block>
	        </fo:static-content> 
	        
	        <!-- Footer for all Pages -->
	        <fo:static-content flow-name="xsl-region-after">
		        <fo:block font-family="Times" font-size="10pt" font-weight="normal" text-align="center">
		            <xsl:value-of select="filename"/> 
	        	</fo:block>
	        </fo:static-content> 
	        
	        <!-- Content Used for All Pages -->
	        <fo:flow flow-name="xsl-region-body">
	          <fo:block font-family="Times" font-size="10pt" font-weight="normal">
	              <fo:table table-layout="fixed" width="100%">
		              <fo:table-column column-width="8.0cm"/>
		              <fo:table-column column-width="10.0cm"/>

	              <fo:table-body>
	                   <xsl:call-template name="DocHeaderInfo"/>
	                   <xsl:apply-templates select="iSDACSATerms/*"/>
	              </fo:table-body>
	            </fo:table>
	          </fo:block>
	          <!-- Insert page break -->
	          <fo:block break-after='page'/> 	  
	        </fo:flow>
      </fo:page-sequence>        
    </fo:root>
  </xsl:template>
  
  <!-- ============================ -->
  <!--  Template Name: DocHeaderInfo   -->
  <!-- ============================ -->
  <xsl:template name="DocHeaderInfo">
    <!-- File Name Value  -->                 
	<fo:table-row>
      	<fo:table-cell padding-bottom="20pt" number-columns-spanned="2"> 	    
               <fo:block text-decoration="underline"  text-align="center" font-weight="bold">
        		     Filename:   <xsl:value-of select="filename"/>
        	    </fo:block>       	 
      	</fo:table-cell>
    </fo:table-row> 
    <!-- Seal document id  -->                 
   	<fo:table-row>
      	<fo:table-cell padding-bottom="10pt" number-columns-spanned="1"> 	    
               <fo:block text-align="left" font-weight="bold">
        		     SEAL ID:
        	    </fo:block>       	 
      	</fo:table-cell>
      	<fo:table-cell padding-bottom="10pt" number-columns-spanned="1">
            <fo:block text-align="left">
 				<xsl:value-of select="seal-id"/>
        	 </fo:block>
      	</fo:table-cell>
   	</fo:table-row>  	
  <!-- SHA Value  -->                 
	<fo:table-row>
      	<fo:table-cell padding-bottom="10pt" number-columns-spanned="1"> 	    
               <fo:block text-align="left" font-weight="bold">
        		     SHA1:
        	    </fo:block>       	 
      	</fo:table-cell>
      	<fo:table-cell padding-bottom="10pt" number-columns-spanned="1">
            <fo:block text-align="left">
 				<xsl:value-of select="sha1"/>
 				 <xsl:with-param name="SealSHA" select = "sha1" />
        	 </fo:block>
      	</fo:table-cell>
   	</fo:table-row>   

 
 </xsl:template>
  <!-- ============================= -->
  <!-- Template Match: iSDACSATerms  -->
  <!-- ============================= -->
  <xsl:template match="iSDACSATerms/*">

    <!-- Document_ID__c  -->    
	<fo:table-row>
      	<fo:table-cell padding-bottom="10pt" number-columns-spanned="1"> 	    
               <fo:block text-align="left" font-weight="bold">
        		     <xsl:value-of select="name(.)"/>:
        	    </fo:block>       	 
      	</fo:table-cell>
      	<fo:table-cell padding-bottom="10pt" number-columns-spanned="1">
            <fo:block text-align="left">
 				<xsl:value-of select="."/>
        	 </fo:block>
      	</fo:table-cell>
   	</fo:table-row>  

		                     	  					   	    					   	                
  </xsl:template>     
</xsl:stylesheet>
