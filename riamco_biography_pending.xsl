<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:param name="eadid">
        <xsl:value-of select="/ead:ead/ead:eadheader/ead:eadid"/>
    </xsl:param>
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>RIAMCO &#160;&#124;&#160; Rhode Island Archival and Manuscript Collections Online</title>
                <link href="css/riamco.css" rel="stylesheet" type="text/css"/>
            </head>
            <body>
                <div id="wrapper">
                    <div id="header">
                        <a href="/riamco">
                            <img src="img/RIAMCO_header_graphic.gif" alt="RIAMCO"/>
                        </a>
                    </div>
                    <div id="horizontal_nav_bar">
                        <a href="/riamco">
                            <img src="img/nav_buttons/Home_button.gif" alt="Home"/>
                        </a>
                        <a href="browse.html">
                            <img src="img/nav_buttons/Browse_button.gif" alt="Browse"/>
                        </a>
                        <a href="advanced_search.html">
                            <img src="img/nav_buttons/Advanced_search_button.gif" alt="Advanced Search"/>
                        </a>
                        <a href="about.html">
                            <img src="img/nav_buttons/About_button.gif" alt="About"/>
                        </a>
                        <a href="help.html">
                            <img src="img/nav_buttons/Help_button.gif" alt="Help"/>
                        </a>
                        <a href="contact.html">
                            <img src="img/nav_buttons/Contact_button.gif" alt="Contact"/>
                        </a>
                    </div>
                    <div id="content">
                        <div id="main_text">
                            <div class="nav_column">
                                <h3>View Options:</h3>
                                <ul>
                                    <!--<li>
                                        <a href="render_pending.php?eadid={$eadid}">Standard</a>
                                    </li>
                                    <li>
                                        <a href="#">Entire finding aid</a>
                                    </li>-->
                                    <li>
                                        <a href="#">Printer-friendly (PDF)</a>
                                    </li>
                                   <!-- <li>
                                        <a href="#">E-mail this finding aid</a>
                                    </li>-->
                                </ul>
                                <h3>Sections:</h3>
                                <ul>
                                <li>
                                        <a href="render_pending.php?eadid={$eadid}&amp;view=title">Title</a>
                                    </li>
                                    <li>
                                        <a href="render_pending.php?eadid={$eadid}&amp;view=overview">Collection overview</a>
                                    </li>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:scopecontent">
                                        <li>
                                            <a href="render_pending.php?eadid={$eadid}&amp;view=scope">Scope &amp; content</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:arrangement">
                                        <li>
                                            <a href="render_pending.php?eadid={$eadid}&amp;view=arrangement">Arrangement</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:bioghist">
                                        <li>
                                            <a href="render_pending.php?eadid={$eadid}&amp;view=biography">Biographical/Historical note</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:accessrestrict">
                                        <li>
                                            <a href="render_pending.php?eadid={$eadid}&amp;view=access">Access &amp; use</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="(/ead:ead/ead:archdesc/ead:descgrp[@type='administrative']) or (/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:author) or (/ead:ead/ead:eadheader/ead:profiledesc/ead:creation)">
                                        <li>
                                            <a href="render_pending.php?eadid={$eadid}&amp;view=administrative">Administrative information</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='additional']">
                                        <li>
                                            <a href="render_pending.php?eadid={$eadid}&amp;view=addinfo">Additional information</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:dsc">
                                        <li>
                                            <a href="render_pending.php?eadid={$eadid}&amp;view=inventory">Inventory</a>
                                        </li>
                                    </xsl:if>
                                </ul>
                                <!--<h3>Search within document:</h3>
                                <input name="search" type="text"/>
                                <input name="go" type="submit" value="Search"/>
                                <ul>
                                    <li>
                                        <a href="render_pending.php?eadid={$eadid}">Top of finding aid</a>
                                    </li>
                                </ul>-->
                                
                                
                            </div>
                            <div class="right_two_thirds">
                                <h1>
                                    <a href="render_pending.php?eadid={$eadid}">
                                        <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unittitle[@type='primary']"/>
                                    </a>
                                </h1>
                                
                                
                                
                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:bioghist"/>
                                
                           
                                
                                <xsl:if test="ead:ead/ead:eadheader/ead:eadid[@mainagencycode='US-RBrRW']">
                                    <img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='a']/@xlink:href}"/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='b']/@xlink:href}"/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='c']/@xlink:href}"/>
                                    <br/>
                                    <img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='d']/@xlink:href}"/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='e']/@xlink:href}"/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='f']/@xlink:href}"/>
                                    
                                </xsl:if>
                                
                               
                            </div>
                        </div>
                    </div>
                    <div id="sponsor_footer">
                        <p>Sponsors:&#160;&#160;&#160;&#160;&#160;&#160;&#160;<a href="http://www.neh.gov/">
                                <img src="img/neh_logo.gif" alt="National Endowment"/>
                            </a>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<a href="http://www.wethepeople.gov/">
                                <img src="img/wtp_logo.gif" alt="We the People"/>                                   
                            </a>
                        </p>

                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="ead:bioghist">
        
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:head">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="ead:title">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="ead:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="ead:chronlist">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="ead:chronitem">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="ead:listhead">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="ead:head01">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="ead:head02">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="ead:archdesc/ead:bioghist/ead:chronlist">
        <h3>Chronology</h3>
        <table width="613" border="0" cellpadding="0" cellspacing="0">
            <tr class="table_section_header">
                <th width="120" align="left">
                    <xsl:choose>
                        <xsl:when test="ead:archdesc/ead:bioghist/ead:chronlist/ead:listhead">
                            <xsl:value-of select="ead:archdesc/ead:bioghist/ead:chronlist/ead:listhead/ead:head01"/>
                    </xsl:when>
                        <xsl:otherwise>Date</xsl:otherwise>
                    </xsl:choose></th>
            <th width="20"/>
                <th width="473" align="left"> 
                    <xsl:choose>
                    <xsl:when test="ead:archdesc/ead:bioghist/ead:chronlist/ead:listhead/ead:head02">
                        <xsl:value-of select="ead:archdesc/ead:bioghist/ead:chronlist/ead:listhead/ead:head02"/>
                    </xsl:when>
                    <xsl:otherwise>Event</xsl:otherwise>
                </xsl:choose></th>
             </tr>
             <xsl:for-each select="ead:chronitem">
                 <tr>
                     <td width="120" valign="top"><xsl:value-of select="ead:date"/></td>
                     <td width="20"/>
                     <td width="473" valign="top"><xsl:value-of select="ead:event"></xsl:value-of></td>
                 </tr>
             </xsl:for-each>
         </table>  
    </xsl:template>
    
   <!-- <xsl:template match="ead:archdesc/ead:bioghist/ead:chronlist">
        <xsl:apply-templates select="ead:archdesc/ead:bioghist/ead:chronlist/ead:head"/>
        <blockquote>
            <table width="90%">
                <tr>
                    <td valign="top" width="28%"><b><xsl:value-of select="listhead/head01"/></b></td>
                    <td valign="top" width="2%"> </td>
                    <td valign="top" width="70%"><b><xsl:value-of select="listhead/head02"/></b></td>
                </tr>
                <xsl:apply-templates select="chronitem"/>
            </table>
        </blockquote>
    </xsl:template>-->
    
