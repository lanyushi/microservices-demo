# create new k8s cluster
eksctl create cluster --name pixiecluster --region us-east-1
eksctl utils write-kubeconfig --cluster=pixiecluster
kubectl get nodes -o wide

# deploy the app
kubectl create namespace sock-shop && \
kubectl apply -f "https://raw.githubusercontent.com/nvhoanganh/microservices-demo/master/deploy/kubernetes/complete-demo.yaml" \
--namespace=sock-shop

# make sure all containers are running properly
kubectl wait --for=condition=available --timeout=450s --all deployments -n sock-shop

# get the external IP of the front-end service
kubectl get service --watch --namespace=sock-shop