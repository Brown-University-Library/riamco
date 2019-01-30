<?xml version="1.0" encoding="UTF-8"?>
<!--
    This is the XSLT used in the current live RIAMCO
    website to index EADs into Solr.

    In the new site we are doing this via the Ead class
    (see ./app/models/ead.rb)
-->

<!--

    advanced mode: match specific nodes for advanced index/search
    keyword mode: match all nodes for keyword index/search

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="uniqueid" />
    <!-- root -->
    <xsl:template match="/">
        <add>
            <doc>
                <xsl:apply-templates select="ead:ead/ead:eadheader" mode="advanced"/>
                <xsl:apply-templates select="ead:ead/ead:archdesc" mode="advanced"/>
                <xsl:apply-templates select="//ead:abstract" mode="advanced"/>
                <xsl:apply-templates select="//ead:scopecontent/ead:p" mode="advanced"/>
                <field name="keyword">
                    <xsl:apply-templates select="*" mode="keyword"/>
                </field>
            </doc>
        </add>
    </xsl:template>

    <!-- titleproper -->
    <xsl:template match="ead:ead/ead:eadheader" mode="advanced">
        <field name="id"><xsl:value-of select="$uniqueid"/></field>
        <field name="institution_id"><xsl:value-of select="ead:eadid/@mainagencycode"/></field>
        <field name="titleproper"><xsl:value-of select="normalize-space(ead:filedesc/ead:titlestmt/ead:titleproper[1])"/></field>
    </xsl:template>
    <!-- institution name | browse term | year range | language | collection number | title | creator | subject | bioghist name | bioghist -->
    <xsl:template match="ead:ead/ead:archdesc" mode="advanced">
        <!-- added on 10.27.2010 -->
        <field name="institution"><xsl:value-of select="ead:did/ead:repository/ead:corpname/text()"/></field>
        <xsl:for-each select="ead:descgrp/ead:controlaccess/ead:subject[@source='riamco']">
            <field name="browseterm"><xsl:value-of select="text()"/></field>
        </xsl:for-each>

        <!--field name="date">
            <xsl:value-of select="ead:did/ead:unitdate[@type='inclusive']/@normal"/>
        </field-->

        <!-- field name="bulk">
            <xsl:value-of select="ead:did/ead:unitdate[@type='bulk']/@normal"/>
        </field -->


        <!-- Date manipulation-->
    <xsl:for-each select="ead:did/ead:unitdate[@type='inclusive']/@normal">
            <xsl:if test="position() = 1">
                <xsl:variable name="date" select="."/>

                <xsl:if test="string-length($date) &gt;= 4">
                    <xsl:choose>
                        <!-- single year -->
                        <xsl:when test="string-length($date) = 4">
                            <field name="date"><xsl:value-of select="$date"/></field>
                        </xsl:when>
                        <!-- multiple year -->
                        <xsl:otherwise>
                            <xsl:variable name="start2" select="substring(substring-before($date,'/'), 0, 5)"/>
                            <xsl:variable name="end2" select="substring(substring-after($date,'/'), 0, 5)"/>
                            <xsl:if test="$start2 != ''">
                                <field name="start_year"><xsl:value-of select="$start2"/></field>
                            </xsl:if>
                            <xsl:if test="$end2 != ''">
                                <field name="end_year"><xsl:value-of select="$end2"/></field>
                            </xsl:if>

                           <xsl:if test="$end2 != ''">
                                <xsl:variable name="slash2" select="'/'" />
                                <xsl:variable name="joined2" select="concat($start2,$slash2,$end2)"/>
                                <field name="date"><xsl:value-of select="$joined2"/></field>
                           </xsl:if>
                           <xsl:if test="$end2 = ''">
                            <xsl:variable name="joined2" select="concat($start2,$end2)"/>
                                <field name="date"><xsl:value-of select="$joined2"/></field>
                           </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>



        <!-- Bulk Date manipulation-->
        <xsl:for-each select="ead:did/ead:unitdate[@type='bulk']/@normal">
            <xsl:if test="position() = 1">
                <xsl:variable name="bulkdate" select="."/>

                <xsl:if test="string-length($bulkdate) &gt;= 4">
                    <xsl:choose>
                        <!-- single year -->
                        <xsl:when test="string-length($bulkdate) = 4">
                            <field name="bulk"><xsl:value-of select="$bulkdate"/></field>
                        </xsl:when>
                        <!-- multiple year -->
                        <xsl:otherwise>
                            <xsl:variable name="start" select="substring(substring-before($bulkdate,'/'), 0, 5)"/>
                            <xsl:variable name="end" select="substring(substring-after($bulkdate,'/'), 0, 5)"/>

                           <xsl:if test="$end != ''">
                                <xsl:variable name="slash" select="'/'" />
                                <xsl:variable name="joined" select="concat($start,$slash,$end)"/>
                                <field name="bulk"><xsl:value-of select="$joined"/></field>
                           </xsl:if>
                           <xsl:if test="$end = ''">
                            <xsl:variable name="joined" select="concat($start,$end)"/>
                                <field name="bulk"><xsl:value-of select="$joined"/></field>
                           </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>





        <xsl:for-each select="ead:did/ead:langmaterial/ead:language">
            <field name="language"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <field name="unitid"><xsl:value-of select="ead:did/ead:unitid/text()"/></field>
        <field name="title"><xsl:value-of select="ead:did/ead:unittitle[@type='primary']/text()"/></field>
        <field name="filing_title"><xsl:value-of select="ead:did/ead:unittitle[@type='filing']/text()"/></field>
        <xsl:for-each select="ead:did/ead:origination/ead:corpname">
            <field name="creator"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:did/ead:origination/ead:persname">
            <field name="creator"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:did/ead:origination/ead:famname">
            <field name="creator"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="//ead:dsc/ead:c/ead:did/ead:origination/ead:persname">
            <field name="creator"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="//ead:dsc/ead:c/ead:did/ead:origination/ead:corpname">
            <field name="creator"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="//ead:dsc/ead:c/ead:did/ead:origination/ead:famname">
            <field name="creator"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:descgrp/ead:controlaccess/ead:persname">
            <field name="subject"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:descgrp/ead:controlaccess/ead:corpname">
            <field name="subject"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:descgrp/ead:controlaccess/ead:famname">
            <field name="subject"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:descgrp/ead:controlaccess/ead:geogname">
            <field name="subject"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:descgrp/ead:controlaccess/ead:subject">
            <field name="subject"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:descgrp/ead:controlaccess/ead:title">
            <field name="subject"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:descgrp/ead:controlaccess/ead:genreform">
            <field name="subject"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:descgrp/ead:controlaccess/ead:occupation">
            <field name="subject"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:descgrp/ead:controlaccess/ead:function">
            <field name="subject"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="//ead:dsc/ead:c/ead:controlaccess/ead:persname">
            <field name="subject"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="//ead:dsc/ead:c/ead:controlaccess/ead:corpname">
            <field name="subject"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="//ead:dsc/ead:c/ead:controlaccess/ead:famname">
            <field name="subject"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="//ead:dsc/ead:c/ead:controlaccess/ead:subject">
            <field name="subject"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="//ead:dsc/ead:c/ead:controlaccess/ead:genreform">
            <field name="subject"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:bioghist/ead:persname">
            <field name="bioghistname"><xsl:value-of select="normalize-space(.)"/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:bioghist/ead:corpname">
            <field name="bioghistname"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:bioghist/ead:famname">
            <field name="bioghistname"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:bioghist/ead:p">
            <field name="bioghist"><xsl:value-of select="."/></field>
        </xsl:for-each>
        <xsl:for-each select="ead:did/ead:physdesc/ead:extent">
            <field name="extent"><xsl:value-of select="."/></field>
        </xsl:for-each>
    </xsl:template>
    <!-- abstract -->
    <xsl:template match="//ead:abstract" mode="advanced">
        <field name="abstract"><xsl:value-of select="text()"/></field>
    </xsl:template>
    <!-- scopecontent -->
    <xsl:template match="//ead:scopecontent/ead:p" mode="advanced">
        <xsl:for-each select=".">
            <field name="scopecontent"><xsl:value-of select="text()"/></field>
        </xsl:for-each>
    </xsl:template>
    <!-- keyword -->
    <xsl:template match="text()" mode="keyword">
        <xsl:if test="normalize-space(.) !=''">
            <xsl:value-of select="."></xsl:value-of>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
