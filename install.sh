#!/bin/sh

set_rox_wallpaper()
{
rox --RPC << EOF
<?xml version="1.0"?>
<env:Envelope xmlns:env="http://www.w3.org/2001/12/soap-envelope">
 <env:Body xmlns="http://rox.sourceforge.net/SOAP/ROX-Filer">
  <SetBackdrop>
   <Filename>${1}</Filename>
   <Style>Stretch</Style>
  </SetBackdrop>
 </env:Body>
</env:Envelope>

EOF
}
deduplicate_rox_icon_theme()
{
	local i
	for i in ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9}; do
		echo "[rm-ln] .icons/ROX-cdlinux/MIME/${1} => ${i}"
		rm "${HOME}/.icons/ROX-cdlinux/MIME/${i}"
		ln -s "${1}" "${HOME}/.icons/ROX-cdlinux/MIME/${i}"
	done
}

if [ "${HOME}" = '' ]; then
	echo 'HOME is not set'

	if [ "${1}" = '--press-enter' ]; then
		echo -n 'Press <enter> to exit'
		read enter
	fi

	exit 1
fi
if [ ! -d "${HOME}" ]; then
	echo "HOME=${HOME} is not a directory"

	if [ "${1}" = '--press-enter' ]; then
		echo -n 'Press <enter> to exit'
		read enter
	fi

	exit 1
fi
if [ "${XDG_PICTURES_DIR}" = '' ]; then
	XDG_PICTURES_DIR="${HOME}/Pictures"

	[ -e '/etc/xdg/user-dirs.defaults' ] && . '/etc/xdg/user-dirs.defaults'
	[ -e "${HOME}/.config/user-dirs.dirs" ] && . "${HOME}/.config/user-dirs.dirs"
fi

if [ -e "${HOME}/.gtkrc-2.0.cdlinux" ]; then
	echo 'Already installed'

	if [ "${1}" = '--press-enter' ]; then
		echo -n 'Press <enter> to exit'
		read enter
	fi

	exit 1
fi

echo -n 'Apply? (Y/[n]) '
read answer
[ "${answer}" = 'Y' ] || exit 0

cd "$(dirname "${0}")"

for i in '.icewm/themes' '.icons'; do
	for y in ${i}/*; do
		[ "${y}" = "${i}/*" ] && break
		[ ! -e "${HOME}/${i}" ] && mkdir -p "${HOME}/${i}"
		tar xvf "./${y}" -C "${HOME}/${i}"
	done
done

tar cf - '.themes' '.gtkrc-2.0.cdlinux' | tar xv -C "${HOME}"

[ ! -e "${XDG_PICTURES_DIR}" ] && mkdir -p "${XDG_PICTURES_DIR}"
cd "${XDG_PICTURES_DIR}"
tar cf - 'cdlinux.pl' | tar xv -C "${XDG_PICTURES_DIR}"
cd ..

[ -e "${HOME}/.gtkrc-2.0" ] && echo '' >> "${HOME}/.gtkrc-2.0"
echo 'include "'"${HOME}"'/.gtkrc-2.0.cdlinux"' >> "${HOME}/.gtkrc-2.0"

sed -i 's/\/usr\/share\/cdlcenter\/backgrounds\/splash.png/cdlcenter\/splash.png/g' "${HOME}/.icewm/themes/cdlinux.pl/default.theme"

echo 'Theme="cdlinux.pl/default.theme"' > "${HOME}/.icewm/theme"
icewm -r

deduplicate_rox_icon_theme mime-application.png application.png
deduplicate_rox_icon_theme mime-application:msword.png mime-application:vnd.ms-word.png
deduplicate_rox_icon_theme inode-fifo.png mime-inode:fifo.png
deduplicate_rox_icon_theme text.png text-plain.png
deduplicate_rox_icon_theme application-x-class-file.png application-x-java-byte-code.png
deduplicate_rox_icon_theme application-vnd.sun.xml.calc.png application-vnd.stardivision.calc.png
deduplicate_rox_icon_theme application-x-font-ttf.png mime-application:x-font-ttf.png
deduplicate_rox_icon_theme mime-video.png video.png
deduplicate_rox_icon_theme application-x-tcl.png text-x-tcl.png
deduplicate_rox_icon_theme trash-full.svg application-x-trash.png
deduplicate_rox_icon_theme text-x-C++.png text-x-c++src.png
deduplicate_rox_icon_theme audio-x-mp3.png audio-mpeg.png
deduplicate_rox_icon_theme text-bib.png application-texbibl.png text-x-bibtex.png
deduplicate_rox_icon_theme mime-application:xml.png mime-text:xml.png
deduplicate_rox_icon_theme text-x-c.png text-x-csrc.png
deduplicate_rox_icon_theme mime-application:x-font-linux-psf.png mime-application:x-font-pcf.png
deduplicate_rox_icon_theme audio-midi.png mime-audio:midi.png
deduplicate_rox_icon_theme mime-inode:chardevice.png inode-chardevice.png
deduplicate_rox_icon_theme mime-application:xhtml+xml.png mime-text:html.png
deduplicate_rox_icon_theme application-x-gzpostscript.png application-x-compressed-postscript2.png
deduplicate_rox_icon_theme mime-application:pgp.png application-pgp.png
deduplicate_rox_icon_theme application-vnd.sun.xml.impress.png application-vnd.stardivision.impress.png
deduplicate_rox_icon_theme font-afm.png application-x-font-sunos-news.png
deduplicate_rox_icon_theme text-x-patch.png mime-text:x-diff.png
deduplicate_rox_icon_theme mime-text:x-makefile.png text-x-makefile.png
deduplicate_rox_icon_theme application-x-object.png mime-application:x-object.png
deduplicate_rox_icon_theme mime-text:x-copying.png text-x-copying.png
deduplicate_rox_icon_theme application-zip.png mime-application:x-bzip-compressed-tar.png mime-application:x-compressed-tar.png application-x-tar.png mime-application:x-tar.png mime-application:zip.png
deduplicate_rox_icon_theme mime-application:x-troff.png mime-application:x-troff-man-compressed.png mime-application:x-troff-man.png
deduplicate_rox_icon_theme mime-inode:directory.png inode-directory.png mime-inode:mount-point.png
deduplicate_rox_icon_theme mime-application:x-lyx.png text-lyx.png
deduplicate_rox_icon_theme application-x-sharedlib.png application-x-shared-library.png
deduplicate_rox_icon_theme application-x-cd-image.png application-iso.png
deduplicate_rox_icon_theme text-x-java.png application-x-java.png application-x-java-source.png

for i in ${HOME}/.icons/ROX-cdlinux/MIME/mime-*:*; do
	[ "${i}" = "${HOME}/.icons/ROX-cdlinux/MIME/mime-*:*" ] && break

	i="${i##*/}"
	link_name="${i#mime-}"
	link_name="$(echo -n "${link_name}" | tr ':' '-')"

	if [ ! -e "${HOME}/.icons/ROX-cdlinux/MIME/${link_name}" ]; then
		echo "[ln] .icons/ROX-cdlinux/MIME/${i} => ${link_name}"
		ln -s "${i}" "${HOME}/.icons/ROX-cdlinux/MIME/${link_name}"
	fi
