# To deploy the contracts to localhost

## Deployments

# Goerli
  Contract Factory: 0x9f7ba16e9419FDa0F9A1d89F9209fa75Dd15360D
  Example Wallet: 0x4996F9c81D43A28Eaf61D62a6AcCc8dA22E52CaF
  Example GHO: 0xC371784D819E7E64b3869601889f60C6F64cDcfF

# Sepolia
  Contract Factory: 0xDe971e346B3a261c90128Dd12E03D41F388A9f32
  Example Wallet: 0x066EA94CFE6bbeA8B11159C7a99AAe2360f95062
  Example GHO: 0xAC7466fDA260722261CCEc877c4151a2921366D4

# Mumbai
  Contract Factory: 0x59092cCcB8876521f5f6CD083C7eB2846f3C7Bff
  Example Wallet: 0x7506A786fed1F95e8d1bEB6d1fda031c3d19A402
  Example GHO: 0x1fD49Ef8A98e51bd7f793eD6778ed173a4048c17

# Optimism Goerli
  Contract Factory: 0x291B0B33216Ef810aAF72249dD9E14ba8c473477
  Example Wallet: 0x2Fe95236E08e5A4205A5c77230fC004fF8a2af19
  Example GHO: 0x59092cCcB8876521f5f6CD083C7eB2846f3C7Bff

## spin up local instance
``` bash
anvil
``` 
## read .env file
``` bash
source .env
``` 
## run deployment to local 

create local node

``` bash
anvil
```

deploy to local node 

``` bash
forge script script/Deploy.s.sol:DeployFull --fork-url http://localhost:8545 --broadcast
``` 

# To deploy the contracts to live network

``` bash
forge script script/Deploy.s.sol:DeployFull --rpc-url MY_RPC_URL --broadcast --verify -vvvv
``` 





