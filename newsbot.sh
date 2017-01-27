#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INPUT=$DIR/feed_urls.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

liveIndexFile=$DIR/html/index.html
newIndexFile=$DIR/html/new_index.html
feedXslFile=$DIR/html/css/feed.xsl

date=`date`
echo "<!DOCTYPE html><html><head><title>Newsbot</title><link rel=\"stylesheet\" href=\"css/feed.css\"></head><body>" > $newIndexFile
echo "<div id=\"explanation\"><h1>Newsbot - Lightweight News Reader</h1><p>Newsbot generated this snapshot at $date.</p></div>" >> $newIndexFile
echo "<div class=\"content\"><ul>" >> $newIndexFile

while read aFile aName aUrl
do
	# debug text
	aXmlFile="$DIR/html/$aFile.xml"
	aHtmlFile="$DIR/html/$aFile.html"
	aHtmlFileUrl="$DIR/$aFile.html"
	aNoImgHtmlFile="$DIR/html/noimg_$aFile.html"
	aNoImgHtmlFileUrl="$DIR/noimg_$aFile.html"
	
	echo "File : $aXmlFile"
	echo "Name : $aName"
	echo "URL : $aUrl"
	
	# make xml docs
	date=`date`
	start=`date +%s`
	# call full-text-rss with php-cgi to dump xml file
	php-cgi -f $DIR/full-text-rss/makefulltextfeed.php url="$aUrl" max=10 links=preserve > $aXmlFile
	end=`date +%s`
	runtime=$((end-start))
	sed -i '$ d' $aXmlFile
	echo "<newsbot><date>$date</date><runtime>$runtime</runtime></newsbot>" >> $aXmlFile
	echo "</rss>" >> $aXmlFile
	# convert xml to html using xslproc and feed.xml
	xsltproc $feedXslFile $aXmlFile -o $aHtmlFile
	# add html doc to index
	echo "<div class=\"article\"><li><a href=$aHtmlFileUrl>$aName</a></li></div>" >> $newIndexFile
	
	# strip images/videos from xml docs
	sed 's/<img/<br/g' $aHtmlFile > $aNoImgHtmlFile
	sed -i 's/<\/img/<\/br/g' $aNoImgHtmlFile
	sed -i 's/<video/<br/g' $aNoImgHtmlFile
	sed -i 's/<\/video/<\/br/g' $aNoImgHtmlFile
	# add image stripped xml docs to index
	echo "<div class=\"article\"><li><a href=$aNoImgHtmlFileUrl>$aName (No Images)</a></li></div>" >> $newIndexFile
	
done < $INPUT
IFS=$OLDIFS

echo "</ul></div>" >> $newIndexFile
echo "</body></html>" >> $newIndexFile
mv $newIndexFile $liveIndexFile

#archive to history
mkdir -p $DIR/history
export GZIP=-9
tar cvzf $DIR/history/$(date -d "today" +"%Y_%m_%d_%H_%M_%S").tar.gz $DIR/html/*.html
