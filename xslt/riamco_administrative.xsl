<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:param name="eadid">
        <xsl:value-of select="/ead:ead/ead:eadheader/ead:eadid"/>
    </xsl:param>

    <xsl:include href="riamco_nav1.xsl" />
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
                                <h3>Administrative Information</h3>
                                <table width="695" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="category_column">ABOUT THE COLLECTION</td>
                                        <td class="table_section_header">&#160;</td>
                                    </tr>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:acqinfo/ead:p">
                                        <tr>
                                            <td width="165" class="category_column">Acquisition:</td>
                                            <td width="530" class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:descgrp/ead:acqinfo/ead:p"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:custodhist/ead:p">
                                        <tr>
                                            <td class="category_column">Custodial history:</td>
                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:descgrp/ead:custodhist"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:accruals/ead:p">
                                        <tr>
                                            <td class="category_column">Accruals:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:accruals/ead:p"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:appraisal">
                                        <tr>
                                            <td class="category_column">Appraisal:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:appraisal"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:processinfo/ead:p">
                                        <tr>
                                            <td class="category_column">Processing information:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:processinfo/ead:p"/>
                                            </td>
                                        </tr>
                                    </xsl:if>

                                   <tr>
                                            <td class="category_column"></td>
                                            <td class="info_column"></td>
                                        </tr>
                                         <tr>
                                            <td class="category_column"></td>
                                            <td class="info_column"></td>
                                        </tr>

                                    <tr>
                                        <td class="category_column">ABOUT THE FINDING AID</td>
                                        <td class="table_section_header">&#160;</td>
                                    </tr>
                                    <xsl:if test="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:author">
                                        <tr>
                                            <td class="category_column">Author:</td>
                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:author"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:eadheader/ead:profiledesc/ead:creation">
                                        <tr>
                                            <td class="category_column">Encoding:</td>
                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:eadheader/ead:profiledesc/ead:creation"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:eadheader/ead:revisiondesc">

                                        <tr>
                                            <td class="category_column">Revisions:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:revisiondesc"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:eadheader/ead:profiledesc/ead:descrules">
                                        <tr>
                                            <td class="category_column">Descriptive rules:</td>

                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:eadheader/ead:profiledesc/ead:descrules"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if
                                        test="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:sponsor">
                                        <tr>
                                            <td class="category_column">Sponsor:</td>
                                            <td class="info_column">
                                                <xsl:value-of
                                                    select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:sponsor"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                     <xsl:if test="/ead:ead/ead:eadheader/ead:profiledesc/ead:editionstmt/ead:p">
                                    <tr>
                                        <td class="category_column">Edition:</td>
                                        <td class="info_column"/>
                                    </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:eadheader/ead:filedesc/ead:seriesstmt">
                                        <tr>
                                            <td class="category_column">Series:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:seriesstmt"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:eadheader/ead:filedesc/ead:notestmt">
                                        <tr>
                                            <td class="category_column">Note:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:notestmt"/>
                                            </td>
                                        </tr>
                                    </xsl:if>

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

    <xsl:template match="ead:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="ead:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="ead:title">
        <i>
            <xsl:apply-templates/>
        </i>
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