done

if [ -e "${HOME}/.config/rox.sourceforge.net/ROX-Filer/Options" ]; then
	if grep '<Option name="icon_theme">' "${HOME}/.config/rox.sourceforge.net/ROX-Filer/Options" > /dev/null 2>&1; then
		sed -i 's/<Option name="icon_theme">.*<\/Option>/<Option name="icon_theme">ROX-cdlinux<\/Option>/g' "${HOME}/.config/rox.sourceforge.net/ROX-Filer/Options"
	else
		sed -i '$d' "${HOME}/.config/rox.sourceforge.net/ROX-Filer/Options"
		echo '  <Option name="icon_theme">ROX-cdlinux</Option>' >> "${HOME}/.config/rox.sourceforge.net/ROX-Filer/Options"
		echo '</Options>' >> "${HOME}/.config/rox.sourceforge.net/ROX-Filer/Options"
	fi
else
	mkdir -p "${HOME}/.config/rox.sourceforge.net/ROX-Filer"
	echo '<?xml version="1.0"?>' > "${HOME}/.config/rox.sourceforge.net/ROX-Filer/Options"
	echo '<Options>' >> "${HOME}/.config/rox.sourceforge.net/ROX-Filer/Options"
	echo '  <Option name="icon_theme">ROX-cdlinux</Option>' >> "${HOME}/.config/rox.sourceforge.net/ROX-Filer/Options"
	echo '</Options>' >> "${HOME}/.config/rox.sourceforge.net/ROX-Filer/Options"
fi

set_rox_wallpaper "${XDG_PICTURES_DIR}/cdlinux.pl/cdlinux.png"
for i in ${HOME}/.config/rox.sourceforge.net/ROX-Filer/pb_*; do
	[ "${i}" = "${HOME}/.config/rox.sourceforge.net/ROX-Filer/pb_*" ] && break
	sed -i 's/<backdrop style=".*">'"$(echo -n ${XDG_PICTURES_DIR}/cdlinux.pl/cdlinux.png | sed 's/\//\\\//g')"'<\/backdrop>/<backdrop style="Fit">'"$(echo -n ${XDG_PICTURES_DIR}/cdlinux.pl/cdlinux.png | sed 's/\//\\\//g')"'<\/backdrop>/g' "${i}"
done

[ -e "${HOME}/.icons/default" ] && mv "${HOME}/.icons/default" "${HOME}/.icons/default.org-cdlt"
mkdir "${HOME}/.icons/default"
echo '[Icon Theme]' > "${HOME}/.icons/default/index.theme"
echo 'Inherits=none' >> "${HOME}/.icons/default/index.theme"

exit 0
