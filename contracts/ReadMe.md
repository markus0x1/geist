# To deploy the contracts to localhost

## spin up local instance
``` bash
anvil
``` 
## read .env file
``` bash
source .env
``` 
## run deployment

``` bash
forge script script/Deploy.s.sol:DeployFull --fork-url http://localhost:8545 --broadcast
``` 

# To deploy the contracts to goerli

``` bash
forge script script/Deploy.s.sol:DeployFull --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv
``` 





