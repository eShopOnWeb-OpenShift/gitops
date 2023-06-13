# SQL Server 2019 Helm Chart

A Helm chart for deploying [Microsoft SQL Server 2019](https://www.microsoft.com/en-us/sql-server/sql-server-2019) on OpenShift.

## Pre-requisites

None.

## Values

Below is a table of each value used to configure this chart.

| Value | Description | Default | Additional Information |
| ----- | ----------- | ------- | ---------------------- |
| `saPassword` | Administrator Password | `R3dH4t1!` |  |
| `database.name` | Database Name | `eShop` |  |
| `database.schema` | Database Schema | `eShop` |  |
| `database.owner.username` | Username to access the database | `eShop` |  |
| `database.owner.password` | Password to access the database | `R3dH4t1!` |  |
