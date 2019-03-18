# SENG371Project

## Setup

### Pre Requisites

- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

It is also assumed you have setup an Azure subscription through the [Azure portal](https://portal.azure.com/#blade/Microsoft_Azure_Billing/BillingMenuBlade/Subscriptions) and have logged into the Azure CLI using `az login`

```bash
tf init
```

## Deployment

```bash
./zip.sh # mac/linux shell
tf plan
tf apply
```
