<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:param name="eadid">
        <xsl:value-of select="/ead:ead/ead:eadheader/ead:eadid"/>
    </xsl:param>

    <xsl:include href="riamco_nav1.xsl" />
    <xsl:include href="riamco_html_title.xsl" />
    <xsl:include href="riamco_ga.xsl" />

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

                                <!-- this is duplicated in riamco_top_banner.xsl -->
                                <div class="top_banner_right">
                                    <div class="panel">
                                        <div class="panel-heading">
                                            <h3>Need Help?</h3>
                                        </div>
                                        <div class="panel-body">
                                            <ul class="list-unstyled">
                                                <li><a href="//riamco.org/search">Search</a></li>
                                                <li><a href="//riamco.org/faq" title="Frequently Asked Questions about this site">FAQ</a></li>
                                                <li><a href="//riamco.org/contact" title="Information on how to contact a member institution">Contact an Institution</a></li>
                                                <li><a href="//riamco.org/resources_other">Other Resources</a></li>
                                            </ul>
                                        </div> <!-- panel body -->
                                    </div> <!-- panel -->
                                    <div class="panel">
                                        <div class="panel-heading">
                                            <h3>For Participating Institutions</h3>
                                        </div>
                                        <div class="panel-body">
                                            <ul class="list-unstyled">
                                                <li><a href="//riamco.org/join" title="Become a Participating Institution">Join RIAMCO</a></li>
                                                <li><a href="https://library.brown.edu/riamco_admin/login/?next=/riamco_admin/" title="Login to deposit new finding aids">Log-in</a></li>
                                                <li><a href="//riamco.org/resources">Resources</a></li>
                                            </ul>
                                        </div> <!-- panel body -->
                                    </div> <!-- panel -->
                                </div> <!-- top_banner_right -->

                                <div>
                                    <h1>
                                    <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper"/>
                                    <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:date/@inclusive"/>
                                    <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:date/@bulk"/>
                                    </h1>
                                </div>
                                <div>
                                    <img src="img/{ead:ead/ead:eadheader/ead:eadid/@mainagencycode}.jpg"/>
                                    <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:repository"/>
                                    <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:publisher"/>
                                </div>
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


    </xsl:stylesheet>
