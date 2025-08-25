# Burn-to-Mint Governance Token

A Clarity smart contract that implements a governance token with a unique burn-to-mint mechanism on the Stacks blockchain.

## Overview

This contract allows users to burn STX tokens to mint governance (GOV) tokens at a 1:1 ratio. The token implements the [SIP-010](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md) fungible token standard.

## Features

- **Burn-to-Mint Mechanism**: Users can burn STX to mint GOV tokens
- **Fixed Supply Cap**: Maximum supply capped at 1,000,000 GOV tokens
- **SIP-010 Compliant**: Implements the Stacks fungible token standard
- **1:1 Ratio**: 1 STX burned = 1 GOV token minted

## Contract Functions

### Read-Only Functions
- `get-name`: Returns token name
- `get-symbol`: Returns token symbol "GOV"
- `get-decimals`: Returns decimal places (6)
- `get-total-supply`: Returns current total supply
- `get-balance`: Returns balance for given principal

### Public Functions
- `transfer`: Transfer tokens between accounts
- `burn-to-mint`: Burn STX to mint new GOV tokens

## Usage

```clarity
;; Mint 100 GOV tokens by burning 100 STX
(contract-call? .burn-to-mint-token burn-to-mint u100)

;; Transfer 50 GOV tokens
(contract-call? .burn-to-mint-token transfer u50 tx-sender 'RECIPIENT)
```

## Error Codes

- `u100`: Supply cap exceeded
- `u101`: Invalid amount
- `u102`: Insufficient balance

## Development

To deploy and test this contract:

1. Clone the repository
2. Install [Clarinet](https://github.com/hirosystems/clarinet)
3. Run tests: `clarinet test`

## License

MIT License
