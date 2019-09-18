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
                                <h3>Access Points</h3>
                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess"/>
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

    <xsl:template match="ead:controlaccess">
        <xsl:if test="./ead:persname">
            <b>Subject Names</b>
            <ul>
                <xsl:for-each select="./ead:persname">
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>https://www.riamco.org/search?fq=subjects_ss|</xsl:text><xsl:value-of select="text()"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>

        <xsl:if test="./ead:corpname">
            <b>Subject Organizations</b>
            <ul>
                <xsl:for-each select="./ead:corpname">
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>https://www.riamco.org/search?fq=subjects_ss|</xsl:text><xsl:value-of select="text()"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>

        <xsl:if test="./ead:subject">
            <b>Subject Topics</b>
            <ul>
                <xsl:for-each select="./ead:subject">
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>https://www.riamco.org/search?fq=subjects_ss|</xsl:text><xsl:value-of select="text()"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>

        <xsl:if test="./ead:genreform">
            <b>Document Types</b>
            <ul>
                <xsl:for-each select="./ead:genreform">
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>https://www.riamco.org/search?fq=subjects_ss|</xsl:text><xsl:value-of select="text()"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>

        <xsl:if test="./ead:occupation">
            <b>Occupations</b>
            <ul>
                <xsl:for-each select="./ead:occupation">
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>https://www.riamco.org/search?fq=subjects_ss|</xsl:text><xsl:value-of select="text()"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>

        <xsl:if test="./ead:geogname">
            <b>Geographical Names</b>
            <ul>
                <xsl:for-each select="./ead:geogname">
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>https://www.riamco.org/search?fq=subjects_ss|</xsl:text><xsl:value-of select="text()"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
