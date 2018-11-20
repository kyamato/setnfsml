# nfsによるPVとmetallbによるLoadBalancer対応のためのスクリプト

Jenkins-Xをインストールする際に必要なPVおよびmetllbの準備のためのスクリプトを提供します。

## 前準備
### Dynamic Provisioning storage classの提供
PVCのリクエストに応じ、Dynamic Provisining でPVを提供する機能をNFSサーバを準備して提供します。

あらかじめ、クラスタノードから到達可能範囲内にnfsサーバを構築し、クラスタノードからマウント可能であることを確認しておきます。

### metallbの提供
[metallb](https://github.com/google/metallb)
