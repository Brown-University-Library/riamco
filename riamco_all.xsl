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
                <link rel="shortcut icon" type="image/x-icon" href="favicon.png" />
            </head>
            <body>
                <div id="wrapper">
                    <div id="content">
                        <div id="main_text">
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

                                <!-- SECTION: collection overview -->
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

                                <!-- SECTION: scope and content -->
                                <h3>Scope &amp; content</h3>
                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:scopecontent"/>

                                <!-- SECTION: arrangement -->
                                <h3>Arrangement</h3>
                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:arrangement"/>
                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:fileplan"/>

                                <!-- SECTION: bigraphical note -->
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

                                <xsl:if test="ead:ead/ead:eadheader/ead:eadid[@mainagencycode='US-RBrRW']">
                                    <img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='a']/@xlink:href}"/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='b']/@xlink:href}"/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='c']/@xlink:href}"/>
                                    <br/>
                                    <img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='d']/@xlink:href}"/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='e']/@xlink:href}"/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;<img src="graphics/{ead:ead/ead:archdesc/ead:bioghist/ead:dao[@id='f']/@xlink:href}"/>
                                </xsl:if>

                                <!-- SECTION: access and use -->
                                <h3>Access &amp; Use</h3>

                                <table width="695" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="165" class="category_column">Access to the collection:</td>
                                        <td width="530" class="info_column">
                                            <xsl:value-of select="/ead:ead/ead:archdesc/ead:descgrp/ead:accessrestrict"/>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td class="category_column">Use of the materials:</td>
                                        <td class="info_column">
                                            <xsl:value-of select="/ead:ead/ead:archdesc/ead:descgrp/ead:userestrict"/>
                                        </td>
                                    </tr>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:altformavail">
                                        <tr>
                                            <td class="category_column">Alternate form:</td>

                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:descgrp/ead:altformavail"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:phystech">
                                        <tr>
                                            <td class="category_column">Physical characteristics:</td>
                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:descgrp/ead:phystech/ead:p"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <tr>

                                        <td class="category_column">Preferred citation:</td>
                                        <td class="info_column">
                                            <xsl:value-of select="/ead:ead/ead:archdesc/ead:descgrp/ead:prefercite/ead:p"/>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td class="category_column">Contact information:</td>
                                        <td class="info_column">
                                            <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:repository"/>
                                        </td>
                                    </tr>
                                </table>

                                <!-- SECTION: Administrative information -->
                                <h3>Administrative Information</h3>
                                <table width="695" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="category_column">ABOUT THE COLLECTION</td>
                                        <td class="table_section_header">&#160;</td>
                                    </tr>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:acqinfo">
                                        <tr>
                                            <td width="165" class="category_column">Acquisition:</td>
                                            <td width="530" class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:descgrp/ead:acqinfo"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:custodhist">
                                        <tr>
                                            <td class="category_column">Custodial history:</td>
                                            <td class="info_column">
                                                <xsl:value-of select="/ead:ead/ead:archdesc/ead:descgrp/ead:custodhist"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:accruals">
                                        <tr>
                                            <td class="category_column">Accruals:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:accruals"/>
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
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:processinfo">
                                        <tr>
                                            <td class="category_column">Processing information:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:processinfo"/>
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


                                <!-- SECTION: Additional information -->
                                <h3>Additional Information</h3>
                                <table width="695" border="0" cellpadding="0" cellspacing="0">
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:relatedmaterial">
                                        <tr>
                                            <td width="165" class="category_column">Related material:</td>
                                            <td width="530" class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:relatedmaterial"/>
                                            </td>
                                        </tr>
                                    </xsl:if>

                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:separatedmaterial">
                                        <tr>
                                            <td class="category_column">Separated material:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:separatedmaterial"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:originalsloc">
                                        <tr>
                                            <td class="category_column">Location of originals:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:originalsloc"/>
                                            </td>
                                        </tr>
                                    </xsl:if>

                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:altformavail">
                                        <tr>
                                            <td class="category_column">Location/Existence of copies:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:altformavail"/>
                                            </td>
                                        </tr>
                                    </xsl:if>

                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:otherfindaid">
                                        <tr>
                                            <td class="category_column">Alternative guide:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:otherfindaid"/>
                                            </td>
                                        </tr>
                                    </xsl:if>

                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:bibliography">
                                        <tr>
                                            <td class="category_column">Bibliography:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:bibliography"/>
                                            </td>
                                        </tr>
                                    </xsl:if>

                                    <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:odd">
                                        <tr>
                                            <td class="category_column">Other information:</td>
                                            <td class="info_column">
                                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp/ead:odd"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                </table>

                                <!-- SECTION: Inventory -->
                                <h3>Inventory</h3>
                                <hr/>
                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:dsc"/>

                            </div> <!-- right_two_thirds -->
                        </div>
                    </div>
                    <div id="sponsor_footer">
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

    <xsl:template match="ead:addressline[ead:extptr]">
        <a href="{ead:extptr/@xlink:href}">
            <xsl:apply-templates/>
        </a>
        <br/>
    </xsl:template>

    <xsl:template match="ead:addressline">
        <xsl:apply-templates/>
        <br/>
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

    <xsl:template match="ead:corpname">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

    <!-- SECTION: collection_overview -->
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

    <!-- SECTION: scope and content -->
