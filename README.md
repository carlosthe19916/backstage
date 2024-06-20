# [Backstage](https://backstage.io)

## Development mode

### Requirements

- NodeJS >=18
  - You can use [NVM](https://github.com/nvm-sh/nvm) or any method of your preference.
- Yarn
  - Use the [official documentation](https://classic.yarnpkg.com/en/docs/install) which boils down to `npm install --global yarn`
- Clone this repository:

```
git clone https://github.com/carlosthe19916/backstage.git
```

Move your terminal to the folder where you cloned the repository and then, run:

```sh
yarn install
yarn dev
```

Open your browser at http://localhost:3000

## Production mode

### Docker Compose

```shell
docker-compose -f deploy/compose/compose.yaml up
```

Open your browser at http://localhost:7007

### Helm Chart

Requisites:

- A running instance of Kubernetes. E.g. [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- Helm. [Installing Helm](https://helm.sh/docs/intro/install/)

The following instruction were inspired by [backstage-charts](https://github.com/backstage/charts/tree/main/charts/backstage)

- Create configuration:

```shell
kubectl create -f deploy/k8s/chart/config-map.yaml
```

- Create secrets (manually edit it before creating it):

```shell
kubectl create -f deploy/k8s/chart/secret.yaml
```

- Add helm repos:

```shell
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add backstage https://backstage.github.io/charts
```

- Instantiate backstage:

```shell
helm install my-release backstage/backstage -f deploy/k8s/chart/values.yaml
```

- Wait until the database and backstage start. You can access to backstage with:

```shell
kubectl port-forward service/my-release-backstage 7007:7007
```

- To uninstall backend run:

```shell
helm uninstall my-release
```
