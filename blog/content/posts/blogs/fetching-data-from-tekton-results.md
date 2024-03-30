---
category: blogs
date: 2023-07-19T18:08:00
description: In the last post, I described how to install Tekton Results on a Kubernetes
  cluster. In this post, we will see how to use Tekton Results to store the results
  of a PipelineRun and how to retrive them later.
image: /images/tekton-results-retrieve.webp
tags:
- tekton
- kubernetes
- redhat
- openshift
- results
title: Tekton Results - Storing and Retrieving Results
---

In the [last post](/posts/blogs/hey-tekton-results/), I described how to install
Tekton Results on a Kubernetes cluster. In this post, we will see how to use Tekton
Results to store the results of a PipelineRun and how to retrive them later.

## Creating a PipelineRun/TaskRun

Let us create a simple PipelineRun to see how Tekton Results works. Here is a simple
PipelineRun that I created for this demo.

- Create a PipelineRun YAML file.

  ```sh
  cat <<EOF > demo-pipeline-run.yaml
  apiVersion: tekton.dev/v1beta1
  kind: PipelineRun
  metadata:
    name: demo-pipeline-run
  spec:
    pipelineRef:
      name: demo-pipeline
      tasks:
        - name: demo-task
          taskSpec:
            steps:
              - name: demo-step
                image: alpine
                script: |
                  echo "Hello World"
  EOF
  ```

- Create the PipelineRun.

  ```bash
  kubectl apply --filename demo-pipeline-run.yaml
  ```

## Querying the Results API

There are three ways to query the Results API. The simplest way is to use
`tkn-results` CLI. You can also use `curl` or any other HTTP client as well as
a gRPC client. I will go through all three methods. Before we start, we have to
create a ServiceAccount and a ClusterRoleBinding to access the API.

- Create a ServiceAccount for quering the API.

  ```bash
  kubectl create sa tekton-results-query -n tekton-pipelines
  ```

- Grant readonly permissions to the ServiceAccount

  ```bash
  kubectl create clusterrolebinding tekton-results-query \
    --clusterrole=tekton-results-readonly
    --serviceaccount=tekton-pipelines:tekton-results-query
  ```

- Create an access token

  ```bash
  export ACCESS_TOKEN=$(kubectl create token tekton-results-query -n tekton-pipelines)
  ```

- Expose the results API server, this will block so run in a separate shell.

  ```bash
  kubectl port-forward --namespace tekton-pipelines \
    service/tekton-results-api-service 8080:8080
  ```

### Using `tkn-results` CLI

