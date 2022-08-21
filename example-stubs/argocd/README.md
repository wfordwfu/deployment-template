Following along on https://www.youtube.com/watch?v=vpWQeoaiRM4

export INGRESS_HOST=127.0.0.1

git init
gh repo create --public
git add .
git commit -m "Initial commit"
git push --set-upstream origin main

kubectl apply --filename apps.yaml

open http://argocd.$INGRESS_HOST.nip.io
