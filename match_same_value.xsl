<!-- problem encounter: match @xml:id to @target, then display text() -->

<-- TEI example -->
<!-- in <teiHeader> -->
<encodingDesc>
         <classDecl>
            <taxonomy xml:id="abbrev">
               <desc>Grammar abbreviations</desc>
               <!-- other <category> -->
               <category n="5" xml:id="abb-tns" ana="#tense">
                  <catDesc>Tense</catDesc>
                  <category n="1" ana="#tns.perf #tense"><desc><ref target="#cit.perf">perfective</ref></desc></category>
                  <category n="2" ana="#tns.imperf #tense"><desc><ref target="#cit.imperf">imperfective</ref></desc></category>
               </category>
               <!-- other <category> -->
             </taxonomy>
           </classDescl>
 </encodingDesc>    
 
 <!-- in <text> -->
 
 <div ana="#abbrev" xml:id="abbrev-annot">
           <!-- other <cit> -->
            <cit ana="#tns.perf" xml:id="cit.perf">
               <quote n="1">[...] for practical reasons, be rendered by a past tense of verbs which express action or
               by the present of verbs which express a state.
                  <bibl><ref target="bibliography.html#bib-ling-001">Lipiński</ref>, 2001:343</bibl></quote>
               <quote n="2">[...] indicating
                  basically that a process has not reached completion at a certain moment of time. It may also indicate that an activity is in progress
                  or a state is being entered upon under the influence of another activity or state. This information can be translate in European
                  languages by a present, a future, a future perfect, an imperfect [...]<bibl><ref target="bibliography.html#bib-ling-001">id.</ref></bibl></quote>
            </cit>
            <cit ana="#tns.imperf" xml:id="cit.imperf">
               <quote n="1">blablabla</quote>
            </cit>
           <!-- other <cit> -->
         </div>


<!-- XSLT version 3.0, Saxon 9.7  --> 
<xsl:key name="abbrev-category" match="category[@n]" use="@n" />
<xsl:key name="cit-abbrev" match="div/cit[@xml:id]" use="@xml:id"/>
         
         
<xsl:template match="/" >
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="verb.css"/>
            </head>
            <body>
                <xsl:copy-of select="document('menu.html')"/>
                <div id="content">
                    <xsl:apply-templates select="//div[@xml:id='abbrev-annot']"/>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- afficher note si cit[@ana] = category[@ana]  -->
    <xsl:template match="div[@xml:id='abbrev-annot']">
        <a href="#" id="abbrev"><h2>(Annotated) abbreviations</h2></a>
        <div id="abbrev">
            <xsl:apply-templates select="..//preceding::taxonomy/category[@xml:id]"/>
        </div>
        <a href="#" id="grammar"><h2 >Grammar summary</h2></a>
        <xsl:apply-templates/>
    </xsl:template>
    
   
    <xsl:template match="taxonomy/category[@xml:id]">
        <xsl:for-each select=".[@n]" >
            <h3><xsl:value-of select="catDesc"/></h3>
                <ul>
                   <xsl:for-each select="category[@ana]">
                      <li>
                          <xsl:value-of select="substring-before(substring-after(@ana, '.'), ' #')"/><xsl:text>: </xsl:text>
                          <xsl:if test="desc/ref/text()">
                              <a href="#{desc/ref/tokenize(translate(@target, '#', ''))}" name="{@target}" id="{@target}" class="target-cit"><xsl:value-of select="desc/ref/text()"/></a><!-- backlink ne fonctionne pas -->
                          </xsl:if>
                          <xsl:if test="desc/text()">
                              <xsl:value-of select="."/>
                          </xsl:if>
                      </li>
                    </xsl:for-each>
                </ul>            
         </xsl:for-each> 
    </xsl:template>
    
   <xsl:template match="cit[@ana]">
        <xsl:variable name="abbrev-category" select="key('abbrev-category', @n)/desc/ref"/>
        <xsl:variable name="cit-abbrev" select="key('cit-abbrev', @xml:id)"/>
        <xsl:variable name="referenced-abbrev-target" select="key('cit-abbrev', @xml:id || translate(@target, '#', ''), $cit-abbrev)/text() "/>
        <xsl:for-each select=".">
            <xsl:value-of select="$referenced-abbrev-target"/>
            <a name="{@xml:id}" href="javascript:history.back(1)" id="{@xml:id}" class="ref-target-cit"><h3><xsl:value-of select="substring-after(@ana, '.')"/>
                <xsl:value-of select="$referenced-abbrev-target"/> <!-- I want to display "perfective" for example in <desc><ref target="#f">perfective</ref></desc> -->
                <xsl:text> &#8617;</xsl:text></h3></a>
            <xsl:apply-templates/>
        </xsl:for-each> 
    
    <xsl:template match="quote">
        <ul style="margin-top: 0">
            <xsl:for-each select=".">
                <li style="list-style-type: none; margin-top: 0">
                    <xsl:value-of select="concat(./@n, ': ', ./text()[1])"/><xsl:text>(</xsl:text><a href="{child::bibl/ref/@target}"><xsl:value-of select="child::bibl"/></a><xsl:text>)</xsl:text>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
