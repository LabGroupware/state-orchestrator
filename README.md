## LabGroupware for API Composition + State Based Pattern Implementation

### Prerequire
- [asdf](./setup_asdf.md)


### Setup
#### コマンドセットアップ
``` sh
asdf plugin add terraform
asdf plugin add awscli
asdf plugin add kubectl
asdf plugin add helm
asdf plugin add istioctl
asdf install
```

### Helm Push

#### Debezium Connector
``` sh
./helm-push.sh debezium-connector
```

#### Auth Server
```sh
./helm-push.sh auth-server
```

#### Kafka Stack
```sh
./helm-push.sh kafka-stack
```

### Deploy
```sh
helm plugin install https://github.com/databus23/helm-diff
./prod-deploy.sh
```