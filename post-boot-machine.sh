#!/bin/bash

# Updates a new Vagrant machine based on modernie to run selenium

#set -x
#set -e

if [ -z "$1" ]; then
	echo Missing VM ID
	exit 1
fi

id=$1
# FIXME: IE version, not important unless configuring a Selenium Grid node
vm_ie=IE10
GC_OPTS="--username IEUser --password Passw0rd! --verbose"
HEADLESS="--type headless"
DOWNLOADS="${HOME}/Downloads"
FILES="$(pwd)"

# Check for downloads
DEUAC="${DOWNLOADS}/deuac.iso"
JREWIN="$(ls ${DOWNLOADS}/jre*windows*exe | head -n 1)"
SELENIUM="$(ls ${DOWNLOADS}/selenium-server-standalone*.jar | head -n 1)"
IEDRIVER="${DOWNLOADS}/IEDriverServer.exe"

downloads_needed=0
if [ ! -f "${DEUAC}" ]; then
	downloads_needed=1
	echo "deuac.iso missing, download into ${DOWNLOADS} from https://github.com/tka/SeleniumBox/blob/master/deuac.iso" >&2
fi
if [ ! -f "${JREWIN}" ]; then
	downloads_needed=1
	echo "Windows JRE missing, download into ${DOWNLOADS} from http://java.com/en/download/manual.jsp" >&2
fi
if [ ! -f "${SELENIUM}" ]; then
	downloads_needed=1
	echo "selenium-server-standalone*.jar missing, download into ${DOWNLOADS} from http://www.seleniumhq.org/download/" >&2
fi
if [ ! -f "${IEDRIVER}" ]; then
	downloads_needed=1
	echo "IEDriverServer.exe missing, download into ${DOWNLOADS} from http://www.seleniumhq.org/download/" >&2
fi
[ "${downloads_needed}" -eq 0 ] || exit 1

waitforgc() {
	sleep 5s
	until VBoxManage guestcontrol $id stat 'C:/' ${GC_OPTS} >/dev/null; do
		sleep 5s
	done
}

startvm() {
	if VBoxManage list runningvms | grep -q $id; then
		true
	else
		VBoxManage startvm $id ${HEADLESS} || exit 1
	fi
	waitforgc
}

waitforstop() {
	while VBoxManage list runningvms | grep -q $id; do
		sleep 5s
	done
}

stopvm() {
	if VBoxManage list runningvms | grep -q $id; then
		VBoxManage controlvm $id acpipowerbutton || VBoxManage controlvm $id poweroff
		sleep 3s
	fi
	waitforstop
}

disable_uac() {
    stopvm
	VBoxManage storageattach $id --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "${DEUAC}" || exit 1
	VBoxManage startvm $id ${HEADLESS} || exit 1
	# The deuac.iso starts, mods the VM, and then stops the VM
	waitforstop
	VBoxManage storageattach $id --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium none || exit 1
}

prepare() {
	VBoxManage guestcontrol $id mkdir "C:/Temp" --parents ${GC_OPTS} || exit 1
}

configure() {
    # Powershell hangs, even when run from a .bat file, not sure why
	#VBoxManage guestcontrol $id copyto "${FILES}/vagrant_prepare.bat" "C:/Temp/vagrant_prepare.bat" ${GC_OPTS} || exit 1
	#VBoxManage guestcontrol $id copyto "${FILES}/vagrant_prepare.ps1" "C:/Temp/vagrant_prepare.ps1" ${GC_OPTS} || exit 1
	#VBoxManage guestcontrol $id execute --image "C:/Temp/vagrant_prepare.bat" ${GC_OPTS} --wait-exit || exit 1
	VBoxManage guestcontrol $id execute --image 'C:/windows/system32/netsh.exe' ${GC_OPTS} -- advfirewall set allprofiles state off
	waitforgc
}

install_java() {
	VBoxManage guestcontrol $id copyto "${JREWIN}" "C:/Temp/jre.exe" ${GC_OPTS} || exit 1
	VBoxManage guestcontrol $id execute --image "C:/Temp/jre.exe" ${GC_OPTS} --wait-exit -- /s || exit 1
}

install_selenium() {
	VBoxManage guestcontrol $id mkdir "C:/selenium" --parents ${GC_OPTS} || exit 1
	VBoxManage guestcontrol $id copyto "${SELENIUM}" 'C:/selenium/selenium-server-standalone.jar' ${GC_OPTS} || exit 1
	VBoxManage guestcontrol $id copyto "${FILES}/selenium.bat" 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup/selenium.bat' ${GC_OPTS} || exit 1
	VBoxManage guestcontrol $id copyto "${FILES}/selenium_conf/WIN7/${vm_ie}/config.json" 'C:/selenium/config.json' ${GC_OPTS} || exit 1
	VBoxManage guestcontrol $id copyto "${IEDRIVER}" 'C:/Windows/system32/IEDriverServer.exe' ${GC_OPTS} || exit 1
}

# snapshots cause problems with vagrant (1.6 ATM) when destroying
#VBoxManage snapshot $id take "modernie base"
disable_uac
startvm
prepare
configure
install_java
install_selenium
stopvm
#VBoxManage snapshot $id take "selenium base"
