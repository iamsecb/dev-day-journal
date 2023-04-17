# /usr/local/bin env

Y="$(date +'%Y')"
FN="$(date +'%d-%m-%Y')"
TITLE="retrospectives"

mkdir -p "$TITLE/$Y"

cat <<EOF > "$TITLE/$Y/$(date +'%d%m %a').md"
## Retrospective
EOF
