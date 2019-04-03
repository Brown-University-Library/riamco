<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:param name="eadid">
        <xsl:value-of select="/ead:ead/ead:eadheader/ead:eadid"/>
    </xsl:param>

<xsl:include href="riamco_nav1.xsl" />
<xsl:include href="riamco_html_title.xsl" />

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <xsl:call-template name="html_title_template" />
                <link href="css/riamco.css" rel="stylesheet" type="text/css"/>
                <link rel="shortcut icon" type="image/x-icon" href="favicon.png" />
                <script src="js/jquery.js"></script>
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




<xsl:call-template name="nav_template" />




                            <div class="right_two_thirds">
                                <h1>
                                    <a href="render.php?eadid={$eadid}&amp;view=title">
                                        <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unittitle[@type='primary']"/></a>
                                </h1>
                                <h2><xsl:value-of select="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:publisher"/></h2>
                                <h3>Collection Overview</h3>
                                <table width="695" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="165" class="category_column">Title:</td>
                                        <td width="530" class="info_column">
                                            <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unittitle[@type='primary']"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="category_column">Date range:</td>

                                        <td class="info_column">
                                            <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unitdate[@type='inclusive']"/>
                                            <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:unitdate[@type='bulk']">, <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unitdate[@type='bulk']"/></xsl:if>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="category_column">Creator:</td>
                                        <td class="info_column">
                                            <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname |/ead:ead/ead:archdesc/ead:did/ead:origination/ead:corpname|/ead:ead/ead:archdesc/ead:did/ead:origination/ead:famname"/>
                                        </td>
                                    </tr>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:physdesc/ead:extent/text()">
                                        <tr>
                                            <td class="category_column">Extent:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:physdesc/ead:extent"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:abstract/text()">
                                        <tr>
                                            <td class="category_column">Abstract:</td>
                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:abstract"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:physdesc/ead:physfacet/text()">
                                        <tr>
                                            <td class="category_column">Physical description:</td>
                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:physdesc/ead:physfacet"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:physdesc/ead:dimensions/text()">
                                        <tr>
                                            <td class="category_column">Dimensions:</td>
                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:physdesc/ead:dimensions"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:materialspec/text()">
                                        <tr>
                                            <td class="category_column">Material specific details:</td>
                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:materialspec"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:physloc/text()">
                                        <tr>
                                            <td class="category_column">Physical location:</td>

                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:physloc"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language/text()">
                                        <tr>
                                            <td class="category_column">Language of materials:</td>
                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <tr>
                                        <td class="category_column">Repository:</td>
                                        <td class="info_column">
                                            <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:repository/ead:corpname"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="category_column">Collection number:</td>
                                        <td class="info_column">
                                            <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unitid"/>
                                        </td>
                                    </tr>
                                </table>
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

    <xsl:template match="ead:extent">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

    <xsl:template match="ead:subarea">
<xsl:text>, </xsl:text>
<xsl:apply-templates/>
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
