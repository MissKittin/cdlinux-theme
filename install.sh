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

echo -n 'Apply? (Y/n) '
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
cd './Pictures'
tar cf - 'cdlinux.pl' | tar xv -C "${XDG_PICTURES_DIR}"
cd ..

[ -e "${HOME}/.gtkrc-2.0" ] && echo '' >> "${HOME}/.gtkrc-2.0"
echo 'include "'"${HOME}"'/.gtkrc-2.0.cdlinux"' >> "${HOME}/.gtkrc-2.0"

echo 'Theme="cdlinux.pl/default.theme"' > "${HOME}/.icewm/theme"
icewm -r

#[ -e "${HOME}/.icons/ROX" ] && mv "${HOME}/.icons/ROX" "${HOME}/.icons/ROX-original"
#ln -s  "ROX-cdlinux" "${HOME}/.icons/ROX"

set_rox_wallpaper "${XDG_PICTURES_DIR}/cdlinux.pl/cdlinux.png"

exit 0
