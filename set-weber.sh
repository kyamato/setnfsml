#
# 
#
IP=10.31.0.134
#IP=nfs1
NFS_PATH='\/exports\/nfs01\/dynamic-4-'$(hostname)
ssh ${IP} "ls ${NFS_PATH} >& /dev/null"
if [ $? != 0 ]
then
  ssh ${IP} "mkdir ${NFS_PATH};chmod 777 ${NFS_PATH};chown nfsnobody: ${PATH}"
fi
sed -e "s/NFS_SERVER_IP/${IP}/" -e "s/NFS_FOLDER_PATH/${NFS_PATH}/" nfs-client/deploy/deployment-tmp.yaml | kubectl create -f -
kubectl create -f nfs-client/deploy/class.yaml
kubectl create -f nfs-client/deploy/auth/serviceaccount.yaml
kubectl create -f nfs-client/deploy/auth/clusterrole.yaml
kubectl create -f nfs-client/deploy/auth/clusterrolebinding.yaml
#
#  may be already applied ??
#
kubectl patch deployment nfs-client-provisioner -p '{"spec":{"template":{"spec":{"serviceAccount":"nfs-client-provisioner"}}}}' -n kube-system
#
# Set it to default sc
#
kubectl patch storageclass managed-nfs-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
#

METAL_START=203.137.188.176
METAL_END=203.137.188.176
kubectl create -f metallb/metallb.yaml
sed -e "s/METAL_EXT_START/${METAL_START}/" -e "s/METAL_EXT_END/${METAL_END}/" metallb/l2-temp.yaml | kubectl create -f -
#kubectl create -f metallb/l2.yaml
cp ../helm /usr/local/bin/helm
ls -l /usr/local/bin/helm
kubectl get sc
#kubectl create ns jx