We are not releasing the CLI yet, but you can install it using Go. You will need
[Go](https://golang.org/doc/install) installed on your machine.

- Install `tkn-results`

  ```bash
  GOBIN=${TKN_PLUGINS_DIR:-"${HOME}/.config/tkn/plugins"} \
    go install github.com/tektoncd/results/tools/tkn-results@latest
  ```

- Query the API, pass `--insecure` flag if you are using a self-signed certificate. In place of `default` you can pass the namespace name. `-` means all namespaces.

  ```bash
  tkn-results list --insecure \
    --addr http://localhost:8080
    --authtoken $ACCESS_TOKEN
    default
  ```

  You will get a response like below.

  ```bash
  Name                                                  Start                                   Update
  default/results/dcb7926e-42e8-4338-ab7d-0b67e02389be  2023-06-13 12:04:49 +0530 IST           2023-06-13 12:09:07 +0530 IST
  ```

- Similarly you can query Records for a particular PipelineRun or TaskRun Result.

  ```bash
  tkn-results records list --insecure \
    --addr http://localhost:8080
    --authtoken $ACCESS_TOKEN
    default/results/dcb7926e-42e8-4338-ab7d-0b67e02389be
  ```

  You will get a response like below. Notice that there are two records, one for the PipelineRun and one for the TaskRun.

  ```bash
  Name                                                                                               Type                                    Start                                   Update
  default/results/dcb7926e-42e8-4338-ab7d-0b67e02389be/records/dcb7926e-42e8-4338-ab7d-0b67e02389be  tekton.dev/v1beta1.PipelineRun          2023-06-13 12:04:51 +0530 IST           2023-06-13 12:19:09 +0530 IST
  default/results/dcb7926e-42e8-4338-ab7d-0b67e02389be/records/64a0ab6e-9b90-4e5e-a072-e44d8ff27467  tekton.dev/v1beta1.TaskRun              2023-06-13 12:06:14 +0530 IST           2023-06-13 12:07:52 +0530 IST
  ```

- Finally you can get a single record too.

  ```bash
  tkn-results records list --insecure \
    --addr http://localhost:8080
    --authtoken $ACCESS_TOKEN
    default/results/dcb7926e-42e8-4338-ab7d-0b67e02389be/records/dcb7926e-42e8-4338-ab7d-0b67e02389be
  ```

  You will get a response like below.

  ```json
  {
  "name": "default/results/dcb7926e-42e8-4338-ab7d-0b67e02389be/records/dcb7926e-42e8-4338-ab7d-0b67e02389be",
  "id": "50b13d54-2eb0-4a45-8399-853f2d4ba028",
  "uid": "50b13d54-2eb0-4a45-8399-853f2d4ba028",
  "data": {
    "type": "tekton.dev/v1beta1.PipelineRun",
    "value": "eyJraW5kIjogIlBpcGVsaW5lUn<base64-encode-data-truncated-for-brevity>"
    },
  "etag": "50b13d54-2eb0-4a45-8399-853f2d4ba028-1686638949162394019",
  "createdTime": "2023-06-13T06:34:51.320028Z",
  "createTime": "2023-06-13T06:34:51.320028Z",
  "updatedTime": "2023-06-13T06:49:09.162394Z",
  "updateTime": "2023-06-13T06:49:09.162394Z"
  }
  ```

### Using `curl`

Using curl is similar to using `tkn-results` CLI. You can use the same access
token and the same API server address. The only difference is that you have to
pass the access token as a header and provide the API path depending on what
you want to query.

- Query the results

  ```bash
  curl --insecure \
    -H "Authorization: Bearer $ACCESS_TOKEN"
    -H "Accept: application/json"
    https://localhost:8080/apis/results.tekton.dev/v1alpha2/parents/default/results
  ```

  You will get a response like below.

  ```json
  {
  "results": [
    {
      "name": "default/results/dcb7926e-42e8-4338-ab7d-0b67e02389be",
      "id": "50b13d54-2eb0-4a45-8399-853f2d4ba028",
      "uid": "50b13d54-2eb0-4a45-8399-853f2d4ba028",
      "createdTime": "2023-03-02T07:26:48.972907Z",
      "createTime": "2023-03-02T07:26:48.972907Z",
      "updatedTime": "2023-03-02T07:26:54.191114Z",
      "updateTime": "2023-03-02T07:26:54.191114Z",
      "annotations": {},
      "etag": "50b13d54-2eb0-4a45-8399-853f2d4ba028-1677742014191114634",
      "summary": {
        "record": "default/results/dcb7926e-42e8-4338-ab7d-0b67e02389be/records/dcb7926e-42e8-4338-ab7d-0b67e02389be",
        "type": "tekton.dev/v1beta1.PipelineRun",
        "startTime": null,
        "endTime": "2023-03-02T07:26:54Z",
        "status": "SUCCESS",
        "annotations": {}
      }
    }
  ],
  "nextPageToken": ""
  }
  ```

You can also use filters to query record for a particular (set of) PipelineRun
or TaskRun. See the available filters [here](https://github.com/tektoncd/results/blob/main/docs/api/README.md#filtering).

### Using gRPC

You can also use gRPC to query the API. You can use the same access token. You
will need to [install](https://github.com/grpc/grpc/blob/master/doc/command_line_tool.md)
`grpc_cli` to query the API.

- Querying using gRPC will need cert. Here is how to export them.

  ```bash
  kubectl get secrets tekton-results-tls -n tekton-pipelines \
    --template='{{index .data "tls.crt"}}' | base64 -d > /tmp/results.crt
  export GRPC_DEFAULT_SSL_ROOTS_FILE_PATH=/tmp/results.crt
  ```

- List available services

  ```bash
  grpc_cli ls --channel_creds_type=ssl \
    --ssl_target=tekton-results-api-service.tekton-pipelines.svc.cluster.local \
    localhost:8080
  ```

  You will get a response like below.

  ```bash
  grpc.health.v1.Health
  grpc.reflection.v1alpha.ServerReflection
  tekton.results.v1alpha2.Results
  ```

- List the Results

  ```bash
  grpc_cli call --channel_creds_type=ssl \
    --ssl_target=tekton-results-api-service.tekton-pipelines.svc.cluster.local \
    --call_creds=access_token=$ACCESS_TOKEN
    localhost:8080
    tekton.results.v1alpha2.Results.ListResults 'parent: "default"'
  ```

  You will get a response like below.

  ```bash
  connecting to localhost:8080

  results {
    name: "default/results/7afa9067-5001-4d93-b715-49854a770412"
    id: "b74a3317-e6c0-421c-85d9-54b0f3d4b4c6"
    created_time {
      seconds: 1677742028
      nanos: 143729000
    }
    etag: "b74a3317-e6c0-421c-85d9-54b0f3d4b4c6-1677742039224211588"
    updated_time {
      seconds: 1677742039
      nanos: 224211000
    }
    uid: "b74a3317-e6c0-421c-85d9-54b0f3d4b4c6"
    create_time {
      seconds: 1677742028
      nanos: 143729000
    }
    update_time {
      seconds: 1677742039
      nanos: 224211000
    }
    summary {
      record: "default/results/7afa9067-5001-4d93-b715-49854a770412/records/7afa9067-5001-4d93-b715-49854a770412"
      type: "tekton.dev/v1beta1.TaskRun"
      end_time {
        seconds: 1677742039
      }
      status: SUCCESS
    }
  }
  ```

Similar to curl you can pass filters here as well.

## Conclusion

In this post, we saw how to use Tekton Results to store the results of a PipelineRun
or TaskRun and how to query them later. Tekton Results is still in alpha, we are
working on adding more features to it. If you have any feedback or feature request,
please feel free to open an issue [here](https://github.com/tektoncd/results/issues)
or reach out to us on [Slack](https://tektoncd.slack.com/). Thanks for reading!

## References

- [Tekton Results](https://github.com/tektoncd/results)
- [Tekton Pipelines](https://github.com/tektoncd/pipeline)
- [Tekton Results API Specification](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/tektoncd/results/v0.7.0/docs/api/openapi.yaml)
- [Tekton Results CLI](https://github.com/tektoncd/results/tree/main/tools/tkn-results)
