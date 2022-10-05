#### Static Application Security Testing

[![Semgrep](https://github.com/shefirot/caldera_cloud/actions/workflows/semgrep.yml/badge.svg)](https://github.com/shefirot/caldera_cloud/actions/workflows/semgrep.yml)
#### Last actions state
[![Deploy infrastructure](https://github.com/shefirot/caldera_cloud/actions/workflows/deploy_infrastructure.yaml/badge.svg)](https://github.com/shefirot/caldera_cloud/actions/workflows/deploy_infrastructure.yaml)
[![Destroy infrastructure](https://github.com/shefirot/caldera_cloud/actions/workflows/destroy_infrastructure.yaml/badge.svg)](https://github.com/shefirot/caldera_cloud/actions/workflows/destroy_infrastructure.yaml)
[![Gen image Packer](https://github.com/shefirot/caldera_cloud/actions/workflows/gen_image_packer.yml/badge.svg)](https://github.com/shefirot/caldera_cloud/actions/workflows/gen_image_packer.yml)
#### Table of contents

[About The Repository](#about-the-repository)<br>
[Usage](#usage)<br>
[Add New Account](#add-new-account)<br>
[To Continue Working](#to-continue-working)

## About The Repository
Deploy a Mitre Caldera laboratory to pass Red Team tests on the different cloud providers and subscriptions on 
the same cloud.

This repository is still under development, remaining to install Windows machine using Ansible on AWS, and deploy 
and install con Azure.

Currently, it deploys a Caldera server and a Linux host with the Qualys agent installed on both machines. 
And Windows machine, on AWS, installed with "user data" functionality, and Azure without installing anything.
This is done using a pipeline for deployment and another one for destruction, to minimize costs once 
the tests are finished. It also has an additional pipeline to generate a basic Ubuntu 22.04 image 
with Packer, in case it is necessary to use custom images. These pipelines are built with GitHub 
Actions and all confidential information are stored as secrets inside this repository.

<img src="/docs/images/laboratory_schema.jpg" width="700"/><br>

The infrastructure is generated and destroy, using Terraform. Caldera software and agents are installed using separate 
Ansible modules.

<img src="/docs/images/deploy_details.jpg" width="700"/><br>

All code has been made as modular as possible with the intention of being reusable in other projects.

## Usage
Usage of the repository.

### To deploy this laboratory follow these steps:
* Click on the Actions tab -> Deploy infrastructure workflow.<br>
<img src="/docs/images/actions_tab.jpg"/>

* Select the cloud and the account where you want to deploy the lab, (if it does not appears read the add new account 
section) and click on "Run workflow".
<img src="/docs/images/run_workflow.jpg"/>

* Wait until deployment is complete.<br>
<img src="/docs/images/deploy_complete.jpg"/>

* Select the "deploy-caldera-hosts" job -> deploy the "Terraform apply" task and from the outputs get the information
to connect to the lab. <br>
<img src="/docs/images/deploy_apply_outputs.jpg"/>

### To destroy the lab we must follow these steps:
* Click on the Actions tab -> destroy infrastructure.<br>
<img src="/docs/images/actions_tab.jpg"/>

* Select the cloud and the account where you want to destroy the lab and click on "Run workflow".<br>
<img src="/docs/images/run_workflow.jpg"/>

* Wait until the pipeline is done for the lab was being destroyed.<br>
<img src="/docs/images/destroy_success.jpg"/>

## Add New Account

To add a new account in which to deploy the laboratory, first, you would choose a short name that uniquely identifies 
the account, only alphanumeric characters are allowed.  

### Add variables file

### Edit the workflow files
Doing that appears as an option in the drop-down menu, to do so:

1. In the repository, in the code tab -> .github -> workflows.<br>
<img src="/docs/images/workflows.jpg"/>

2. Open the "deploy_infrastructure.yaml" file -> edit it.<br>
<img src="/docs/images/edit_repo_file.jpg"/>

3. In the file go to, "on:" -> "workflow_dispatch:" -> "inputs:" -> "account:" -> "options:", add preceded by a hyphen
and respecting the indentation, the name of the account to add.<br>
4. On the right side click on "Start commit", add a title and a description and upload the changes with "Commit changes".<br>
<img src="/docs/images/commit_changes.jpg"/>

5. Repeat steps 2 to 4 with the file "destroy_infrastructure.yaml".

### Add secrets
Next, must be added the credentials and sensitive data to be used to the deployment. 

The cloud data requirements are:
* For Azure, the Service Principal, must have the client id (ID), client secret (SECRET), subscription id.
(SUBSCRIPTION), and tenant id (TENANT).
* For AWS the client id (ID) and the access key (KEY).

Add the relevant secrets (sub-section add secret) of the cloud on what you want to deploy, following 
this nomenclature of name and all in capital letters, "<CLOUD>_<ACCOUNTNAME>_<SECRET>". For example 
for the DETECT Azure account, you have to create 4 secrets:
* AZURE_DETECT_CLIENT, with the client id. 
* AZURE_DETECT_SECRET, with client secret
* AZURE_DETECT_SUBSCRIPTION, with the subscription id
* AZURE_DETECT_TENANT, with the tenant id

And for the same account but in AWS:
* AWS_DETECT_ID, with the client id
* AWS_DETECT_KEY, with the access key

Another sensitive data to provide is the license for the Qualys agent, for this, a secret is created 
(sub-section add secret), with the nomenclature of name, "<ACCOUNTNAME_QUALYS>", the secret must 
have the following structure, "ActivationId=xxxx CustomerId=xxxxxx", all in the same secret and leaving 
a space between the Activation Id and the Customer Id.<br>
<img src="/docs/images/secrets_examples.jpg"/><br>

### Create a secret

* Go to the "Settings" tab of the repository -> Secrets -> Actions.<br>
<img src="/docs/images/settings_options.jpg"/>

* Click on "New repository secret", for the name follow the agreed nomenclature.<br>
<img src="/docs/images/new_secret.jpg"/>

* Click on "Add secret"

## To Continue Working

A list future task:
* Install Windows machine using Ansible modules for AWS.
* Deploy and install Windows machine using Ansible modules for Azure.
