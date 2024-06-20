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
sudo docker kill (container id) 
docker stop (container id)
docker rmi -f (image name)
sudo docker run -d -P --name dollikichai nginx
sudo docker logs (container id)
sudo docker ps -q
sudo docker kill $(sudo docker ps -q)
sudo docker network ls
docker inspect  (container id)
docker network create (network name)
docker volume create (volume name)
docker volume ls 
docker volume create dev
docker run -d -P -v dev:/usr/share/nginx/html nginx
docker system prune -a -f


##Dockerfile
FROM
COPY
ADD
RUN
CMD
ENTRYPOINT
EXPOSE

##
FROM amazonlinux 
RUN yum update && yum install nginx -y
COPY index.html /usr/share/nginx/html/.
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

## tomcat
FROM amazonlinux 
RUN yum update && yum install -y  java-11-amazon-corretto.x86_64 && yum install -y unzip && yum install -y wget && yum install -y maven 
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.100/bin/apache-tomcat-8.5.100.zip
RUN unzip apache-tomcat-8.5.100.zip 
RUN mv apache-tomcat-8.5.100 /mnt/tomcat
RUN chmod 770 /mnt/tomcat/bin/catalina.sh
COPY student-ui /
RUN mvn clean package
RUN cp /target/*.war /mnt/tomcat/webapps/student.war
EXPOSE 8080
CMD ["/mnt/tomcat/bin/catalina.sh" , "run"]

##https://github.com/Pritam-Khergade/student-ui/tree/master

## multistage 
FROM maven:3.9-sapmachine-11 as builder
COPY . /
RUN mvn clean package

FROM tomcat:jre8-alpine
COPY --from=builder /target/*.war webapps/student.war


