<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ns2="http://www.w3.org/1999/xlink">
    <xsl:param name="eadidx">
        <xsl:value-of select="/ead:ead/ead:eadheader/ead:eadid"/>
    </xsl:param>

    <xsl:include href="riamco_nav1.xsl"/>
    <xsl:include href="riamco_html_title.xsl" />
    <xsl:include href="riamco_ga.xsl" />
    <xsl:include href="riamco_top_banner.xsl" />

    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <xsl:call-template name="html_title_template" />
                <link href="css/riamco.css" rel="stylesheet" type="text/css"/>
                <link rel="shortcut icon" type="image/x-icon" href="favicon.png" />
                <script type="text/javascript" src="js/jquery.js"></script>
                <xsl:call-template name="google_analytics_script" />
            </head>
            <body>
                <div class="topbar">
                    <a href="index.html" title="Go back to the RIAMCO home page">
                        <div>
                                <p class="topbar-heading">RIAMCO</p>
                                <p class="topbar-subheading">Rhode Island Archival and Manuscript Collections Online</p>
                        </div>
                    </a>
                </div>
                <div id="wrapper">
                    <div id="content">
                        <div id="main_text">
                            <xsl:call-template name="nav_template" />
                			<div class="right_two_thirds">
                                <xsl:call-template name="top_banner" />
                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:bioghist"/>
                                <xsl:choose>
                                <xsl:when test="ead:chronlist/ead:chronitem">
                                <table width="613" border="0" cellpadding="0" cellspacing="0" class="indent_1">
                                                    <tr class="table_section_header">
                                                        <td width="114">Date</td>
                                                        <td width="385">Event</td>
                                                </tr>
                                                <tr>
                                                        <td width="114"><xsl:apply-templates select="ead:date"/></td>
                                                        <td width="385"><xsl:apply-templates select="ead:event"/></td>
                                                </tr>
                                            </table>
                                            </xsl:when>
                                            <xsl:otherwise>
                                            <table width="613" border="0" cellpadding="0" cellspacing="0" class="indent_1">
                                            <tr>
                                                        <td width="114"><xsl:apply-templates select="ead:date"/></td>
                                                        <td width="385"><xsl:apply-templates select="ead:event"/></td>
                                                </tr>
                                            </table>
                                            </xsl:otherwise>
                                </xsl:choose>

			  
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

    <xsl:template match="ead:bioghist">
        <div style="max-width:700px;">
            <xsl:apply-templates/>
        </div>
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


    <xsl:template match="ead:archdesc/ead:bioghist/ead:chronlist">
        <h3>Chronology</h3>
        <table width="613" border="0" cellpadding="0" cellspacing="0">
            <tr class="table_section_header">
                <th width="120" align="left">
                    <xsl:choose>
                        <xsl:when test="ead:archdesc/ead:bioghist/ead:chronlist/ead:listhead">
                            <xsl:value-of select="ead:head01"/>
                        </xsl:when>
                        <xsl:otherwise>Date</xsl:otherwise>
                    </xsl:choose></th>
                <th width="20"/>
                <th width="473" align="left"> <xsl:choose>
                    <xsl:when test="ead:archdesc/ead:bioghist/ead:chronlist/ead:listhead/ead:head02">
                        <xsl:apply-templates select="ead:archdesc/ead:bioghist/ead:chronlist/ead:listhead/ead:head02"/>
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


<!--<xsl:template match="ead:archdesc/ead:bioghist/ead:chronlist">
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

<!--<xsl:template match="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem">
<tr>
<td valign="top" width="25%"><xsl:value-of select="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem/ead:date"/></td>
<td valign="top" width="5%"></td>
<td valign="top" width="70%"><xsl:value-of select="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem/ead:event"/></td>
</tr>
<xsl:apply-templates select="ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem"/>
</xsl:template>-->


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
        <li>
            <xsl:apply-templates/>
        </li>
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

<xsl:template match="ead:date[@type='inclusive']">
<xsl:text>, </xsl:text>
<xsl:apply-templates/>
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
