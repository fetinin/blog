---
title: "Kubectl cheatsheet"
date: 2022-12-10
draft: false
tags: ["k8s", "kubectl"]
---
Throughout the years of using kubernetes as a developer I've collected a bunch of useful commands that helped me to debug issues and have better understanding of what is happening in the cluster. 
<!--more-->
List all namespaces
```bash
kubectl get namespace
```

List all pods in namespace `site`
```bash
kubectl get pods -n site
```

Set default namespace
```bash
kubectl config set-context --current --namespace=<namespace-name>
```

Watch for deploy of pods with label `app: discounts-endpoint-app`
```bash
kubectl get pods --selector=app=discounts-endpoint-app --watch
```

Explain what parameters in deployment mean
```bash
kubectl explain deploy  
kubectl explain deploy.spec
kubectl explain deploy.spec.strategy
```

Show pods sorted by how many times they were restarted
```bash
kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'
```

Watch for container logs
```bash
kubectl logs <pod-name> -f  
```

Show pod logs before restart
```bash
kubectl logs <pod-name> --previous
```

Show pods container image version
```bash
kubectl get pods -o custom-columns='NAME:metadata.name,IMAGES:spec.containers[*].image'
```

Find pod by IP address
```bash
kubectl get pods -o wide|grep 10.164.174.138
```

List configmaps
```bash
kubectl get configmap
```

Show configmap content in YAML
```bash
kubectl get configmap <configmap-name> -o yaml
```

Useful links:
* [https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/)  
* [https://github.com/dennyzhang/cheatsheet-kubernetes-A4](https://github.com/dennyzhang/cheatsheet-kubernetes-A4)
* [https://habr.com/ru/company/mailru/blog/502828/](https://habr.com/ru/company/mailru/blog/502828/)
