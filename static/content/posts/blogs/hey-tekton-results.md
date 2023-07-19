---
category: blogs
date: 2023-03-16T20:47:00
description: Tekton Results aims to help users logically group CI/CD workload history
  and separate out long term result storage away from the Pipeline controller.
image: /images/tekton-results-wall.webp
tags:
- tekton
- kubernetes
- redhat
- openshift
- results
title: Tekton Results to the Rescue
---

What do you do with your Tekton Pipelines once it finishes? Depending on if it
failed or passed, you may keep it to inspect the logs. For most of the users/organizations
the simplest step is to keep the completed TaskRuns/PipelineRuns object on the
cluster to retrieve the data later.

Imagine having thousands of runs and although a single TaskRun object takes very
small space compared to the scale of a production cluster, but these little
things add up quickly, and soon your cluster will be burdened with objects that
probably no one will ever revisit. The organization/user is keeping them
just-in-case if they want to see the logs and other data later.

Although in most of the cases there is a pruning policy that takes care of these
objects. But there are multiple problems with this approach.

- This type of storage is not reliable and very difficult to query.
- If the scale is massive, this could lead to destabilization of the cluster.
- If you have a pruning policy, the completed objects are cleaned, and you lose all the associated data as well.

So, what is the solution, how can you save your pipelines' data without having to keep them on cluster?

## Introducing Tekton Results

As mentioned on the [project repository](https://github.com/tektoncd/results):

> Tekton Results aims to help users logically group CI/CD workload history and
> separate out long term result storage away from the Pipeline controller. This
> allows you to:
>
> - Provide custom Result metadata about your CI/CD workflows not available in
>   the Tekton TaskRun/PipelineRun CRDs (for example: post-run actions)
> - Group related workloads together (e.g. bundle related TaskRuns and PipelineRuns into a single unit)
> - Make long-term result history independent of the Pipeline CRD controller,
>   letting you free up etcd resources for Run execution.

In short, Tekton results archives the run data (called results) and logs to an
external storage. Now you can safely prune completed TaskRuns/PipelineRuns and
save run data and logs for a later visit. Let us see how actually Tekton Results
works under the hood.

### How Tekton Results Works?

Tekton Results is composed of two main components.

- A **watcher** to listen to creation/update of PipelineRuns or TaskRuns.
- An **API Server** to query the persistent storage for data.

In addition to that, Tekton Results needs a working database connection that can
be a persistent storage on the same cluster or hosted externally such as RDS.
If no external storage is attached, logs are also stored on a persistent storage
on the cluster, you may use a S3 (or compatible) storage solution for that.

The lifecycle of a _result_ is as below:

1. The first step is to create a Tekton PipelineRun or TaskRun.
2. The Watcher listens for any changes in the TaskRun or PipelineRun.
3. On change, Watcher updates (or creates) a corresponding `Record` or `Result` using the Results API.
   Watcher adds annotations to the TaskRuns or PipelineRuns with proper identifiers. Watcher uses
   these annotations to decide if the `Result` has been created/updated/finished or not.
4. You can now query the Results data using the API. If the run state is incomplete yet, the response
   from the API will indicate that as well via the status flag.
5. Once the TaskRun/PipelineRun has been completed, you can safely prune the resource object.

## Installing Tekton Results

Installing Tekton Results is easy. You can use Kubernetes or OpenShift cluster, for this particular
demonstration, I will be using a Kind cluster and a local database.

### Prerequisites

- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) for a local Kubernetes cluster.
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [curl](https://curl.se/download.html) for querying the API.
- [OpenSSL](https://www.openssl.org/source/) for generating certificates.

### Let's start

1. Create a Kind Cluster

   ```bash
   kind create cluster --name tekton-results
   kind export kubeconfig --name tekton-results
   ```

2. [Tekton Pipelines](https://github.com/tektoncd/results) must be installed on
   the cluster. You can install it using the command below.

   ```bash
   kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
   ```

3. Generate a database root password and store as a Kubernetes Secret. If you are using an external
   database, prove the credential for the same. Here is a bare minimum requirement as YAML.

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: tekton-results-postgres
     namespace: tekton-pipelines
   type: Opaque
   data:
     POSTGRES_USER: postgres
     POSTGRES_PASSWORD: <your-password>
   ```

   You can directly use the command line as well:

   ```bash
   kubectl create secret generic tekton-results-postgres \
     --namespace="tekton-pipelines" \
     --from-literal=POSTGRES_USER=postgres \
     --from-literal=POSTGRES_PASSWORD=$(openssl rand -base64 20)
   ```

4. Generate a cert/key pair. You may use any cert management software to generate this. You can even
   use cluster generated certs.

   ```bash
   openssl req -x509 \
     -newkey rsa:4096 \
     -keyout key.pem \
     -out cert.pem \
     -days 365 \
     -nodes \
     -subj "/CN=tekton-results-api-service.tekton-pipelines.svc.cluster.local" \
     -addext "subjectAltName = DNS:tekton-results-api-service.tekton-pipelines.svc.cluster.local"
   ```

5. Create another TLS Kubernetes Secret with the name `tekon-results-tls` to store the cert/key pair.

   ```bash
   kubectl create secret tls -n tekton-pipelines tekton-results-tls \
     --cert=cert.pem \
     --key=key.pem
   ```

6. Install Tekton Results

   ```bash
   kubectl apply -f https://storage.googleapis.com/tekton-releases/results/latest/release.yaml
   ```

7. You can check the status of the deployments using the below command. Do not worry
   if some deployments show `CrashLoopBackOff`. Wait for some time, and
   they should all be running.

   ```bash
   kubectl get pods -n tekton-pipelines --watch
   ```

Once all deployments are ready, we can start creating some TaskRuns/PipelineRuns. In the next part
of this blog, I will explain how to retrieve data from Tekton Results. Happy Reading.

## References

- [Tekton Results](https://github.com/tektoncd/results)
- [Tekton Pipelines](https://github.com/tektoncd/pipeline)
