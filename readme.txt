1. Terraform & Infrastructure-as-Code (IaC)

Write Terraform code to:
1. Create the VPC and subnets. - Done 
2. Create the GKE cluster with 2 node pools. - Done
3. Store Terraform states in a GCS bucket. - Done

4. Explain how you would automate the process using TFActions. - Done
TFActions is a framework for developing and automating Terraform workflow using GitHub Actions under one mono repo, including managing Terraform configuration far easier. You're saving yourself from running these four commands - terraform init, terraform plan, terraform apply as your GitHub Actions will save it for you, negating the need to directly invoke them on your laptop for every single change introduced within your infrastructure. How the process of the TFActions can be described below. 
1. Set Up Your GitHub Repository and Workflow
Start organizing a repository with a proper configuration for the Terraform files. Usually, such files go inside a specific directory /terraform. Afterward, in the repository, you'll have to, create a directory named .github/workflows to hold the GitHub Actions workflow files that will define and trigger the automation of Terraform.
2. Install TFActions in Your Repository
To use TFActions, you will need to configure it in your GitHub Actions workflow. TFActions provides predefined steps for running Terraform commands, which can be added to the workflow YAML file. The usage of these steps helps to avoid executing Terraform commands manually but uses GitHub Actions for that instead.
TFActions provides preconfigured workflows, but you can write your own if that fits better for your repository. This workflow is generally set to act upon changes to particular files, such as the Terraform files, inside the repository.
3. Monorepo Support
Another major good-to-know with TFActions, It does support mono repo. You can use it if you have submodules or separate directories within one main directory where you define several Terraform configurations targeting multiple environments or different components of your infrastructure. With TFActions, you can create and automate workflows for every single directory or submodule in your repository to isolate the Terraform command execution based on the changes made within parts of your repository.
By specifying the path to your Terraform configuration files in the workflow, TFActions knows to only run the relevant commands for the changed directories. This can simplify the whole automation process and ensure you don't accidentally apply Terraform changes to the wrong environment or configuration.
4. Automation of Terraform Workflows
TFActions provides a range of automation around common Terraform tasks, such as initialization, planning, and applying configurations. In simple terms, with any push to a branch, for example, TFActions will initialize the working directory by running terraform init, followed by terraform plan, to show changes that will affect the infrastructures. If it's a main branch, TFActions can automatically run terraform apply to perform the change.
It also helps in state management by automatically keeping Terraform's state files consistent across environments. This avoids all the issues that can be caused by manually handling state files and generally makes for a smoother workflow.
5. Environment-Specific Workflows
TFActions enables one to define environment-specific workflows, which is especially valuable in multi-environment settings, such as development, staging, and production. In this case, you would configure separate workflows or specify different directories for each environment and ensure that Terraform commands are applied only to the appropriate environment, minimizing the danger of accidentally overwriting crucial infrastructure.
This will be especially useful either in large teams or big organizations where different environments might have different configurations or different levels of access.
6. Integration with Terraform Cloud
If your team uses Terraform Cloud for remote state management or collaboration, TFActions provides seamless integration with Terraform Cloud APIs. You can run Terraform, monitor your workspaces, and maintain your infrastructure from GitHub Actions. You can keep this in one place and create an automated workflow for maintaining infrastructure.
With this integration, you'll also be able to manage your state files, and workspace configurations, and even utilize Terraform Cloud's collaboration features for further streamlining your Terraform workflows.
7. Extending and Customizing TFActions
TFActions is highly customizable for specific needs in your Terraform workflow, such as running tests before applying changes or integrating notifications with tools like Slack, you can extend your workflow with custom actions. You could configure TFActions to send notifications when a Terraform plan or apply has been completed or add additional checks to ensure the infrastructure changes meet your standards before being applied.
You can also use custom environment variables, handle sensitive data through GitHub Secrets, and integrate additional tools such as security scanners to make sure your Terraform configurations are safe and meet compliance requirements.
Summary
TFActions simplifies and automates Terraform workflows using GitHub Actions. It's particularly useful for teams working with mono repos by providing an easy way to manage infrastructure across several environments and configurations. By abstracting the common tasks of Terraform and introducing integration with Terraform Cloud, TFActions minimizes your operational overhead in manually managing Terraform executions so that you can spend much more time in development. With its flexibility and possibilities for customization, TFActions would be a great choice for any kind of automation of Terraform workflows in a GitHub-based CI/CD pipeline.

2. You need to set up a secure and isolated environment in GCP for a new project. The project will
use CloudSQL, GKE, and Redis, all within a custom VPC.


2. Write a brief summary explaining:

● How you would secure the setup.

1. Private IP Usage:
All services - CloudSQL, GKE, and Redis - shall use private IPs to restrict external access.
CloudSQL must be configured with no public IP, allowing access only to the internal resources.

2. Firewall Rules:
Use firewall rules to allow traffic only between authorized services. For example, GKE nodes should have access only to CloudSQL and Redis over private IPs.

3. Ingress/egress: 
Apply ingress/egress rules that restrict traffic to internal sources only and deny all external accesses unless required for public-facing applications.

4. VPC Service Controls:
Enable VPC Service Controls to help isolate sensitive data within the service and prevent its leakage to other Google Cloud services by default.

5. Encryption
Encryption of data should happen both at rest and during transport. Encryption in Transit CloudSQL and Redis enable encryption by default. Make sure all external traffic uses HTTPS and other secure protocols.

6. Monitoring & Logging:
Enable the Google Cloud Logging and Monitoring to monitor activity for the detection of security threats.
Cloud Audit Logs are enabled for API call monitoring, including the actions made by service accounts.

