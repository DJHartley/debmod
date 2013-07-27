#!/bin/sh
#  Script creato da TheZero
#
#  Version GUI (Fork by Pinperepette) 
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  

# Funzioni #############################################################
menu_principale(){
azione=`zenity --list --width=250 --height=150 \
  --title="D E B M O D" \
  --text="What should I do?" \
  --column="Options :" \
	"I extract a deb file" \
	"I create a deb file"`
}

extract(){

	(mkdir "$NEWDIRNAME"
	cp -fv -R "$ARCHIVE_FULLPATH" "$NEWDIRNAME"
	cd "$NEWDIRNAME"
	ar vx "$FILENAME"
	rm -fv -R "$FILENAME"
	for FILE in *.tar.gz; do [[ -e $FILE ]] && tar xvpf $FILE; done
	for FILE in *.tar.lzma; do [[ -e $FILE ]] && tar xvpf $FILE; done
	[[ -e "control.tar.gz" ]] && rm -fv -R "control.tar.gz"
	[[ -e "data.tar.gz" ]] && rm -fv -R "data.tar.gz"
	[[ -e "data.tar.lzma" ]] && rm -fv -R "data.tar.lzma"
	[[ -e "debian-binary" ]] && rm -fv -R "debian-binary"

	mkdir "DEBIAN"
	[[ -e "changelog" ]] && mv -fv "changelog" "DEBIAN"
	[[ -e "config" ]] && mv -fv "config" "DEBIAN"
	[[ -e "conffiles" ]] && mv -fv "conffiles" "DEBIAN"
	[[ -e "control" ]] && mv -fv "control" "DEBIAN"
	[[ -e "copyright" ]] && mv -fv "copyright" "DEBIAN"
	[[ -e "postinst" ]] && mv -fv "postinst" "DEBIAN"
	[[ -e "preinst" ]] && mv -fv "preinst" "DEBIAN"
	[[ -e "prerm" ]] && mv -fv "prerm" "DEBIAN"
	[[ -e "postrm" ]] && mv -fv "postrm" "DEBIAN"
	[[ -e "rules" ]] && mv -fv "rules" "DEBIAN"
	[[ -e "shlibs" ]] && mv -fv "shlibs" "DEBIAN"
	[[ -e "templates" ]] && mv -fv "templates" "DEBIAN"
	[[ -e "triggers" ]] && mv -fv "triggers" "DEBIAN"
	[[ -e ".svn" ]] && mv -fv ".svn" "DEBIAN"

	[[ -e "md5sums" ]] && rm -fv -R "md5sums") | zenity --progress --title="D E B M O D..." --text="deb extraction" --auto-kill --pulsate

}

build(){
	(cd "$ARCHIVE_FULLPATH"
	find . -type f ! -regex '.*\.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums
	cd ..
	dpkg-deb -b "$ARCHIVE_FULLPATH"
		rm -fv -R "$ARCHIVE_FULLPATH") | zenity --progress --title="D E B M O D..." --text="deb creation" --auto-kill --pulsate
}
# Script ###############################################################
menu_principale
case $azione in
"I extract a deb file")
file=`zenity --file-selection --title="Select a File"`
	if [ $file >/dev/null ]; then
		ARCHIVE_FULLPATH="$file"
		NEWDIRNAME=${ARCHIVE_FULLPATH%.*}
		FILENAME=${ARCHIVE_FULLPATH##*/}
	else
		zenity --error --no-wrap --no-markup --text="You have not selected folder" --title="D E B M O D ERROR" --window-icon='error' --width=400 --height=300
		exit 1
	fi
	extract
;;
"I create a deb file")
dir=`zenity --file-selection --title="Select a Directory" --directory`
	if [ $dir >/dev/null ]; then
		ARCHIVE_FULLPATH="$dir"
		NEWDIRNAME=${ARCHIVE_FULLPATH%.*}
	else
		zenity --error --no-wrap --no-markup --text=" You have not selected directory" --title="D E B M O D ERROR" --window-icon='error' --width=400 --height=300
		exit 1
	fi
	build 
;;
*)menu_principale
;;
esac
exit 0
