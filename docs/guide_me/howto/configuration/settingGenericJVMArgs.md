# How to to set generic JVM arguments in the DX Compose Webengine container

## Applies to  

> HCL Digital Experience 9.5 and higher  

## Introduction  

There might be situations in which you want to add additional generic jvm arugments to the HCL DX Compose Webegine container. For example, when it is needed to enable detailed SSL-traces or when other kind of JVM settings need to be changed. This guide helps you to set those generic jvm arguments on the Webengine container. 

## Instructions

It is possible to add additional generic jvm arguments in the helm-chart (values.yaml file) as following: 

Search for the following section:

```yaml
environment:
  pod:
    webEngine:[]
```

It is possible then to add generic jvm arguments in that section as following: 

```yaml
environment:
  pod:
    webEngine:
    -name: JVM_ARGS
     value: "<set here the generic jvm argument>"
```

For example:

```yaml
environment:
  pod:
    webEngine:
    -name: JVM_ARGS
     value: "-Djavax.net.debug=all"
```
