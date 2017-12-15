<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE stylesheet [
 <!ENTITY menu SYSTEM "corpus.xml"> 


]> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">
<xsl:output method="html" encoding="utf-8" doctype-system="about:legacy-compat"/>
<!-- delete extra blank lines -->
<xsl:strip-space elements="*"/>

<xsl:template match="/">
 <html>
  <head/>
  <body>
   <ul>
    <xsl:apply-templates select="descendant::taxonomy[2]/category[4]"/>
   </ul>
  </body>
 </html>
</xsl:template>

<xsl:key name="w" match="w[@type='verb']" use="tokenize(@ana, ' ')" />
 
<xsl:template match="taxonomy[2]/category[4]">
<!-- several other 'xsl:for-each' within <ul> before the following <ul> --> 
<!-- each verb related to a sub-category ('category/category') in TEI -->
<ul>
 <xsl:for-each select="following-sibling::category/equiv[@n]">
  <li>
  <!-- @uri = @xml:id in TEI -->
    <xsl:variable name="href"><xsl:value-of select="@uri"/></xsl:variable>
    <a href="{$href}"> 
     <xsl:value-of select="./@*[namespace-uri()='http://www.w3.org/XML/1998/namespace' and local-name()='id']"/></a>:
    <xsl:for-each select="key('w', concat('#', @xml:id))">
     <!-- @xml:id in TEI -->
     <xsl:variable name="href"><xsl:value-of select="@xml:id"/></xsl:variable>
      <xsl:text> (</xsl:text><a href="{$href}"> 
      <xsl:value-of select="./@*[namespace-uri()='http://www.w3.org/XML/1998/namespace' and local-name()='id']" /></a><xsl:text>)</xsl:text><!-- <xsl:if test="position() != last()"> -->
      <xsl:text>, </xsl:text> 
     <!-- select only characters in @xml:id after last '_': <xsl:value-of select="substring-after-last('_')"/> doesn't work -->
     </xsl:for-each>
    </xsl:for-each>
   </li>
  </xsl:for-each>
 </ul>
 </xsl:template>
</xsl:stylesheet>
