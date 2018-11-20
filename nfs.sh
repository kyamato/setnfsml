#
# 
#
IP=10.32.0.77
NFS_PATH='\/exports\/nfs01\/dynamic-4-clstr2'
sed -e "s/NFS_SERVER_IP/${IP}/" -e "s/NFS_FOLDER_PATH/${NFS_PATH}/" nfs-client/deploy/deployment-tmp.yaml | kubectl create -f -
kubectl create -f nfs-client/deploy/class.yaml
kubectl create -f nfs-client/deploy/auth/serviceaccount.yaml
kubectl create -f nfs-client/deploy/auth/clusterrole.yaml
kubectl create -f nfs-client/deploy/auth/clusterrolebinding.yaml
#
#  may be already applied ??
#
kubectl patch deployment nfs-client-provisioner -p '{"spec":{"template":{"spec":{"serviceAccount":"nfs-client-provisioner"}}}}' -n kube-system
#kubectl patch deployment nfs-client-provisioner -p '{"spec":{"template":{"spec":{"serviceAccount":"nfs-client-provisioner"}}}}' 
#
# Set it to default sc
#
kubectl patch storageclass managed-nfs-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
#

#kubectl create -f metallb/metallb.yaml
#kubectl create -f metallb/l2.yaml
#cp helm /usr/local/bin/helm
#ls -l /usr/local/bin/helm
kubectl get sc
#kubectl create ns jx