<xsl:template match="ead:scopecontent">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:p">
        <p>
            <xsl:apply-templates/>
        </p>
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

<xsl:template match="ead:title">
       <i>
           <xsl:apply-templates/>
       </i>
</xsl:template>


    <!-- SECTION: arrangement -->
<xsl:template match="ead:arrangement">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:p">
        <p>
            <xsl:apply-templates/>
        </p>
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

   <xsl:template match="ead:date[@type='inclusive']">
<xsl:text>, </xsl:text>
<xsl:apply-templates/>
</xsl:template>


    <!-- SECTION: bigraphical note -->
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


    <!-- SECTION: Access and use -->
<xsl:template match="ead:repository">
            <xsl:apply-templates/>
    </xsl:template>

<xsl:template match="ead:subarea">
<xsl:text>, </xsl:text>
<xsl:apply-templates/>
</xsl:template>

    <xsl:template match="ead:addressline">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

    <xsl:template match="ead:addressline[ead:extptr]">
        <a href="{ead:extptr/@xlink:href}">
            <xsl:apply-templates/>
        </a>
        <br/>
    </xsl:template>

    <xsl:template match="ead:corpname">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>


    <xsl:template match="ead:phystech">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="/ead:ead/ead:archdesc/ead:descgrp/ead:altformavail">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:userestrict">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:accessrestrict">
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


    <!-- SECTION: Administrative information -->
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

    <!-- SECTION: Additional information -->
    <xsl:template match="ead:relatedmaterial/ead:p">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:altformavail/ead:p">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:separatedmaterial/ead:p">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:originalsloc/ead:p">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:otherfindaid/ead:p">

        <xsl:apply-templates/>

    </xsl:template>

    <xsl:template match="ead:bibliography/ead:p">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="ead:odd/ead:p">
        <ul>
        <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="ead:bibref">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="lb">
        <br/>
    </xsl:template>

    <xsl:template match="ead:p">
        <p>
            <xsl:apply-templates/>
        </p>
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

    <xsl:template match="ead:unitdate">
        <xsl:text> | </xsl:text>
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

    <xsl:template match="ead:title">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>


    <!-- SECTION: Inventory -->
    <xsl:template match="ead:c">
        <xsl:if test="@level='series' or @level='subgrp'">
            <xsl:call-template name="series"/>
        </xsl:if>
        <xsl:if test="@level='subseries'">
            <xsl:call-template name="subseries"/>
        </xsl:if>
        <xsl:if test="@level='item' or @level='file'">
            <xsl:call-template name="item"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="series">
       <div class="series">
            <p>
                <strong>
                    <xsl:apply-templates select="ead:did/ead:unitid[@type='series' or @type='subgrp']"/>
                    <xsl:choose>
                        <xsl:when test="ead:dao[@ns2:role='METSID']">
                            <u>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>https://repository.library.brown.edu/studio/item/mets:</xsl:text><xsl:value-of select="ead:dao/@ns2:href"/>
                                        <xsl:text>/</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                    <xsl:apply-templates select="ead:did/ead:unittitle"/>
                                </a>
                            </u>

                        </xsl:when>
                        <xsl:when test="ead:dao[@ns2:role='BDR_PID']">
                            <u>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>https://repository.library.brown.edu/studio/item/</xsl:text><xsl:value-of select="ead:dao[@ns2:role='BDR_PID']/@ns2:href"/>
                                        <xsl:text>/</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                    <xsl:apply-templates select="ead:did/ead:unittitle"/>
                                </a>
                            </u>

                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="ead:did/ead:unittitle"/>

                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="ead:did/ead:unitdate[@type='inclusive']">
                        <xsl:text>, </xsl:text>
                        <xsl:apply-templates select="ead:did/ead:unitdate[@type='inclusive']"/>
                    </xsl:if>
                    <xsl:if test="ead:did/ead:unitdate[@type='bulk']">
                        <xsl:text> (</xsl:text>
                        <xsl:apply-templates select="ead:did/ead:unitdate[@type='bulk']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </strong>

                <xsl:if test="ead:acqinfo/ead:p/ead:num[@type='Call']">
                    <xsl:text>Call Number: </xsl:text>
                    <xsl:value-of select="ead:acqinfo/ead:p/ead:num"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:did/ead:physdesc/ead:extent">
                    <br/>
                    <xsl:apply-templates select="ead:did/ead:physdesc/ead:extent"/>
                </xsl:if>
                <xsl:if test="ead:did/ead:container">
                <br/>
                <xsl:apply-templates select="ead:did/ead:container"/>
                </xsl:if>
                <xsl:if test="ead:scopecontent/ead:p">
                    <br/>
                    <xsl:apply-templates select="ead:scopecontent/ead:p"/>
                </xsl:if>

                  <xsl:if test="ead:scopecontent/ead:p/ead:list">
                    <xsl:apply-templates select="ead:list"/>
                </xsl:if>
                    <xsl:if test="ead:bioghist/ead:p">
                    <xsl:apply-templates select="ead:bioghist/ead:p"/>
                    <br/>
                </xsl:if>
                 <xsl:if test="ead:did/ead:note/ead:p">
                   <br/>
                    <xsl:apply-templates select="ead:did/ead:note/ead:p"/>
                    <br/>
                </xsl:if>
                     <xsl:if test="ead:arrangement/ead:p">
                    <br/> Arrangement: <xsl:apply-templates select="ead:arrangement/ead:p"/>
                </xsl:if>

                <xsl:if test="ead:c[@level='series']/ead:controlaccess/ead:subject">
                   <br/> Subjects: <xsl:apply-templates select="ead:c/ead:controlaccess/ead:subject"/>
                </xsl:if>

           </p>
           <xsl:if test="child::ead:c[@level='series']">
               <xsl:apply-templates select="child::ead:c[@level='series']"/>
           </xsl:if>

            <xsl:if test="child::ead:c[@level='subseries']">
                <xsl:apply-templates select="child::ead:c[@level='subseries']"/>
            </xsl:if>

            <xsl:if test="child::ead:c[@level='file' or @level='item']">
                <table width="613" border="0" cellpadding="0" cellspacing="0" class="indent_2">
                    <tr class="table_section_header">
                        <td width="111">Container</td>
                        <td width="3"/>
                        <td width="382">Description</td>
                        <td width="3"/>
                        <td width="114">Date</td>
                    </tr>
                    <xsl:apply-templates select="child::ead:c[@level='file' or @level='item']"/>
                </table>
            </xsl:if>
  </div>
    </xsl:template>

    <xsl:template name="subseries">
        <p>
            <span class="indent_1">
                <strong>
                    <xsl:apply-templates select="ead:did/ead:unitid[@type='subseries']"/>
                    <xsl:choose>
                        <xsl:when test="ead:dao[@ns2:role='METSID']">
                            <u>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>https://repository.library.brown.edu/studio/item/mets:</xsl:text><xsl:value-of select="ead:dao/@ns2:href"/>
                                        <xsl:text>/</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                    <xsl:apply-templates select="ead:did/ead:unittitle"/>
                                </a>
                            </u>

                        </xsl:when>
                        <xsl:when test="ead:dao[@ns2:role='BDR_PID']">
                            <u>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>https://repository.library.brown.edu/studio/item/</xsl:text><xsl:value-of select="ead:dao[@ns2:role='BDR_PID']/@ns2:href"/>
                                        <xsl:text>/</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                    <xsl:apply-templates select="ead:did/ead:unittitle"/>
                                </a>
                            </u>

                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="ead:did/ead:unittitle"/>

                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="ead:did/ead:unitdate[@type='inclusive']">
                        <xsl:text>, </xsl:text>
                        <xsl:apply-templates select="ead:did/ead:unitdate[@type='inclusive']"/>
                    </xsl:if>
                    <xsl:if test="ead:did/ead:unitdate[@type='bulk']">
                        <xsl:text> (</xsl:text>
                        <xsl:apply-templates select="ead:did/ead:unitdate[@type='bulk']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </strong>
                <xsl:if test="ead:did/ead:physdesc/ead:extent">
                    <br/>
                    <xsl:apply-templates select="ead:did/ead:physdesc/ead:extent"/>
                </xsl:if>
                <xsl:if test="ead:did/ead:container">
                <br/>
                <xsl:apply-templates select="ead:did/ead:container"/>
                </xsl:if>
               <xsl:if test="ead:scopecontent/ead:p">
                    <br/>
                    <xsl:apply-templates select="ead:scopecontent/ead:p"/>
                </xsl:if>
                 <xsl:if test="ead:scopecontent/ead:p/ead:list">
                    <xsl:apply-templates select="ead:list"/>
                </xsl:if>
                 <xsl:if test="ead:bioghist/ead:p">
                    <xsl:apply-templates select="ead:bioghist/ead:p"/>
                    <br/>
                </xsl:if>
                 <xsl:if test="ead:did/ead:note/ead:p">
                   <br/>
                    <xsl:apply-templates select="ead:did/ead:note/ead:p"/>
                    <br/>
                </xsl:if>
                 <xsl:if test="ead:arrangement/ead:p">
                    <br/> Arrangement: <xsl:apply-templates select="ead:arrangement/ead:p"/>
                 </xsl:if>

                <xsl:if test="ead:controlaccess"> <br/> Subjects:
                    <xsl:apply-templates select="ead:controlaccess/ead:subject"/>
                </xsl:if>
            </span>
        </p>


       <xsl:if test="child::ead:c[@level='subseries']">
        <xsl:apply-templates select="child::ead:c[@level='subseries']"/>
            </xsl:if>

       <xsl:if test="child::ead:c[@level='file' or @level='item']">
          <table width="613" border="0" cellpadding="0" cellspacing="0" class="indent_2">
                    <tr class="table_section_header">
                        <td width="111">Container</td>
                        <td width="3"/>
                        <td width="382">Description</td>
                        <td width="3"/>
                        <td width="114">Date</td>
                </tr>
                <xsl:apply-templates select="child::ead:c"/>
            </table>
        </xsl:if>
    </xsl:template>


    <xsl:template name="item">
        <xsl:choose>
        <xsl:when test="ead:c[@id='c1']">

                <table width="613" border="0" cellpadding="0" cellspacing="0" class="indent_2">
                    <tr class="table_section_header">
                        <td width="111">Container</td>
                        <td width="3"/>
                        <td width="382">Description</td>
                        <td width="3"/>
                        <td width="114">Date</td>
                    </tr>
                    <xsl:apply-templates select="ead:c"/>
                </table>
                </xsl:when>
<xsl:otherwise>
<table width="613" border="0" cellpadding="0" cellspacing="0" class="indent_2">
        <tr>
            <td width="111" valign="top">
                <xsl:apply-templates select="ead:did/ead:container"/>
            </td>
            <td width="3" valign="top"/>


            <td width="382" valign="top">

                <!-- Just for Birri Pinturas collection -->
                <xsl:if test="ead:odd[@type='Birriproject']">
                    <b><xsl:text>Birri Project: </xsl:text></b>
                    <b><xsl:apply-templates select="ead:odd/ead:p"/></b>
                    <br/>
                </xsl:if>

                <xsl:choose>
                    <xsl:when test="ead:dao[@ns2:role='METSID']">
                        <u>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:text>https://repository.library.brown.edu/studio/item/mets:</xsl:text><xsl:value-of select="ead:dao/@ns2:href"/>
                                    <xsl:text>/</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:apply-templates select="ead:did/ead:unittitle"/>
                            </a>
                        </u>
                        <br/>
                    </xsl:when>
                    <xsl:when test="ead:dao[@ns2:role='BDR_PID']">
                        <u>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:text>https://repository.library.brown.edu/studio/item/</xsl:text><xsl:value-of select="ead:dao[@ns2:role='BDR_PID']/@ns2:href"/>
                                    <xsl:text>/</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:apply-templates select="ead:did/ead:unittitle"/>
                            </a>
                        </u>
                        <br/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="ead:did/ead:unittitle"/>
                        <br/>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="ead:did/ead:physdesc/ead:extent">
                    <xsl:apply-templates select="ead:did/ead:physdesc/ead:extent"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:scopecontent/ead:p">
                    <xsl:text>Contents Note: </xsl:text>
                    <xsl:apply-templates select="ead:scopecontent/ead:p"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:odd/ead:p">
                    <xsl:text>General Note: </xsl:text>
                    <xsl:apply-templates select="ead:odd/ead:p"/>
                    <br/>
                </xsl:if>


                <xsl:if test="ead:scopecontent/ead:p/ead:list">
                    <xsl:apply-templates select="process"/>
                </xsl:if>

                <xsl:if test="ead:acqinfo/ead:p/ead:num[@type='Item']">

                    <xsl:apply-templates select="ead:acqinfo/ead:p/ead:num"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:acqinfo/ead:p/ead:num[@type='Accession']">
                    <xsl:text>Accession Number: </xsl:text>
                    <xsl:value-of select="ead:acqinfo/ead:p/ead:num"/>
                    <br/>
                </xsl:if>

                <!-- Just for Birri Pinturas collection -->
                <xsl:if test="ead:acqinfo/ead:p/ead:num[@type='Birriclassification']">
                    <xsl:text>Birri Classification Code: </xsl:text>
                    <xsl:value-of select="ead:acqinfo/ead:p/ead:num"/>
                    <br/>
                </xsl:if>

                <!-- Just for Hubert Jennings papers -->
                <xsl:if test="ead:acqinfo/ead:p/ead:num[@type='Jenningsclasscode']">
                    <xsl:text>Jennings Classification Code: </xsl:text>
                    <xsl:value-of select="ead:acqinfo/ead:p/ead:num"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:did/ead:physdesc/ead:genreform">
                    <xsl:text>Genre: </xsl:text>
                    <xsl:apply-templates select="ead:did/ead:physdesc/ead:genreform"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:did/ead:physdesc/ead:dimensions">
                    <xsl:text>Dimensions: </xsl:text>
                    <xsl:apply-templates select="ead:did/ead:physdesc/ead:dimensions"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:did/ead:materialspec">
                    <xsl:text>Medium: </xsl:text>
                    <xsl:apply-templates select="ead:did/ead:materialspec"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:altformavail">
                    <xsl:text>Location of copies: </xsl:text>
                    <xsl:apply-templates select="ead:altformavail"/>
                    <br/>
                </xsl:if>

                <!-- to show just the <physdesc> tag when it has no children -->

                <xsl:if test="ead:did/ead:physdesc[not(ead:extent|ead:genreform|ead:dimensions)]">
                    <xsl:text>Physical Description Note: </xsl:text>
                    <xsl:apply-templates select="ead:did/ead:physdesc[not(ead:extent|ead:genreform|ead:dimensions)]"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:did/ead:langmaterial">
                    <xsl:apply-templates select="ead:did/ead:langmaterial"/>
                    <br/>
                </xsl:if>


                <xsl:if test="ead:arrangement/ead:p">
                    <xsl:text>Arrangement: </xsl:text>
                    <xsl:apply-templates select="ead:arrangement/ead:p"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:controlaccess/ead:subject">
                    <br/>
                    <text>Subjects: </text>
                    <br/>
                    <xsl:apply-templates select="ead:controlaccess/ead:subject"/>

                </xsl:if>

                <xsl:if test="ead:controlaccess/ead:persname">
                    <br/>
                    <text>Names: </text>
                    <br/>
                    <xsl:apply-templates select="ead:controlaccess/ead:persname"/>
                    <xsl:apply-templates select="ead:controlaccess/ead:corpname"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:did/ead:origination/ead:persname">
                    <br/>
                    <text>Names: </text>
                    <br/>
                    <xsl:apply-templates select="ead:did/ead:origination/ead:persname"/>
                    <xsl:apply-templates select="ead:did/ead:origination/ead:corpname"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:bioghist/ead:p">
                    <xsl:apply-templates select="ead:bioghist/ead:p"/>
                    <br/>
                </xsl:if>

                <xsl:if test="ead:did/ead:note/ead:p">
                    <br/>
                    <xsl:apply-templates select="ead:did/ead:note/ead:p"/>
                    <br/>
                </xsl:if>

            </td>

            <td width="3" valign="top"/>

            <td width="114" valign="top">
                <xsl:apply-templates select="ead:did/ead:unitdate"/>
            </td>
        </tr>
       </table>

     </xsl:otherwise>
        </xsl:choose>


        <xsl:if test="child::ead:c[@level='file' or @level='item']">

                <xsl:apply-templates select="child::ead:c[@level='file' or @level='item']"/>
        </xsl:if>


    </xsl:template>



   <!--  <xsl:template match="ead:controlaccess/ead:persname">
        <xsl:apply-templates/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="./@role"/>
        <xsl:text>)</xsl:text>
        <br/>
        </xsl:template> -->

    <xsl:template match="ead:did/ead:unitid[@type='subgrp']">
        <xsl:apply-templates/>
        <xsl:text>. </xsl:text>
    </xsl:template>

    <xsl:template match="ead:did/ead:unitid[@type='series']">
        <xsl:apply-templates/>
        <xsl:text>. </xsl:text>
    </xsl:template>

    <xsl:template match="ead:did/ead:unitid[@type='subseries']">
        <xsl:apply-templates/>
        <xsl:text>. </xsl:text>
    </xsl:template>

    <xsl:template match="ead:unittitle">
        <xsl:apply-templates/>
    </xsl:template>

<xsl:template match="ead:geogname">
        <br/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:unitdate">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:extent">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:scopecontent/ead:p">
            <xsl:apply-templates/>
            <br/>
            <xsl:if test="following-sibling::ead:p">
            <br/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="p">
<p><xsl:apply-templates/></p>
</xsl:template>

     <xsl:template match="ead:list">
	<ul>
	<xsl:apply-templates select="ead:item"/>
	</ul>
</xsl:template>

<xsl:template match="ead:item">
	<li>
    <xsl:apply-templates/>
    </li>
</xsl:template>

    <xsl:template name="process">
        <xsl:element name="table">
            <xsl:for-each select="ead:item">
                <xsl:element name="tr">
                    <xsl:element name="td">
                        <xsl:value-of select="ead:item"></xsl:value-of>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>


    <xsl:template match="ead:bioghist/ead:p">
            <xsl:apply-templates/>
            <br/>
            <xsl:if test="following-sibling::ead:p">
            <br/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:did/ead:note/ead:p">
            <xsl:apply-templates/>
            <br/>
            <xsl:if test="following-sibling::ead:p">
            <br/>
        </xsl:if>
    </xsl:template>

<xsl:template match="ead:arrangement/ead:p">
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:container">
        <xsl:value-of select="@label"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::ead:container">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:controlaccess/ead:subject">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

    <xsl:template match="ead:controlaccess/ead:persname">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

    <xsl:template match="ead:controlaccess/ead:corpname">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

<xsl:template match="ead:extref[@xlink:href]">
        <a href="{@xlink:href}">
            <xsl:apply-templates/>
        </a>
</xsl:template>

<xsl:template match="ead:archref[@xlink:href]">
        <u>
            <a href="{@xlink:href}">
            <xsl:apply-templates/>
            </a>
        </u>
</xsl:template>

<xsl:template match="ead:dao[@xlink:href]">
        <a href="http://dl.lib.brown.edu/repository2/repoman.php?verb=render&amp;id={@xlink:href}">
           <xsl:apply-templates select="ead:unittitle"/>
        </a>
</xsl:template>

    <xsl:template match="ead:title">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

</xsl:stylesheet>
