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
                <link href="/riamco/css/riamco.css" rel="stylesheet" type="text/css"/>
            </head>
            <body>
                <div id="wrapper">
                    <div id="header">
                        <a href="/riamco">
                              <img src="/riamco/img/RIAMCO_header_graphic.gif" alt="RIAMCO"/>
                        </a>
                    </div>
                    <div id="horizontal_nav_bar">
                        <a href="/riamco">
                            <img src="/riamco/img/nav_buttons/Home_button.gif" alt="Home"/>
                        </a>
                        <a href="browse.html">
                            <img src="/riamco/img/nav_buttons/Browse_button.gif" alt="Browse"/>
                        </a>
                        <a href="advanced_search.html">
                            <img src="/riamco/img/nav_buttons/Advanced_search_button.gif" alt="Advanced Search"/>
                        </a>
                        <a href="about.html">
                            <img src="/riamco/img/nav_buttons/About_button.gif" alt="About"/>
                        </a>
                        <a href="help.html">
                            <img src="/riamco/img/nav_buttons/Help_button.gif" alt="Help"/>
                        </a>
                        <a href="contact.html">
                            <img src="/riamco/img/nav_buttons/Contact_button.gif" alt="Contact"/>
                        </a>
                    </div>
                    <div id="content">
                        <div id="main_text">
                            <div class="nav_column">
                                <h3>View Options:</h3>
                                <ul>
                                    <li>
                                        <a href="render_pending.php?eadid={$eadid}&amp;view=title">Standard</a>
                                    </li>
                                    <li>
                                        <a href="#">Entire finding aid</a>
                                    </li>
                                    <li>
                                        <a href="#">Printer-friendly (PDF)</a>
                                    </li>
                                    <li>
                                        <a href="#">E-mail this finding aid</a>
                                    </li>
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
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']">
                                        <li>
                                            <a href="render_pending.php?eadid={$eadid}&amp;view=subject">Search terms</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:dsc">
                                        <li>
                                            <a href="render_pending.php?eadid={$eadid}&amp;view=inventory">Inventory</a>
                                        </li>
                                    </xsl:if>
                                </ul>
                            <!--    <h3>Search within document:</h3>
                                <input name="search" type="text"/>
                                <input name="go" type="submit" value="Search"/>
                                <ul>
                                    <li>
                                        <a href="render_pending.php?eadid={$eadid}">Top of finding aid</a>
                                    </li>
                                    </ul> -->


                              </div>
                            <div class="right_two_thirds">
                                <h1>
                                    <a href="render_pending.php?eadid={$eadid}">
                                        <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unittitle[@type='primary']"/>
                                    </a>
                                    
                                </h1>
                                
                                
<h3>Search Terms</h3>
                                <table width="705" border="0" cellpadding="0" cellspacing="0">
<tr>
<td valign="top">
<xsl:apply-templates select="ead:ead/ead:archdesc"/>
<p/>
</td>
</tr>
</table>
</div>
                             
                                <table width="705" border="0" cellpadding="0" cellspacing="0">
                                    
                                    <tr><td colspan="2">
This collection is indexed under the following headings.  People, families, and organizations are listed under "Names" when they are creators or contributors, and under "Subjects" when they are the topic of collection contents:</td></tr>

<xsl:call-template name="controlaccess"/>
<tr><td colspan="2"> </td></tr>
<xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='add']/ead:odd[@type='opac']">
<xsl:call-template name="opac"/>
</xsl:if>


<xsl:template name="controlaccess">
<xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/controlaccess[head='Names']">
<xsl:call-template name="Names"/>
</xsl:if>

<xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/controlaccess[head='Subjects']">
	<xsl:call-template name="Subjects"/>
</xsl:if>

<xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/controlaccess[head='Titles']">
<xsl:call-template name="Titles"/>
</xsl:if>

<xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/controlaccess[head='Types of materials']">
	<xsl:call-template name="Genres"/>
</xsl:if>
</xsl:template>

<xsl:template name="opac">
	<tr><td colspan="2">Researchers seeking materials about topics, places, or names related to this collection may search the Brown University Library catalog (Josiah) via this link: <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp[@type='add']/ead:odd[@type='opac']/ead:p/ead:archref"/></td></tr>
</xsl:template>

<xsl:template name="Names">
   <tr>
	<td valign="top"><b><xsl:text>Names:</xsl:text></b></td>
	<td>
	  <xsl:for-each select="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess[head='Names']/ead:persname|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess[head='Names']/ead:famname|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess[head='Names']/ead:corpname">
           <xsl:sort data-type="text" order="ascending"/>
  	     <xsl:apply-templates/>
	      <br/>
	  </xsl:for-each>
	</td>
   </tr>
</xsl:template>


<xsl:template name="Subjects">
	<tr>
	<td valign="top"><b><xsl:text>Subjects:</xsl:text></b></td>
	<td>

	<xsl:for-each select="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess[head='Subjects']/ead:persname|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess[head='Subjects']/ead:famname|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess[head='Subjects']/ead:corpname|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess[head='Subjects']/ead:geogname|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess[head='Subjects']/ead:subject[@source!='local']">
            <xsl:sort data-type="text" order="ascending"/>
	    <xsl:apply-templates/>
	    <br/>
	  </xsl:for-each>
	  </td>
	  </tr>
</xsl:template>

<xsl:template name="Titles">
	<tr>
	<td valign="top"><b><xsl:text>Titles:</xsl:text></b></td>
	<td>
	<xsl:for-each select="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess[head='Titles']/ead:title">
	     <xsl:sort data-type="text" order="ascending"/>
	     <xsl:apply-templates/>
	     <br/>
	  </xsl:for-each>
</td>
	</tr>
</xsl:template>

<xsl:template name="Genres">
	<tr>
	<td valign="top"><b><xsl:text>Types of materials:</xsl:text></b></td>
	<td>
<xsl:for-each select="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess[head='Types of materials']/ead:genreform">
    	<xsl:sort data-type="text" order="ascending"/>
		<xsl:apply-templates/>
	     <br/>
	  </xsl:for-each>
	</td>
	</tr>
</xsl:template>

<xsl:template match="archref">
<a href="{./@href}" target="_new"><xsl:value-of select="text()"/>.</a>
<p/>
</xsl:template>

                                    
                                    
                                </table>
                            </div>
                    </div>
         
                    <div id="sponsor_footer">
                        <p>Sponsors:&#160;&#160;&#160;&#160;&#160;&#160;&#160;<a href="http://www.neh.gov/">
                                <img src="/riamco/img/neh_logo.gif" alt="National Endowment"/>
                            </a>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<a href="http://www.wethepeople.gov/">
                                <img src="/riamco/img/wtp_logo.gif" alt="We the People"/>
                            </a></p>

                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="ead:seriesstmt/ead:p">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:notestmt/ead:note/ead:p">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:appraisal/ead:p">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:accruals/ead:p">
        <xsl:apply-templates/>
    </xsl:template>

 <xsl:template match="ead:processinfo/ead:p">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:custodhist">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

<xsl:template name="creationdate">
	<xsl:value-of select="from-self(/ead:ead/ead:eadheader/ead:profiledesc/ead:creation)"/>
	<br/>
	<xsl:value-of select="/ead:ead/ead:eadheader/ead:profiledesc/ead:creation/ead:date"/>
</xsl:template>



</xsl:stylesheet>
