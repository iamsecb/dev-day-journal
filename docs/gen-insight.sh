# /usr/local/bin env

Y="$(date +'%Y')"
FN="$(date +'%d-%m-%Y')"
TITLE="insights"

mkdir -p "$TITLE/$Y"

cat <<EOF > "$TITLE/$Y/$(date +'%d%m-%a-%y').md"
## Insights
EOF
