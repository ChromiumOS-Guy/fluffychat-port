#!/bin/sh
set -e

case $ARCH in # make sure its the format i want while logging
  aarch64|arm64) echo -e "aarch64 architecture detected\n" && ARCH="arm64";;
  amd64|x86_64) echo -e "amd64/x86_64 architecture detected\n" && ARCH="x64" ;;
  *) echo "Error: Unknown architecture ${ARCH}" && exit 1 ;;
esac

LATEST_TAG=`curl -s https://api.github.com/repos/krille-chan/fluffychat/releases/latest | jq -r .tag_name`
URL="https://github.com/krille-chan/fluffychat/releases/download/${LATEST_TAG}/fluffychat-linux-${ARCH}.tar.gz" # get download URL for tar

echo -e "download url: (${URL})\n" # logging

/bin/wget "${URL}" -P "${INSTALL_DIR}" # download it

TARBALL=`/bin/find "$INSTALL_DIR" -type f -name "*.tar.gz" -print -quit` # get INSTALL_DIR to TARBALL

cd "$INSTALL_DIR"

/usr/bin/tar -xvf "${TARBALL}" # extract it

if [ ! -d "$INSTALL_DIR/data" ]; then # check for extraction
  echo "Error: tar not extracted properly! (cannot find data dir)"
  /bin/rm -rf "${TARBALL}"
  exit 1
fi

if [ ! -d "$INSTALL_DIR/lib" ]; then # check for extraction
  echo "Error: tar not extracted properly! (cannot find lib dir)"
  /bin/rm -rf "${TARBALL}"
  exit 1
fi

if [ ! -f "$INSTALL_DIR/fluffychat" ]; then # check for extraction
  echo "Error: tar not extracted properly! (cannot find fluffychat binary)"
  /bin/rm -rf "${TARBALL}"
  exit 1
fi

/bin/chmod +x $INSTALL_DIR/fluffychat # give correct permissions
/bin/chmod -R +x $INSTALL_DIR/lib/* 

/bin/rm -rf "${TARBALL}" # remove tarball as its not needed anymore.

if [ -f "${TARBALL}" ]; then # check if tarball remove, as this is not catastrophic script does not fail.
  echo "Failed to Remove TARBALL ("${TARBALL}") please remove manually"
fi

exit 0