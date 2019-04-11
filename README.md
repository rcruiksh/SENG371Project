# SENG371Project

## Setup

### Pre Requisites

- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [AWS CLI]()

It is also assumed that you have logged into the AWS CLI and that you have the appropriate permissions to deploy all necessary infrastructure defined in the Terraform template.

```bash
tf init
```

## Deployment

The deployment is done entirely using Terraform! Feel free to browse the terraform file to see what has been defined. Simply by running the following commands, the infrastructure will be prepared to run.

>Note: You will want to change the variable for the bucket prefix as defined in the template if deploying on your own. This is because all S3 bucket names must be unique across all of AWS.

```bash
./zip.sh # mac/linux shell
tf plan # Do this if you want to make a plan to confirm infrastructure. Otherwise just use apply
tf apply

# If specifying a unique bucket name use the following command
tf apply -var 'bucket-prefix=my_bucket_prefix'
```


## Interacting with the code

The current implementation is extremely basic, but provides a strong frame to be built on top of and works well as a proof of concept for how large amounts of satelite imagery could be processed in parallel.

The best way to see what the code does is to open up the AWS console and upload a `.txt` file to the queue bucket. Once this is done, wait around 10 seconds, and open the output bucket. In there a file will exist with the same name prepended with a unique identifier. Download this file and open it up to see what the Lambda has done to modify the file.

## The nitty gritty

How everything works!

Firstly, there are 2 S3 buckets, one called queue and one called output. Secondly, there is a Lambda function called `dsa` (Data Science Algorithm for short). Finally, there is a specific notification (trigger) setup for the queue bucket, such that when an item is added to the bucket it triggers the lambda. Everything else that exists for infrastrucutre are things related to permissions, allowing the application components to interact with eachother.

When the lambda is triggered the name of the object in S3 is passed in and the lambda itself downloads the file. The lambda then makes modifications to the file, and uploads the modified file to the output bucket.
