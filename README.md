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

## Production mode

```shell
docker-compose -f deploy/compose/compose.yaml up
```
