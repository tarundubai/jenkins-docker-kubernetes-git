#!/bin/sh
# This script will create a system test env of TSM server on AWS EKS  compirses TSM server , selenium/standalone-chrome , browsermob-proxy and robot framework

############# STEP- 1 #############

# Get an AWS IAM user with fixed Access key and Security Access Key and Permission to access on EKS

# Need to add in EKS aws-auth config file
#aws configure        # This has to be done all workers agent nodes in Teamcity 


############# STEP- 2 #############


# Install helm

############# STEP- 3 #############

# Install kubectl in all workers agent nodes in Teamcity 
#curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
#chmod +x ./kubectl
#mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
#echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
#kubectl version --short --client

############# STEP- 4 #############

# Get the kubeconfig file from EKS with AWS IAM user access key and secure access key

# create a namespace 'systest'
kubectl apply -f systest-create-ns.yaml --kubeconfig=/home/tarun/.kube/config-tsm-dev --dry-run=client > /home/tarun/exb/logs/systest-create-ns.log

# Get the HELM chart from bitbucket and create tsm server named with tsm-systest
#cd /home/tarun/exb/repo/helm/charts/tsm-server
#helm install tsm-systest . -f values.yaml -n systest --kubeconfig=/home/tarun/.kube/config-tsm-dev  --dry-run=client > /home/tarun/exb/logs/systest-tsm.log
echo " TESTING..........."


# create selenium standalone-chrome and browsermob proxy
#kubectl apply -f  systest-selenium-proxy-deploy.yaml --kubeconfig=/home/tarun/.kube/config-tsm-dev --dry-run=client > /home/tarun/exb/logs/systest-selenium-proxy-deploy.log
kubectl apply -f  systest-selenium-proxy-deploy.yaml --kubeconfig=/home/tarun/.kube/config-tsm-dev > /home/tarun/exb/logs/systest-selenium-proxy-deploy.log

sleep 30

# Create robot framework
#kubectl apply -f systest-robot-deploy.yaml --kubeconfig=/home/tarun/.kube/config-tsm-dev --dry-run=client > /home/tarun/exb/logs/systest-robot-deploy.log
kubectl apply -f systest-robot-deploy.yaml --kubeconfig=/home/tarun/.kube/config-tsm-dev  > /home/tarun/exb/logs/systest-robot-deploy.log

sleep 20

#Get the robot pod named
POD_NAME=`kubectl get pods  --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'  -n systest --kubeconfig=/home/tarun/.kube/config-tsm-dev | grep robot`
echo $POD_NAME >> /home/tarun/exb/logs/pod_name.log

# make test and dependencies
kubectl exec -it $POD_NAME -n systest --kubeconfig=/home/tarun/.kube/config-tsm-dev  /bin/mkdir /home/robot/test  /home/robot/dependencies 

# copy files to /home/robot/test from Depencies
LIST_DEP_FILES=`ls /home/tarun/exb/repo/cloud_processing/tsm-e2e/tsm-e2e-build-tools/e2e-robot-libraries/src/main/shared-robot-resources`
DEP_DIR=/home/tarun/exb/repo/cloud_processing/tsm-e2e/tsm-e2e-build-tools/e2e-robot-libraries/src/main/shared-robot-resources
for f in $LIST_DEP_FILES ; do
#cp -r  $DIR/$f /tmp ;
kubectl cp  $DEP_DIR/$f  systest/$POD_NAME:/home/robot/   --kubeconfig=/home/tarun/.kube/config-tsm-dev -n systest ;
done
sleep 10

#Copy files to /home/robot/test 
LIST_TEST_FILES=`ls /home/tarun/exb/repo/cloud_processing/tsm-e2e/tsm-base-test/e2e-base-test/robot-tests/src/main/resources/robot/tests`
POD_NAME=`kubectl get pods  --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'  -n systest --kubeconfig=/home/tarun/.kube/config-tsm-dev | grep robot`
TEST_DIR=/home/tarun/exb/repo/cloud_processing/tsm-e2e/tsm-base-test/e2e-base-test/robot-tests/src/main/resources/robot/tests/
for f in $LIST_TEST_FILES ; do
#cp -r  $DIR/$f /tmp ;
kubectl cp  $TEST_DIR/$f  systest/$POD_NAME:/home/robot/   --kubeconfig=/home/tarun/.kube/config-tsm-dev -n systest ;
done
sleep 10

# Copy 'fixtures' folder to /home/robot/test
kubectl cp  $TEST_DIR/fixtures  systest/$POD_NAME:/home/robot/test  --kubeconfig=/home/tarun/.kube/config-tsm-dev -n systest
sleep 10

############# STEP- 5 #############

# Execute the test cases
echo "Testing............"
kubectl exec -it $POD_NAME -n systest --kubeconfig=/home/tarun/.kube/config-tsm-dev /usr/local/bin/wait-for-it.sh -t 60 tsm-systest:8888 -- robot -d output . > /home/tarun/exb/logs/robot.log
echo "Testing Finish............"
#/usr/local/bin/wait-for-it.sh -t 60 tsm-systest:8888 -- robot -d output .  > /home/robot/output/robot.log
echo "Testing Finished............"

############# STEP- 6 #############

# Destroy the enviornments

