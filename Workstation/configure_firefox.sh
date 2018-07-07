#!/usr/bin/env bash

declare -A extensions=(
  ["uBlock0@raymondhill.net.xpi"]="https://addons.mozilla.org/firefox/downloads/file/1001903/"
  ["jid1-MnnxcxisBPnSXQ-eff@jetpack.xpi"]="https://www.eff.org/files/privacy-badger-latest.xpi"
  ["CookieAutoDelete@kennydo.com.xpi"]="https://addons.mozilla.org/firefox/downloads/file/954445/"
  ["https-everywhere-eff@eff.org.xpi"]="https://www.eff.org/files/https-everywhere-latest.xpi"
  ["jid1-BoFifL9Vbdl2zQ@jetpack.xpi"]="https://addons.mozilla.org/firefox/downloads/file/1003133/"
  ["uMatrix@raymondhill.net.xpi"]="https://addons.mozilla.org/firefox/downloads/file/984158/"
  ["{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"]="https://addons.mozilla.org/firefox/downloads/file/972162/"
  ["{3579f63b-d8ee-424f-bbb6-6d0ce3285e6a}.xpi"]="https://addons.mozilla.org/firefox/downloads/file/998133/"
)

for extension in ${!extensions[@]}; do
  wget ${extensions[$extension]} -O ${extension}
  mv ${extension} /usr/lib/firefox/browser/extensions && echo "${extension} installed." || "${extension} failed."
done