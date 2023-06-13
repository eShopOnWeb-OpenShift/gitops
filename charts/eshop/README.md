# eShopOnWeb Helm Chart

A Helm chart for deploying [eShopOnWeb](https://github.com/nmasse-itix/eShopOnWeb) on OpenShift.

## Pre-requisites

None.

## Values

Below is a table of each value used to configure this chart.

| Value | Description | Default | Additional Information |
| ----- | ----------- | ------- | ---------------------- |
| `database.serverHostname` | SQL Server hostname | `sql-server` |  |
| `database.name` | Database Name | `eShop` |  |
| `database.schema` | Database Schema | `eShop` |  |
| `database.username` | Username to access the database | `eShop` |  |
| `database.password` | Password to access the database | `R3dH4t1!` |  |
