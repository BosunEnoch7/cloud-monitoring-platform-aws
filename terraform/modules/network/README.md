# Network Module

Owns AWS networking resources for the platform.

## Resources

- VPC with DNS support and DNS hostnames enabled
- Public subnet with public IP assignment on launch
- Internet gateway
- Public route table with default internet route
- Route table association

## Why This Matters

This module creates the network foundation that later phases will use for the EC2 monitoring host. Keeping it separate from compute makes the infrastructure easier to reason about, test, and extend.
