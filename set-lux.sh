#
# 
#
#IP=10.32.0.77
IP=nfs-lux
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
#
# Set it to default sc
#
kubectl patch storageclass managed-nfs-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
#
# lux using cl2_external
#
METAL_START=210.140.42.232
METAL_END=210.140.42.232
kubectl create -f metallb/metallb.yaml
sed -e "s/METAL_EXT_START/${METAL_START}/" -e "s/METAL_EXT_END/${METAL_END}/" metallb/l2-temp.yaml | kubectl create -f -
#kubectl create -f metallb/l2.yaml
cp ../helm /usr/local/bin/helm
ls -l /usr/local/bin/helm
kubectl get sc
#kubectl create ns jx

