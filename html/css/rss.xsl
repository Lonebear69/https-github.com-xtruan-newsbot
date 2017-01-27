<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="/rss/channel/title" /></title>
      </head>
      <body>
        <div class="heading">
            <h1><xsl:value-of select="/rss/channel/title" /></h1>
            <div><xsl:value-of select="/rss/channel/description" /></div>
            <div><xsl:value-of select="/rss/channel/lastBuildDate" /></div>
        </div><!-- end heading-->
        <div id="items">
        <xsl:for-each select="/rss/channel/item">
          <div class="item">
           <h3 class="header" ><a href="{link}"><xsl:value-of select="title" /></a></h3>
           <div class="pubdate"><xsl:value-of select="pubDate" /></div>
           <div><xsl:value-of select="description" /></div>
          </div><!-- end item (class) -->
        </xsl:for-each>
        </div><!-- end items (ID) -->
    </body>
    </html>
</xsl:template>
</xsl:stylesheet>
