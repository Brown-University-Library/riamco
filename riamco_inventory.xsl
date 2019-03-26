<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ns2="http://www.w3.org/1999/xlink">
    <xsl:strip-space elements="ead:*"/>
    <xsl:output method="html" indent="yes"/>
    <xsl:param name="eadid">
        <xsl:value-of select="/ead:ead/ead:eadheader/ead:eadid"/>
    </xsl:param>

    <xsl:include href="riamco_nav1.xsl" />
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>RIAMCO &#160;&#124;&#160; Rhode Island Archival and Manuscript Collections Online</title>
                <link href="css/riamco.css" rel="stylesheet" type="text/css"/>
                <link href="css/inventory.css" rel="stylesheet" type="text/css"/>
                <link rel="shortcut icon" type="image/x-icon" href="favicon.png" />
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
                                        <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unittitle[@type='primary']"/>
                                    </a>
                                </h1>
                                <h3>Inventory</h3>

                                <hr/>

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

