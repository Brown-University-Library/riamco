<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:template name="top_banner_item" >
        

        <div class="top_banner">
            <div>
                <img style="max-height: 100px;" src="img/{ead:ead/ead:eadheader/ead:eadid/@mainagencycode}.jpg"/>
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

