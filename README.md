# Reproduce ACL error in cofhe-mock-contracts

## TL;DR
cofhe-mock-contracts contains an access control bugs which allow for contracts to compute on encrypted values without necessary permission.
e.g. FHE.allow(handle) can be omitted and the tests will still pass. This means the local behaviour differs to testnet!

> 🚧 **Fixed** This bug was uncovered in the Foundry tests which are run as a single transaction. The ACL gave transient allowance to the test contract to edit the encrypted values, since the values were all updated in a single transaction it worked. Added the isolate flag to the foundry.toml to ensure each contract interaction is performed in a separate transaction. This means the transient allowance is remove after the first transaction and subsequent transactions will fail ... which is the correct behaviour and same as testnet!

```toml
# foundry.toml
isolate = true
```

## Install Dependencies

Foundry and npm dependencies

```bash
forge install
pnpm install
```

## Run Tests
```bash
forge test
forge test -vvvv    #add verbose logging (recommended)
```

## Run Scripts (Testnet)

1. Rename .env.example -> .env
2. Add private key and rpc url
3. Update source ...

```bash
source .env
```

scripts...
```bash
#should fail
forge script script/Counter1Const.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast

#should fail
forge script script/Counter1Trivial.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```
