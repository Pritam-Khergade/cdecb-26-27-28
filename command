git add 
git commit -m ""
git push 
git config --global user.name ""
git config --global user.email ""

git checkout -b dev

## DOCKER

sudo docker pull httpd
sudo docker run httpd
sudo docker run -d httpd
sudo docker run -d -P nginx
sudo docker run -d -p 80:80 nginx
sudo docker exec -it (container id) curl localhost
sudo docker exec -it (container id) /bin/bash
