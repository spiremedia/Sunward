<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" media-type="text/html" method="html" omit-xml-declaration="yes" encoding="UTF-8" version="1.0" standalone="no" />
    <xsl:param name="action" select="''" />
    <xsl:param name="method" select="'post'" />
    <xsl:param name="formclass" select="'userform'" />
    <xsl:param name="enctype" select="'application/x-www-form-urlencoded'" />
    <xsl:param name="formId" />
    <xsl:param name="submitName" select="'submit'" />
    <xsl:param name="submitValue" select="'Submit'" />
    <xsl:param name="fieldNameBase" select="'field_'" />
    <xsl:param name="fieldIdBase" select="'field_'" />
    <xsl:param name="labelSelectEllipses" select="'Select&amp;hellip;'" />
    <xsl:template match="/ul[count(li) &gt; 0]">
        <xsl:element name="form">
            <xsl:attribute name="action">
                <xsl:value-of select="$action" />
            </xsl:attribute>
            <xsl:attribute name="method">
                <xsl:value-of select="$method" />
            </xsl:attribute>
            <xsl:attribute name="enctype">
                <xsl:value-of select="$enctype" />
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:value-of select="$formclass" />
            </xsl:attribute>
   
			<xsl:for-each select="li">
				<xsl:element name="p">
					<xsl:element name="label">
						<xsl:attribute name="for">
							<xsl:value-of select="concat($fieldIdBase, position())" />
						</xsl:attribute>
						<xsl:if test="p/input[@type='checkbox' and @name='required']/@checked != ''">
							<xsl:attribute name="class">required</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="dl/dt/span/text()" />
					</xsl:element>
					<xsl:choose>
						<!-- text input -->
						<xsl:when test="contains(dl/dd/img/@src, 'text.gif')">
							<xsl:call-template name="input" />
						</xsl:when>
						<!--  textarea -->
						<xsl:when test="contains(dl/dd/img/@src, 'textarea.gif')">
							<xsl:call-template name="textArea" />
						</xsl:when>
						<!-- select box -->
						<xsl:when test="contains(dl/dd/img/@src, 'select.gif')">
							<xsl:call-template name="selectBox" />
						</xsl:when>
						<!-- check box group -->
						<xsl:when test="contains(dl/dd/img/@src, 'checkbox.gif')">
							<xsl:call-template name="inputGroup">
								<xsl:with-param name="type" select="'checkbox'" />
							</xsl:call-template>
						</xsl:when>
						<!-- radio button group -->
						<xsl:when test="contains(dl/dd/img/@src, 'radio.gif')">
							<xsl:call-template name="inputGroup">
								<xsl:with-param name="type" select="'radio'" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<!-- 
					///
					/// Label Form Field for Processing script
					///
					-->
					<xsl:call-template name="input">
						<xsl:with-param name="type" select="'hidden'" />
						<xsl:with-param name="size" select="''" />
						<xsl:with-param name="maxlength" select="''" />
						<xsl:with-param name="name" select="concat($fieldNameBase, 'label_', position())" />
						<xsl:with-param name="id" select="''" />
						<xsl:with-param name="value" select="dl/dt/span/text()" />
					</xsl:call-template>
				</xsl:element>
			</xsl:for-each>
			<xsl:element name="p">
				<xsl:attribute name="class">clear</xsl:attribute>
				<xsl:comment>Leave Empty</xsl:comment>
			</xsl:element>
			<xsl:element name="p">
				<xsl:call-template name="input">
					<xsl:with-param name="id" />
					<xsl:with-param name="size" />
					<xsl:with-param name="maxlength" />
					<xsl:with-param name="name" select="$submitName" />
					<xsl:with-param name="value" select="$submitValue" />
					<xsl:with-param name="type" select="'submit'" />
				</xsl:call-template>
				<xsl:call-template name="input">
					<xsl:with-param name="id" />
					<xsl:with-param name="size" />
					<xsl:with-param name="maxlength" />
					<xsl:with-param name="type" select="'hidden'" />
					<xsl:with-param name="name" select="'formid'" />
					<xsl:with-param name="value" select="$formId" />
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="p">
				<xsl:attribute name="class">clear</xsl:attribute>
				<xsl:comment>Leave Empty</xsl:comment>
			</xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- 
    ///
    /// Named Templates
    ///
    -->
    <!-- input
            (
                string $type = 'text',
                string $name = $fieldNameBase + position(), 
                string $id = fieldIdBase + position(), 
                string $maxlength = '255', 
                string $size = '30'
            )
            sample output::
            <input type="{$type}" name="{$name}" id="{$id}" maxlength="{$maxlength}" size="{$size}" />
        -->
    <xsl:template name="input">
        <xsl:param name="type" select="'text'" />
        <xsl:param name="name" select="concat($fieldNameBase, position())" />
        <xsl:param name="id" select="concat($fieldIdBase, position())" />
        <xsl:param name="maxlength" select="'255'" />
        <xsl:param name="size" select="'30'" />
        <xsl:param name="value" select="''" />
        <xsl:element name="input">
            <xsl:if test="$type != '' ">
                <xsl:attribute name="type">
                    <xsl:value-of select="$type" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$name != '' ">
                <xsl:attribute name="name">
                    <xsl:value-of select="$name" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$id != '' ">
                <xsl:attribute name="id">
                    <xsl:value-of select="$id" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$maxlength != '' ">
                <xsl:attribute name="maxlength">
                    <xsl:value-of select="$maxlength" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$size != '' ">
                <xsl:attribute name="size">
                    <xsl:value-of select="$size" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$value != ''">
                <xsl:attribute name="value">
                    <xsl:value-of select="$value" />
                </xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <!-- textArea
            (
                string $name = $fieldNameBase + position(), 
                string $id = fieldIdBase + position(),
                string $rows = '2',
                string $cols = '44'
            ) 
        sample output::
        <textarea name="{$name}" id="{$id}" rows="[$rows]" cols="[$cols]"></textarea>
    -->
    <xsl:template name="textArea">
        <xsl:param name="name" select="concat($fieldNameBase, position())" />
        <xsl:param name="id" select="concat($fieldIdBase, position())" />
        <xsl:param name="rows" select="'6'" />
        <xsl:param name="cols" select="'20'" />
        <xsl:element name="textarea">
            <xsl:if test="$name != ''">
                <xsl:attribute name="name">
                    <xsl:value-of select="$name" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$id != ''">
                <xsl:attribute name="id">
                    <xsl:value-of select="$id" />
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="rows">
                <xsl:value-of select="$rows" />
            </xsl:attribute>
            <xsl:attribute name="cols">
                <xsl:value-of select="$cols" />
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <!-- selectBox
            (
                string $name = $fieldNameBase + position(), 
                string $id = fieldIdBase + position(),
                nodeList $option = dl/dd/div/span/text()
            )
            sample output::
            <select name="{$name}" id="{$id}">
                <option>Select&hellip;</option>
                <option>{$option[1]}</option>
                <option>{$option[2]}</option>
                ...
            </select>
        -->
    <xsl:template name="selectBox">
        <xsl:param name="name" select="concat($fieldNameBase, position())" />
        <xsl:param name="id" select="concat($fieldIdBase, position())" />
        <xsl:param name="option" select="dl/dd/div/span/text()" />
        <xsl:element name="select">
            <xsl:if test="$name != ''">
                <xsl:attribute name="name">
                    <xsl:value-of select="$name" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$id != ''">
                <xsl:attribute name="id">
                    <xsl:value-of select="$id" />
                </xsl:attribute>
            </xsl:if>
            <xsl:element name="option">
                <xsl:attribute name="value" />
                <xsl:value-of select="$labelSelectEllipses" disable-output-escaping="yes" />
            </xsl:element>
            <xsl:for-each select="$option">
                <xsl:element name="option">
                    <xsl:value-of select="." />
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <!-- inputGroup
            (
                string $type = 'checkbox',
                string $name = $fieldNameBase + position(),
                nodeList $input = dl/dd/span/text()
            ) 
            sample output::
            <input type="[$type]" name="{$name}" value="{$input[1]}" /> <span>{$input[1]}</span><br />
            <input type="[$type]" name="{$name}" value="{$input[2]}" /> <span>{$input[2]}</span><br />
            ...
    -->
    <xsl:template name="inputGroup">
        <xsl:param name="type" select="'checkbox'" />
        <xsl:param name="name" select="concat($fieldNameBase, position())" />
        <xsl:param name="input" select="dl/dd/span/text()" />
        <xsl:for-each select="$input">
            <xsl:call-template name="input">
                <xsl:with-param name="name" select="$name" />
                <xsl:with-param name="id" select="''" />
                <xsl:with-param name="type" select="$type" />
                <xsl:with-param name="maxlength" select="''" />
                <xsl:with-param name="size" select="''" />
                <xsl:with-param name="value" select="." />
            </xsl:call-template>
			 <xsl:value-of select="' '"  />
            <xsl:element name="span">
                <xsl:value-of select="." />
            </xsl:element>
            <xsl:value-of select="' '"  />
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
