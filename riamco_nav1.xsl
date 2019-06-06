<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:param name="eadid">
        <xsl:value-of select="/ead:ead/ead:eadheader/ead:eadid"/>
    </xsl:param>

    <!-- access points -->
    <xsl:param name="ap_person">
        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:persname">yes</xsl:if>
    </xsl:param>

    <xsl:param name="ap_corporation">
        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:corpname">yes</xsl:if>
    </xsl:param>

    <xsl:param name="ap_subject">
        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:subject">yes</xsl:if>
    </xsl:param>

    <xsl:param name="ap_genre">
        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:genreform">yes</xsl:if>
    </xsl:param>

    <xsl:param name="ap_occupation">
        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='cataloging']/ead:controlaccess/ead:occupation">yes</xsl:if>
    </xsl:param>
<xsl:template name="nav_template" >

<div class="nav_column">
    <h3>Table of Contents</h3>
    <ul class="nav_section">
        <li>
            <a class="toc_link" href="render.php?eadid={$eadid}&amp;view=title">Title</a>
        </li>
        <li>
            <a class="toc_link" href="render.php?eadid={$eadid}&amp;view=overview">Collection overview</a>
        </li>
        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:scopecontent">
            <li>
                <a class="toc_link" href="render.php?eadid={$eadid}&amp;view=scope">Scope &amp; content</a>
            </li>
        </xsl:if>
        <xsl:if test="$ap_person = 'yes' or $ap_corporation = 'yes' or $ap_subject = 'yes' or $ap_genre = 'yes' or $ap_occupation = 'yes'">
            <li>
                <a class="toc_link" href="render?eadid={$eadid}&amp;view=access_points">Access Points</a>
            </li>
        </xsl:if>
        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:arrangement">
            <li>
                <a class="toc_link" href="render.php?eadid={$eadid}&amp;view=arrangement">Arrangement</a>
            </li>
        </xsl:if>
        <xsl:if test="/ead:ead/ead:archdesc/ead:bioghist">
            <li>
                <a class="toc_link" href="render.php?eadid={$eadid}&amp;view=biography">Biographical/Historical note</a>
            </li>
        </xsl:if>
        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp/ead:accessrestrict">
            <li>
                <a class="toc_link" href="render.php?eadid={$eadid}&amp;view=access">Access &amp; use</a>
            </li>
        </xsl:if>
        <xsl:if test="(/ead:ead/ead:archdesc/ead:descgrp[@type='administrative']) or (/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:author) or (/ead:ead/ead:eadheader/ead:profiledesc/ead:creation)">
            <li>
                <a class="toc_link" href="render.php?eadid={$eadid}&amp;view=administrative">Administrative information</a>
            </li>
        </xsl:if>
        <xsl:if test="/ead:ead/ead:archdesc/ead:descgrp[@type='additional']">
            <li>
                <a class="toc_link" href="render.php?eadid={$eadid}&amp;view=addinfo">Additional information</a>
            </li>
        </xsl:if>
        <xsl:if test="/ead:ead/ead:archdesc/ead:dsc">
            <li>
                <a class="toc_link" href="render.php?eadid={$eadid}&amp;view=inventory">Inventory</a>
                <xsl:if test="/ead:ead/ead:archdesc/ead:dsc/ead:c[@level='series']">
                    <ul class="nav_inv_series">
                        <xsl:for-each select="/ead:ead/ead:archdesc/ead:dsc/ead:c[@level='series']">
                            <xsl:variable name="toc_id" select="./@id" />
                            <li>
                                <a class="toc_link" href="render.php?eadid={$eadid}&amp;view=inventory#{$toc_id}">
                                    <xsl:value-of select="./ead:did/ead:unitid[@type!='Archivists Toolkit Database::RESOURCE_COMPONENT']"/>&#160;
                                    <xsl:value-of select="./ead:did/ead:unittitle"/>&#160;
                                    <xsl:value-of select="./ead:did/ead:unitdate"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
    </ul>

    <h3>View Options</h3>
    <ul class="nav_section">
        <li>
            <a href="download?eadid={$eadid}" target="_blank" title="Download the XML for this finding aid">Download XML</a>
        </li>
        <li>
            <a href="render.php?eadid={$eadid}&amp;view=all" target="_blank" title="View all the information for this finding aid in a single page">View All (printer friendly)</a>
        </li>
    </ul>
</div>

<script type="text/javascript">
    $(function() {
        if (window.location.toString().indexOf("render_pending") == -1) {
            // nothing to do
            return;
        }

        // Make sure the Table of Contents links point to "render_pending"
        // rather than "render"
        //
        // Notice that we need to disable escaping to insert the "less than"
        // operator in the for loop expression because we are inside an XML/
        // XSTL document.
        //
        var links = document.getElementsByClassName("toc_link");
        var i;
        for(i = 0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> links.length; i++) {
            links[i].href = links[i].href.replace("render.php?","render_pending?");
            links[i].href = links[i].href.replace("render?","render_pending?")
        }
    });
</script>

</xsl:template>

</xsl:stylesheet>

