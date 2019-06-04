<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:template name="top_banner" >
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

        <div class="top_banner">
            <div>
                <img style="max-width: 100px;" src="img/{ead:ead/ead:eadheader/ead:eadid/@mainagencycode}.jpg"/>
            </div>
            <h1>
                <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unittitle[@type='primary']"/>
            </h1>
            <h2>
                <xsl:value-of select="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:publisher"/>
            </h2>
            <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:repository" />
            <hr/>
        </div>
    </xsl:template>

    <xsl:template match="/ead:ead/ead:archdesc/ead:did/ead:repository">
        <xsl:for-each select="ead:address/ead:addressline">
            <xsl:value-of select="text()"/><br/>
        </xsl:for-each>
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

</xsl:stylesheet>

