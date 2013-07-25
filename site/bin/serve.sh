#!/bin/sh
APP_DIR="$(dirname $0)/.."
cd $APP_DIR

cat > _serve.yml <<-EOF
	url: http://localhost:4000
EOF

jekyll serve -w --config _config.yml,_serve.yml $@
rm _serve.yml
