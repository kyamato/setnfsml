#
# recover helm executable
#
#cp helm /usr/local/bin/helm
#
# set default storage class
# sh nfs.sh
#
#NFS_SERVER_IP=10.32.0.77
#NFS_PATH='\/exports\/nfs01\/dynamic-4-clstr2'
#
#sed -e "s/NFS_SERVER_IP/${NFS_SERVER_IP}/" -e "s/NFS_FOLDER_PATH/${NFS_PATH}/" scnfs/nfs-client/deploy/deployment-tmp.yaml | kubectl create -f -
#kubectl create -f scnfs/nfs-client/deploy/class.yaml
#kubectl create -f scnfs/nfs-client/deploy/auth/serviceaccount.yaml
#kubectl create -f scnfs/nfs-client/deploy/auth/clusterrole.yaml
#kubectl create -f scnfs/nfs-client/deploy/auth/clusterrolebinding.yaml
#kubectl patch deployment nfs-client-provisioner -p '{"spec":{"template":{"spec":{"serviceAccount":"nfs-client-provisioner"}}}}' -n kube-system
# Set it to default sc
#kubectl patch storageclass managed-nfs-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
#kubectl get sc
#
# haproxy
#
#IP='"210.140.46.223"'
KUBERNETES_API_ENDPOINT=localhost:6443
#
#PNUM=$(kubectl get svc -n kube-system | grep LoadBalancer);while [ $? != 0 ]; do sleep 1;echo -n .;PNUM=$(kubectl get svc -n kube-system | grep LoadBalancer); done
#PORT=$(echo $PNUM | sed 's/^.* 80:\([0-9]*\)\/.*$/\1/')
#if [ "x$PORT" = "x" ]
#then
#   echo "PORT not assigned: PNUM=$PNUM"
#fi
#sed "s/:PORT_NUM$/:${PORT}/" haproxy-tmp.cfg > haproxy.cfg
#docker run -d --name haproxy \
#  -p 80:80 \
#  -v $(pwd)/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
#  haproxy:1.8
#
# gettoken
#
# kubectl create -f role-kube-system.yaml
cat <<EOF | kubectl create -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kube-system
subjects:
- kind: ServiceAccount
  namespace: kube-system
  name: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
EOF
#
# export TOKEN
TOKEN=$(kubectl describe secret  \
  $(kubectl get secrets -n kube-system | grep default | cut -f1 -d ' ') -n kube-system | \
  grep -E '^token' | \
  cut -f2 -d':' | tr -d '\t' | tr -d ' ')
curl -k --header "Authorization: Bearer $TOKEN"   https://${KUBERNETES_API_ENDPOINT}/api/v1/namespaces/kube-system/services/jxing-nginx-ingress-controller/status
#
#sed -i "s/^ *$/      \"ingress\": [ { \"ip\": $IP } ]/" g.json
#
#curl -k --header "Authorization: Bearer $TOKEN"   https://${KUBERNETES_API_ENDPOINT}/api/v1/namespaces/kube-system/services/jxing-nginx-ingress-controller/status -X PUT -d @g.json -H 'content-type:application/json'
#

