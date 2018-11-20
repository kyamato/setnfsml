kubectl delete sc managed-nfs-storage
kubectl delete clusterrolebinding run-nfs-client-provisioner
kubectl delete clusterrole nfs-client-provisioner-runner
kubectl delete deploy nfs-client-provisioner -n kube-system
kubectl delete sa nfs-client-provisioner -n kube-system
