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
                <link rel="shortcut icon" type="image/x-icon" href="favicon.png" />

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
                    <div class="top_menu">
                        <ul class="nav navbar-nav">
                            <li><a href="index.html" alt="RIAMCO">RIAMCO</a></li>
                            <li><a href="index.html" alt="Home">Home</a></li>
                            <li><a href="browse.html" alt="Browse">Browse</a></li>
                            <li><a href="advanced_search.html" alt="Advanced Search">Advanced Search</a></li>
                            <li><a href="about.html" alt="About">About</a></li>
                            <li><a href="help.html" alt="Help">Help</a></li>
                            <li><a href="contact.html" alt="Contact">Contact</a></li>
                        </ul>
                    </div>
                    <div id="content">
                        <div id="main_text">
                            <div class="nav_column">
                            <!--    <h3>View Options:</h3>
                                <ul>
                                    <li>
                                        <a href="render.php?eadid={$eadid}&amp;view=title">Standard</a>
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
                                </ul>-->
                                <h3>Sections:</h3>
                                <ul>
                                <li>
                                        <a href="render.php?eadid={$eadid}&amp;view=title">Title</a>
                                    </li>
                                    <li>
                                        <a href="render.php?eadid={$eadid}&amp;view=overview">Collection overview</a>
                                    </li>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:scopecontent">
                                        <li>
                                            <a href="render.php?eadid={$eadid}&amp;view=scope">Scope &amp; content</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:arrangement">
                                        <li>
                                            <a href="render.php?eadid={$eadid}&amp;view=arrangement">Arrangement</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:bioghist">
                                        <li>
                                            <a href="render.php?eadid={$eadid}&amp;view=biography">Biographical/Historical note</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:accessrestrict">
                                        <li>
                                            <a href="render.php?eadid={$eadid}&amp;view=access">Access &amp; use</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='administrative']">
                                        <li>
                                            <a href="render.php?eadid={$eadid}&amp;view=administrative">Administrative information</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='additional']">
                                        <li>
                                            <a href="render.php?eadid={$eadid}&amp;view=addinfo">Additional information</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']">
                                        <li>
                                            <a href="render.php?eadid={$eadid}&amp;view=subject">Search terms</a>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:dsc">
                                        <li>
                                            <a href="render.php?eadid={$eadid}&amp;view=inventory">Inventory</a>
                                        </li>
                                    </xsl:if>
                                </ul>
                            <!--    <h3>Search within document:</h3>
                                <input name="search" type="text"/>
                                <input name="go" type="submit" value="Search"/>
                                <ul>
                                    <li>
                                        <a href="render.php?eadid={$eadid}">Top of finding aid</a>
                                    </li>
                                </ul>
-->

                              </div>
                            <div class="right_two_thirds">
                                <h1>
                                    <a href="render.php?eadid={$eadid}&amp;view=title">
                                        <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unittitle[@type='primary']"/>
</a>

                                </h1>


<h3>Search Terms</h3>


                            </div>
                            <div id="sponsor_footer">
                                <p>Sponsors:&#160;&#160;&#160;&#160;&#160;&#160;&#160;<a href="http://www.neh.gov/">
                                    <img src="/riamco/img/neh_logo.gif" alt="National Endowment"/>
                                </a>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<a href="http://www.wethepeople.gov/">
                                    <img src="/riamco/img/wtp_logo.gif" alt="We the People"/>
                                </a></p>

                            </div>
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="/ead">

    <table width="705" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top">
                <xsl:apply-templates select="ead:ead/ead:archdesc"/>
                <p/>
            </td>
        </tr>
    </table>
    <table width="705" border="0" cellpadding="0" cellspacing="0">

        <tr><td colspan="2">
            This collection is indexed under the following headings.  People, families, and organizations are listed under "Names" when they are creators or contributors, and under "Subjects" when they are the topic of collection contents:</td></tr>

    </table>

        <xsl:template match="controlaccess">
            <xsl:apply-templates/>
        <tr><td colspan="2"> </td></tr>
        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='add']/ead:odd[@type='opac']">
            <xsl:call-template name="opac"/>
        </xsl:if>
        </xsl:template>

    </xsl:template>

                                    <xsl:template name="controlaccess">
                                        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/controlaccess">
                                            <xsl:call-template name="subject"/>
                                        </xsl:if>
                                    </xsl:template>

                                    <xsl:template name="opac">
                                        <tr><td colspan="2">Researchers seeking materials about topics, places, or names related to this collection may search the <xsl:value-of select="ead:ead/ead:archdesc/ead:did/ead:repository/ead:corpname"/> catalog via this link: <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp[@type='add']/ead:odd[@type='opac']/ead:p/ead:archref"/></td></tr>
                                    </xsl:template>

                                    <xsl:template name="subject">
                                        <tr>
                                            <td valign="top"><b><xsl:text>Names:</xsl:text></b></td>
                                            <td>
                                                <xsl:for-each select="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:persname|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:famname|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:corpname|ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:geogname|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:subject|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:title|/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:genreform">
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


 <xsl:template match="ead:date[@type='inclusive']">
<xsl:text>, </xsl:text>
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







</xsl:stylesheet>
