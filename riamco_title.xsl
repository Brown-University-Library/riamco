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

<xsl:call-template name="nav_template" />




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
