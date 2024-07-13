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
COPY --from=builder /target/*.war webapps/student.war\


## Kubernetes cluster creation 
admin ec2 role
kubectl 
awscli
eksctl
#https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html
##install kubectl 
#refer https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.0/2024-05-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
kubectl version --client
#install eksctl https://eksctl.io/installation

# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo mv /tmp/eksctl /usr/local/bin

# eksctl 
eksctl create cluster --name bramhos --node-type=t2.medium --nodes=2 --region=us-east-1
#eksctl create cluster --name my-cluster --region region-code --version 1.29 --vpc-private-subnets subnet-ExampleID1,subnet-ExampleID2 --without-nodegroup

## kubectl 

kubectl get nodes
kubectl get nodes -o wide

##pod 
kubectl get pods 
kubectl describe po nginx 
## create pods
kubect apply -f pod.yaml


## container type
 sidecar container -> 
 init container -> 


## 
 pod -> 
 rs-> 
    prefix -> rs\
deploy -> 
    rs-> prefix-> 
        pod -> 
## services
ClusterIP  -> default -> internal 
NodePort -> expose -> service -> internet
LoadBalancer -> only available on cloud 

## 
kubectl create configmap nginxconf --from-file=index.html --dry-run=client -o yaml > cm.yaml
  kubectl create secret generic nginx-secret --from-file=index.html --dry-run=client -o yaml > secret.yaml

  kubectl port-forward pod/dapi-test-pod :80

  echo "aGVsbG8gCg==" | base64 --decode

#ns
  kubectl create ns dev
  kubectl run nginx --image=nginx -n dev
    kubectl get po -n dev
kubectl get po -A 


resources: {}
    limits: 
        cpu:
        memory:
    requests:
        cpu:
        memory:

## volumes
 host PATH
 CSI drivers  -> dynamic volumes

#pv

pv 
  pvc
  volume pod 
 
dynamic volumes
    pvc 
    volume pod 
  

##
 
1. eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster thor \
    --role-name AmazonEKS_EBS_CSI_DriverRole \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve --region=us-east-2

# https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html

2. cluster_name=thor
3. oidc_id=$(aws eks describe-cluster --name $cluster_name  --region=us-east-2 --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
4. echo $oidc_id
5. aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
6. eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve --region=us-east-2
7. again 1st step


8. eksctl create addon --name aws-ebs-csi-driver --cluster thor --service-account-role-arn arn:aws:iam::533266958719:role/AmazonEKS_EBS_CSI_DriverRole --force

9. eksctl get addon --name aws-ebs-csi-driver --cluster thor --region=us-east-2
10. kubectl apply -f volume


##
docker file task
1. create Dockerfile
2. base image nginx, free css template 
## 
FROM nginx 
COPY freecsstemplate /usr/shared/nginx/html/.

frontend

ingress controller
https://docs.aws.amazon.com/eks/latest/userguide/lbc-manifest.html

cluster_name=demo
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
echo $oidc_id
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json


    eksctl create iamserviceaccount \
    --cluster=$cluster_name \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --role-name AmazonEKSLoadBalancerControllerRole \
    --attach-policy-arn=arn:aws:iam::975049998799:policy/AWSLoadBalancerControllerIAMPolicy \
    --approve

    # kubectl apply \
    # --validate=false \
    # -f https://github.com/jetstack/cert-manager/releases/download/v1.13.5/cert-manager.yaml

    # curl -Lo v2_7_2_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.7.2/v2_7_2_full.yaml

    # sed -i.bak -e '612,620d' ./v2_7_2_full.yaml

    # kubectl apply -f v2_7_2_full.yaml

    # curl -Lo v2_7_2_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.7.2/v2_7_2_ingclass.yaml

    # kubectl apply -f v2_7_2_ingclass.yaml


    install helm 

    https://helm.sh/docs/intro/install/helm repo add eks https://aws.github.io/eks-charts

    helm repo add eks https://aws.github.io/eks-charts
    helm repo update eks

    helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$cluster_name \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller 


  https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html

  kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/examples/2048/2048_full.yaml


kubectl create ingress simple --rule="foo.com/bar=svc1:80" --dry-run=client -o yaml > ing.yaml

---
  # 2145  kubectl apply -f .
  # 2146  kubectl expose deploy nginx --port=80 
  # 2147  kubectl get svc
  # 2148  cluster_name=demo
  # 2149  oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)\n
  # 2150  echo $oidc_id\n
  # 2151  eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve\n
  # 2152  aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4\n
  # 2153  curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json\n
  # 2154  ls
  # 2155  aws iam create-policy \\n    --policy-name AWSLoadBalancerControllerIAMPolicy \\n    --policy-document file://iam_policy.json
  # 2156  curl -Lo v2_7_2_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.7.2/v2_7_2_full.yaml\n
  # 2157  sed -i.bak -e '612,620d' ./v2_7_2_full.yaml\n
  # 2158  kubectl apply -f v2_7_2_full.yaml\n
  # 2159  kubectl apply \\n    --validate=false \\n    -f https://github.com/jetstack/cert-manager/releases/download/v1.13.5/cert-manager.yaml\n
  # 2160  kubectl apply -f v2_7_2_full.yaml\n
  # 2161  kubectl get all
  # 2162  kubectl get all -A
  # 2163  kubectl get deployment -n kube-system aws-load-balancer-controller\n
  # 2164  kubectl describe deploy -n kube-system aws-load-balancer-controller
  # 2165  brew install helm 
  # 2166  helm 
  # 2167  helm repo add eks https://aws.github.io/eks-charts\n
  # 2168  helm repo update eks\n
  # 2169  kubectl delete -f v2_7_2_full.yaml
  # 2170  kubectl get all -A
  # 2171  kubectl get deployment -n kube-system aws-load-balancer-controller\n
  # 2172  kubectl get svc -A
  # 2173  kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/examples/2048/2048_full.yaml\n
  # 2174  kubectl get all 
  # 2175  kubectl get all -n game-2048
  # 2176  curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/examples/2048/2048_full.yaml\n
  # 2177  kubectl api-resources 
  # 2178  kubectl api-resources  | grep ing
  # 2179  kubectl get ingressclass
  # 2180  kubectl get ing
  # 2181  kubectl get ing -n game-2048
  # 2182  kubectl apply -f deploy.yaml
  # 2183  kubectl get ing
  # 2184  kubectl create ing --help 
  # 2185  kubectl create ingress simple --rule="foo.com/bar=svc1:80 --dry-run=client -o yaml > ing.yaml
  # 2186  kubectl create ingress simple --rule="foo.com/bar=svc1:80" --dry-run=client -o yaml > ing.yaml
  # 2187  kubectl expose deploy nginx --port=80 --dry-run=client -o yaml > svc.yaml
  # 2188  kubectl apply -f deploy.yaml
  # 2189  kubectl config set-context --current --namespace=game-2048
  # 2190  kubectl get all
  # 2191  kubectl get pod
  # 2192  kubectl describe po nginx-6df4bb547-v57m9  
  # 2193  kubectl apply -f cm.yaml
  # 2194  kubectl apply -f deploy.yaml
  # 2195  kubectl get po
  # 2196  kubectl get ing
  # 2197  kubectl edit ing ingress-2048
  # 2198  kubectl get ing
  # 2199  kubectl get po
  # 2200  kubectl exec -it nginx-6df4bb547-v57m9  bash

  docker run -d --privileged -P --user root  -v /mnt:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkins/jenkins
