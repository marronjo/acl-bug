# Reproduce ACL error in cofhe-mock-contracts

## TL;DR
cofhe-mock-contracts contains an access control bugs which allow for contracts to compute on encrypted values without necessary permission.
e.g. FHE.allow(handle) can be omitted and the tests will still pass. This means the local behaviour differs to testnet!

## Install Dependencies

Foundry and npm dependencies

```bash
forge install
pnpm install
```

## Run Tests
```bash
forge test
forge test -vvvv
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

#should fail
forge script script/Counter2Const.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast

#should succeed
forge script script/Counter2ConstAllowed.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```