<!--   <xsl:template match="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem">
        <table width="90%">
            <tr>
                <td valign="top" width="25%"><xsl:value-of select="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem/ead:date"/></td>
                <td valign="top" width="5%"></td>
                <td valign="top" width="70%">
                    <xsl:choose>
                        <xsl:when test="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem/ead:eventgrp">
                            <xsl:apply-templates select="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem/ead:eventgrp"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem/ead:event">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                            <p/>
                        </xsl:otherwise></xsl:choose>
                </td>
            </tr>
        </table>
    </xsl:template>-->
    
   <!-- <xsl:template match="ead:archdesc/ead:bioghist/ead:chronlist">
        <b><xsl:apply-templates select="ead:archdesc/ead:bioghist/ead:chronlist/ead:head"/></b>
        <blockquote>
            <table width="90%">
                <tr>
                    <td valign="top" width="28%"><b><xsl:value-of select="ead:archdesc/ead:bioghist/ead:chronlist/ead:listhead/ead:head01"/></b></td>
                    <td valign="top" width="2%"> </td>
                    <td valign="top" width="70%"><b><xsl:value-of select="ead:archdesc/ead:bioghist/ead:chronlist/ead:listhead/ead:head02"/></b></td>
                </tr>
                <xsl:apply-templates select="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem"/>
            </table>
        </blockquote>
    </xsl:template>-->
    
   <!-- <xsl:template match="ead:archdesc/ead:bioghist/ead:chronlist">
        <table width="90%">
        <tr>
            <td valign="top" width="25%"><xsl:value-of select="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem/ead:date"/></td>
            <td valign="top" width="5%"></td>
            <td valign="top" width="70%"><xsl:value-of select="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem/ead:event"/></td>
        </tr>
        <xsl:apply-templates select="ead:archdesc/ead:bioghist/ead:chronlist"/>
        </table>
    </xsl:template>-->
    
    
    <xsl:template match="ead:date">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="ead:event">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
   
    <xsl:template match="ead:unitdate">
        <xsl:text> | </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

