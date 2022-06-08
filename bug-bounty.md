# Qilin V2 Mainnet Bug Bounty

## Overview
Following our V2 mainnet launch on April 21st, Qilin initiates a new round of its long-term Bug Bounty Program on Immunefi with a total reward of $20,000. The purpose of this program is to detect potential security vulnerabilities and resolve them before they have an impact on our users. We invite the public to test our product and report any bugs you find to earn reward. https://immunefi.com/bounty/qilin/

## Scope

This bug bounty program is focused on Qilin’s smart contracts including the following impacts in scope:

### Critical

- Any governance voting result manipulation
- Direct theft of any user funds, whether at-rest or in-motion, other than unclaimed yield
- Permanent freezing of funds
- Protocol Insolvency 
  
### High

- Theft of unclaimed yield
- Permanent freezing of unclaimed yield
- Temporary freezing of funds for at least 1 hour

## Rewards

Qilin is offering more than $20,000 USD in rewards for the community to help us secure our protocol by uncovering its vulnerabilities and shortcomings.

- Critical: $2,000
- High: $1,000

## Out of Scope & Rules

The following vulnerabilities are excluded from the rewards for this bug bounty program:

- Attacks that the reporter has already exploited themselves, leading to damage
- Attacks requiring access to leaked keys/credentials
- Attacks requiring access to privileged addresses (governance, strategist)
  
### Smart Contracts and Blockchain

- Incorrect data supplied by third party oracles
    - Not to exclude oracle manipulation/flash loan attacks
- Basic economic governance attacks (e.g. 51% attack)
- Lack of liquidity
- Best practice critiques
- Sybil attacks
- Centralization risks 
  
### The following activities are prohibited by this bug bounty program:

- Any testing with mainnet or public testnet contracts; all testing should be done on private testnets
- Any testing with pricing oracles or third party smart contracts
- Attempting phishing or other social engineering attacks against our employees and/or customers
- Any testing with third party systems and applications (e.g. browser extensions) as well as websites (e.g. SSO providers, advertising networks)
- Any denial of service attacks
- Automated testing of services that generates significant amounts of traffic
- Public disclosure of an unpatched vulnerability in an embargoed bounty