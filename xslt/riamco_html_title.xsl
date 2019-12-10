<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink">
<xsl:template name="html_title_template" >
    <xsl:choose>
        <xsl:when test="/ead:ead/ead:archdesc/ead:did/ead:unittitle[@type='primary']">
            <title>
                <xsl:value-of select="/ead:ead/ead:archdesc/ead:did/ead:unittitle[@type='primary']"/>
            </title>
        </xsl:when>
        <xsl:otherwise>
            <title>RIAMCO</title>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
</xsl:stylesheet>

