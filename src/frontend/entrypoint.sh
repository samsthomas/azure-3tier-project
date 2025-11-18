echo "Injecting API_URL=${API_URL}"
sed -i "s|__API_URL__|${API_URL}|g" usr/share/nginx/html/app.js

nginx -g "daemon off;"