<xsl:template match="ead:extref[@xlink:href]">
        <a href="{@xlink:href}">
            <xsl:apply-templates/>
        </a>
</xsl:template>
    
    <xsl:template match="ead:archref[@xlink:href]">
        <a href="{@xlink:href}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    



<xsl:template match="p">
<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="lb">
<br><xsl:apply-templates/></br>
</xsl:template>

<xsl:template match="ead:p/ead:list">
	<ul>
	<xsl:apply-templates/>
	</ul>
</xsl:template>

<xsl:template match="ead:p/ead:list/ead:item">
	<li><xsl:apply-templates/></li>
</xsl:template>
    
    <xsl:template match="ead:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <xsl:template match="ead:list/ead:item">
        <li><xsl:apply-templates/></li>
    </xsl:template>

<xsl:template match="title">
   <xsl:choose>
	<xsl:when test="@type='poem'">
	<b>
	<xsl:text>"</xsl:text>
	<xsl:apply-templates select="text()"/>
	<xsl:text>"</xsl:text>
	</b>
	</xsl:when>

	<xsl:otherwise>
	<b><xsl:apply-templates select="text()"/></b>
	</xsl:otherwise>
   </xsl:choose>
</xsl:template>

<!-- The following general templates format the display of various RENDER attributes.-->

    <xsl:template match="ead:emph[@render='bold']">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="ead:emph[@render='italic']">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
    <xsl:template match="ead:emph[@render='underline']">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>
    <xsl:template match="ead:emph[@render='sub']">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>
    <xsl:template match="ead:emph[@render='super']">
        <super>
            <xsl:apply-templates/>
        </super>
    </xsl:template>
    
    <xsl:template match="ead:emph[@render='quoted']">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="ead:emph[@render='doublequote']">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    <xsl:template match="ead:emph[@render='singlequote']">
        <xsl:text>'</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>'</xsl:text>
    </xsl:template>
    <xsl:template match="ead:emph[@render='bolddoublequote']">
        <b>
            <xsl:text>"</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>"</xsl:text>
        </b>
    </xsl:template>
    <xsl:template match="ead:emph[@render='boldsinglequote']">
        <b>
            <xsl:text>'</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>'</xsl:text>
        </b>
    </xsl:template>
    <xsl:template match="ead:emph[@render='boldunderline']">
        <b>
            <u>
                <xsl:apply-templates/>
            </u>
        </b>
    </xsl:template>
    <xsl:template match="ead:emph[@render='bolditalic']">
        <b>
            <i>
                <xsl:apply-templates/>
            </i>
        </b>
    </xsl:template>
    <xsl:template match="ead:emph[@render='boldsmcaps']">
        <font style="font-variant: small-caps">
            <b>
                <xsl:apply-templates/>
            </b>
        </font>
    </xsl:template>
    <xsl:template match="ead:emph[@render='smcaps']">
        <font style="font-variant: small-caps">
            <xsl:apply-templates/>
        </font>
    </xsl:template>
    
</xsl:stylesheet>
