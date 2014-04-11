# Based on version for Ubuntu https://github.com/phlipper/chef-libqt4
name              "libqt"
maintainer        "Markus Schwarz"
maintainer_email  "markus@brandslisten.com"
description       "Install libqt packages"
version           "0.1.0"
depends           "cmake"
supports          "debian"

recipe "default",  "Install webkit support for libqt4 packages"
