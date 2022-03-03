# Step 1. Monitor your cluster using Pixie without Instrumentation (5m)

-   Login to https://one.newrelic.com and click on `Add more data`
-   Search for `Kubernetes`
-   Enter a name for your Cluster and click `Continue`
-   Select `Scrape all Prometheus endpoints`, `Gather Log data` and `Instant Service-level insights ...` and click `Continue`
-   Select `Helm 3` from th drop down and copy the provided command

```bash
# run the command
kubectl apply -f https://download.newrelic.com/install/kubernetes/pixie/latest/px.dev_viziers.yaml && \
kubectl apply -f https://download.newrelic.com/install/kubernetes/pixie/latest/olm_crd.yaml && \
helm repo add newrelic https://helm-charts.newrelic.com && helm repo update && \
kubectl create namespace newrelic ; helm upgrade --install newrelic-bundle newrelic/nri-bundle \
 --set global.licenseKey=LICENSE_KEY \
 --set global.cluster=YOUR_DEMO_NAME \
 --namespace=newrelic \
 --set newrelic-infrastructure.privileged=true \
 --set global.lowDataMode=true \
 --set ksm.enabled=true \
 --set kubeEvents.enabled=true \
 --set prometheus.enabled=true \
 --set logging.enabled=true \
 --set newrelic-pixie.enabled=true \
 --set newrelic-pixie.apiKey=PIXIE_API_KEY \
 --set pixie-chart.enabled=true \
 --set pixie-chart.deployKey=PIXIE_DEPLOY_KEY \
 --set pixie-chart.clusterName=YOUR_DEMO_NAME

 # make sure all pods are running
kubectl wait --for=condition=available --timeout=450s --all deployments -n newrelic
```

-   Browse your app again and come back to New Relic and select `Explorer > More > Kubernetes`

# Step 2. Add New Relic APM to see Distributed Tracing (5m)

-   you need NR API key (login to NR1, select API Keys from your avatar drop down menu)
-   replace `YOUR_NR_INGEST_API` with your API key

```bash
# set up ENV variables
kubectl set env deployment/front-end \
    NEW_RELIC_LICENSE_KEY=YOUR_NR_INGEST_API \
    NEW_RELIC_APP_NAME=sock-shop-frontend \
    NEW_RELIC_NO_CONFIG_FILE=true \
    NEW_RELIC_DISTRIBUTED_TRACING_ENABLED=true \
    --namespace=sock-shop

# update the image which include NR Agent
kubectl set image deployment/front-end \
    front-end=nvhoanganh1909/sock-shop-frontend:step1_AddNR_APM \
    -n sock-shop

# wait until all pods are in running state
kubectl get pods -n sock-shop
```

-   Login to https://one.newrelic.com and select `Explorer > Services - APM`
# Clean up your Resources

```bash
# delete the Azure AKS cluster
az aks delete --name pixiecluster --resource-group pixiedemo

# delete the AWS EKS cluster
eksctl delete cluster --name pixiecluster --region us-east-1
```