7. IAM Roles & Service Accounts:
Use IAM for granting the least privileges. Service accounts only need the permissions that are needed for their functions.
GKE service accounts should be scoped to only interact with resources such as CloudSQL and Redis when necessary.



● How you would optimize costs while maintaining high availability.

CloudSQL:

Enable CloudSQL High Availability with automatic failover for minimal downtime. It is more expensive this way, but the availability trade-off is worth it for production environments.
Use automatic storage increase to ensure you don't over-provision disk space and pay only for what is actually used.
Consider Committed Use Contracts to reduce the cost of CloudSQL over a longer period, such as 1-year or 3-year commitments.


GKE:

Enable Autopilot mode for GKE, which manages and scales the nodes of your cluster automatically. It saves costs by allocating just the amount of resources used.
Run non-critical workloads on preemptible VMs, which grant huge savings and they can be terminated at any moment.
Implement horizontal pod autoscaling in your GKE cluster, a resource that will automatically scale workloads up and down based on demand, further optimizing resources and cost.

Redis Cloud Memorystore:

For Redis, select the Standard tier because it offers high availability and better cost efficiency. You can scale your instance's size up or down based on usage patterns.
Use Redis persistence only when necessary because it has extra costs. Also, select scaling to demand to avoid over-provisioning.


Cost Control:

Utilize Google Cloud Cost Management tools like Cost Explorer and Budgets & Alerts to observe resource usage in order to ensure that the costs are optimized. Turn on sustained use discounts and Committed Use contracts, to decrease long-term costs of the infrastructure for such services as CloudSQL and GKE.

High Availability Setup:

Spread services, CloudSQL, Redis, and GKE across multiple zones inside one region to ensure the High Availability of each service. Make load balancing work in GKE and equally distribute the incoming load among the pods and/or services. Set up automatic failovers, which is a mission-critical service on your side for both CloudSQL and Redis. You achieve security and optimization with all these measures, which can guarantee the GCP setup will be secure and cost-effective while the setup will also meet the high availability requirements for a project.


5. A critical service running on GKE fails, causing downtime. Logs indicate a network timeout
between the application pods and CloudSQL.
Tasks:
1. Explain your approach to troubleshooting the issue.

Step 1: Verify Pod and Network Health
Check Pod Status: First, test the status of the application pods with kubectl get pods to check whether they are running or crashing, experiencing repeated restarts, and more. Study Pod Logs: Use kubectl logs <pod-name> to review application logs for any explicit errors or timeouts.

Check Pod Resource Usage: If timeouts occur, monitor resource consumption of pods - especially CPU, memory - that could explain such timeouts; use kubectl top pod <pod-name> or kubectl describe pod <pod-name>. 
CloudSQL Proxy: Where CloudSQL is used together with the CloudSQL proxy, make sure that the proxy is running correctly and healthy.


Step 2: Verify CloudSQL Connectivity
CloudSQL Proxy: Where CloudSQL is used together with the CloudSQL proxy, make sure that the proxy is running correctly and healthy.

Check Connection Details: Verify that the correct connection parameters are used, such as database IP, user credentials, and database name.

GKE Networking Configuration: The VPC, subnets, and firewall rules should be set up in such a way that the pods can communicate with CloudSQL. Review the VPC peering or private IP to connect to CloudSQL.

CloudSQL Availability: Utilize the Google Cloud Console to check the status of the CloudSQL instance for any maintenance windows or outages.


Step 3: Network Issues Between Pods and CloudSQL
Ping Test: Perform a basic ping or traceroute (using a debug pod in the same network) to make sure there are no basic networking issues between the application pods and CloudSQL. This will help identify if the issue is at the network level.

DNS Resolution: Make sure the application is using the correct DNS name or IP address to resolve CloudSQL. Test DNS resolution inside a pod with nslookup <CloudSQL-hostname>.


Step 4: Check GKE Networking Settings
Network Policies: A look at any implemented network policy that may be interfering with and preventing access from the pod to the CloudSQL instance. Networking policies may be interfering with allowing this traffic.

Firewall Rules: The appropriate firewall rules on Google Cloud are put in place for allowing communication between GKE pods to the CloudSQL.


Step 5: Review Logs for Latency or Errors
GKE Logs: Examine, if possible, errors warnings, or timeouts occurring via Stackdriver or Google Cloud Logging services for GKE.
CloudSQL Logs Check CloudSQL logs to show if there are some issues regarding performance, timeout for connection, or limitation resources impacting the database.


2. Describe tools and steps you would use to resolve the network timeout and prevent 
future occurrences.

A. Immediate Resolution
	1	Restart the Application Pods:
	◦	If network timeout persists, consider restarting the affected application pods by using kubectl delete pod <pod-name> to clean up any transient issues. This might also help in transient network issues or resource bottlenecks.
	2	Restart CloudSQL Connection:
	◦	Reconnect or restart the CloudSQL instance, which will work if there are small issues in networking or related to timeouts.
	◦	Make sure the CloudSQL instance is not experiencing high loads or resource starvation regarding resources such as CPU, memory, and disk space.
	3	Use CloudSQL Proxy:
	◦	If not in use, it's a good idea to set up the CloudSQL proxy to ensure secure and consistent connectivity between GKE and CloudSQL.
	4	Verify VPC Connectivity and Firewall Rules:
	◦	Ensure that incorrectly configured VPC or firewall rules are not blocking the traffic. Check the Cloud firewall settings to make sure that ingress and egress traffic is allowed.
	◦	Make Sure you document the whole process what was the issue, the resolution, and how to prevent it from happening again. 
     5. After Fixing the issues
            ◦	Make Sure you document the whole process what was the issue, the resolution, and how to prevent it from happening again.  		


