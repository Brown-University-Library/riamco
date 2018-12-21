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


<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-3203647-17']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>




            </head>
            <body>
                <div id="wrapper">
                    <div id="header">
                        <a href="..">
                            <img src="img/RIAMCO_header_graphic.gif" alt="RIAMCO"/>
                        </a>
                    </div>
                    <div id="horizontal_nav_bar">
                        <a href="..">
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
                                    <!-- <li>
                                        <a href="render.php?eadid={$eadid}">Standard</a>
                                    </li>
                                    <li>
                                        <a href="#">Entire finding aid</a>
                                    </li> -->
                                
                                    <li>
                                   <a onclick="window.open('pdfCreation.html','welcome','width=600,height=40')" href="mkpdf.php?eadd={$eadid}">Printer-friendly (PDF)</a> 
                                    </li>
                                   <!-- <li>
                                        <a href="#">E-mail this finding aid</a>
                                    </li> -->
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
                               <!-- <h3>Search within document:</h3>
                                <input name="search" type="text"/>
                                <input name="go" type="submit" value="Search"/>
                                <ul>
                                    <li>
                                        <a href="render_pending.php?eadid={$eadid}">Top of finding aid</a>
                                    </li>
                                </ul>-->
                                
                                
                            </div>
                            <div class="right_two_thirds">
                            <center>
                                <h1>
                                    <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper"/>
                                    <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:date/@inclusive"/>  
                                    <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:date/@bulk"/>                                
                                </h1>
                                </center>
                                <center>
                                    <img src="img/{ead:ead/ead:eadheader/ead:eadid/@mainagencycode}.jpg"/>

                                    <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:repository"/>
                                    
                                    <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:publisher"/>
                                </center>
                            </div>
                        </div>
                    </div>
                    <div id="sponsor_footer">
                        <p>Sponsors:&#160;&#160;&#160;&#160;&#160;&#160;&#160;<a href="http://www.neh.gov/">
                                <img src="img/neh_logo.gif" alt="National Endowment"/>
                            </a>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<a href="http://www.wethepeople.gov/">
                                <img src="img/wtp_logo.gif" alt="We the People"/>
                            </a></p>

                    </div>
                </div>
            </body>
        </html>
    </xsl:template>


    <xsl:template match="ead:publisher">
        <p>
            <xsl:text>Published in </xsl:text>
            <xsl:value-of select="substring(/ead:ead/ead:eadheader/ead:profiledesc/ead:creation/ead:date/@normal,1,4)"/>
        </p>
    </xsl:template>

   
<xsl:template match="ead:date[@type='inclusive']">
<xsl:text>, </xsl:text>
<xsl:apply-templates/>
</xsl:template>

    <xsl:template match="ead:repository">
        <p>
            <br/>
            <xsl:apply-templates/> 
        </p>
    </xsl:template>

<xsl:template match="ead:subarea">
<xsl:text>, </xsl:text>
<xsl:apply-templates/>
</xsl:template>

    <xsl:template match="ead:addressline">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

    <xsl:template match="ead:extptr[@xlink:href]">
        <a href="{@xlink:href}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="ead:corpname">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    
    </xsl:stylesheet>
