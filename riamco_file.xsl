<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ns2="http://www.w3.org/1999/xlink">
    <xsl:strip-space elements="ead:*"/>
    <xsl:output method="html" indent="yes"/>
    <xsl:param name="eadid">
        <xsl:value-of select="/ead:ead/ead:eadheader/ead:eadid"/>
    </xsl:param>

    <xsl:include href="riamco_nav1.xsl" />
    <xsl:include href="riamco_html_title.xsl" />
    <xsl:include href="riamco_ga.xsl" />
    <xsl:include href="riamco_top_banner_item.xsl" />

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
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
                                <xsl:call-template name="top_banner_item" />

                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:dsc"/>

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


                <script type="text/javascript">
                    $(function() {
                        // If we get an inventory ID in the "fragment identifier" of the URL
                        // (the stuff after the # sign)...
                        var id = window.location.toString().split("#")[1];
                        if (id === undefined) {
                            // no inventory id received
                            return;
                        }

                        // ...highlight the "wrapper" for that inventory ID.
                        var el = document.getElementById(id + "_wrapper");
                        if (el != null) {
                            // light yellow
                            el.style = "background-color: #F3F5B3;"
                        }
                    });
                </script>

            </body>
        </html>
    </xsl:template>



    <xsl:template match="ead:c">
        <xsl:if test="@level='series' or @level='subgrp'">
            <xsl:call-template name="series"/>
        </xsl:if>
        <xsl:if test="@level='subseries'">
            <xsl:call-template name="subseries"/>
        </xsl:if>
        <xsl:if test="@level='item' and @id='20ProspectStProvidenceRI02912'">
            <xsl:call-template name="item"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="series">
       <div class="series">

         <xsl:apply-templates select="child::ead:c[@level='file' or @level='item']"/>


       </div>
    </xsl:template>

    <xsl:template name="subseries">
        <xsl:variable name="inventory_id" select="./@id" />
        <a name="{$inventory_id}" id="{$inventory_id}"></a>
        <p id = "{$inventory_id}_wrapper">
            <span class="indent_1">
                <strong>
                    <xsl:apply-templates select="ead:did/ead:unitid[@type='subseries']"/>
                    <xsl:choose>
                        <xsl:when test="ead:dao[@ns2:role='METSID']">
                            <u>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>data/</xsl:text><xsl:value-of select="ead:dao/@ns2:href"/>

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
                                        <xsl:text>data/</xsl:text><xsl:value-of select="ead:dao[@ns2:role='BDR_PID']/@ns2:href"/>

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
            <table class="table_inventory">
                <tr class="table_section_header">
                    <td class="col_container">Container</td>
                    <td class="col_dummy"></td>
                    <td class="col_description">Description</td>
                    <td class="col_dummy"/>
                    <td class="col_date">Date</td>
                </tr>
                <xsl:apply-templates select="child::ead:c"/>
            </table>
        </xsl:if>
    </xsl:template>


    <xsl:template name="item">
        <xsl:variable name="inventory_id" select="./@id" />
        <!--
            The table should be at the (outer) container level,
            in this case at the Series level, not on each individual item!
            <table class="table_inventory" id="{$inventory_id}_wrapper">
            </table>
        -->
        <xsl:choose>
            <xsl:when test="ead:c[@id='c1']">
                <tr class="table_section_header" id="{$inventory_id}_wrapper">
                    <td class="col_container">Container</td>
                    <td class="col_dummy"><a name="{$inventory_id}" id="{$inventory_id}"></a></td>
                    <td class="col_description">Description</td>
                    <td class="col_dummy"/>
                    <td class="col_date">Date</td>
                </tr>
                <xsl:apply-templates select="ead:c"/>
            </xsl:when>
            <xsl:otherwise>
                <tr id="{$inventory_id}_wrapper">
                    <td class="col_container" valign="top">
                        <xsl:apply-templates select="ead:did/ead:container"/>
                    </td>
                    <td class="col_dummy" valign="top"><a name="{$inventory_id}" id="{$inventory_id}"></a></td>
                    <td class="col_description" valign="top">

                        <!-- Just for Birri Pinturas collection -->
                        <xsl:if test="ead:odd[@type='Birriproject']">
                            <b><xsl:text>Birri Project: </xsl:text></b>
                            <b><xsl:apply-templates select="ead:odd/ead:p"/></b>
                            <br/>
                        </xsl:if>
                        <br/>
                        <h3><b><xsl:apply-templates select="ead:did/ead:unittitle"/></b></h3>

                        <br/>
                        <xsl:if test="ead:did/ead:physdesc/ead:extent">
                            <xsl:apply-templates select="ead:did/ead:physdesc/ead:extent"/>
                            <br/>
                        </xsl:if>

                        <xsl:if test="ead:scopecontent/ead:p">

                            <xsl:copy-of select="ead:scopecontent"/>
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

                        <xsl:if test="ead:acqinfo/ead:p/ead:num[@type='Accession' or @type='accession']">
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

                    <td class="col_dummy" valign="top"/>

                    <td class="col_date" valign="top">
                        <xsl:apply-templates select="ead:did/ead:unitdate"/>
                    </td>
                </tr>
                <embed>
                  <xsl:attribute name="src">
                      <xsl:text>data/</xsl:text><xsl:value-of select="ead:dao[@ns2:role='NORMALIZEDFILE_ID']/@ns2:href"/>

                  </xsl:attribute>
                  <xsl:attribute name="width">95%</xsl:attribute>
                  <xsl:attribute name="height">100%</xsl:attribute>
                </embed>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="child::ead:c[@level='file' or @level='item']">
            <xsl:apply-templates select="child::ead:c[@level='file' or @level='item']"/>
        </xsl:if>

    </xsl:template> <!-- item -->

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
        <xsl:choose>
            <xsl:when test="contains(@label, '[')">
                <!-- do not display the barcode -->
                <xsl:value-of select="substring-before(@label, ' [')"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@label"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
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
