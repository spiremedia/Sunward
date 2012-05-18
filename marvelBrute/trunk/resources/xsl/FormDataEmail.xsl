<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:fd="http://2006.platform.spiremedia.com/resources/xsd/platform2006/FormData1.0">
    <xsl:output indent="no" media-type="text/html" method="html" version="4.01" />
    <xsl:param name="labelDate" select="'Date'" />
    <xsl:param name="columnDelim" select="'&#09;'" />
    <xsl:param name="rowDelim" select="'&#13;'" />
    <xsl:param name="textQualifier" select="'&quot;'" />
    <xsl:param name="writeColumnHeadings" select="'true'" />
    <!-- 
    ///
    /// Node Templates
    ///
    -->
    <xsl:template match="/">
        <xsl:for-each select="fd:formdata/submission[last()]">
            <xsl:call-template name="submissionRow" />
        </xsl:for-each>
    </xsl:template>
    <!-- 
    ///
    /// Name Templates
    ///
    -->
    <xsl:template name="columnHeadings">
        <xsl:if test="$writeColumnHeadings = 'true'">
            <xsl:for-each select="fd:formdata/submission[1]/field">
                <xsl:value-of select="concat(@label, $columnDelim)" />
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="submissionRow">
        <xsl:param name="submission" select="." />
        <xsl:for-each select="$submission/field">
            <xsl:value-of select="concat(@label, ': ', $rowDelim)" disable-output-escaping="yes" />
            <xsl:element name="br" />
            <xsl:value-of select="concat( text(), $rowDelim)" disable-output-escaping="yes" />
            <xsl:element name="br" />
            <xsl:element name="br" />
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
