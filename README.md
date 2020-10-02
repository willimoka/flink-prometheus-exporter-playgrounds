# Monitoring Flink

## Requirements
* docker images
    * flink:1.11.0-scala_2.11
    * confluentinc/cp-zookeeper:5.4.1
    * confluentinc/cp-kafka:5.4.1
    * ubuntu:latest
    * prom/prometheus:latest
    * prom/alertmanager:latest
    * grafana/grafana:latest
* [flink_exporter](https://github.com/matsumana/flink_exporter)

## Build example job
```
make build-example-job-with-docker
```
Output: `./resources/ClickCountJob.jar`

## Build flink exporter
```
make build-flink-exporter
```
Output: `./flink_exporter_bin`

## How to Use
* build example job
* build `flink_exporter` binary file
* run docker compose, it will automatically download all images that are not available on your docker machine.
    ```
    docker-compose up
    ```

## Available UI
* Flink job manager: `http://localhost:8081`
* Flink prometheus exporter: `http://localhost:9160/metrics`
* Prometheus: `http://localhost:9090`
* Grafana: `http://localhost:3000`
* Alertmanager: `http://localhost:9093`

## Alerting
Update slack webhook URL to your personal slack webhook URL.
Configuration for `slack_api_url` can be found on `./prometheus/alertmanager.yml`

# Deploy and Manage Flink Job through Airflow

Flink job manager provide [Monitoring REST API](https://ci.apache.org/projects/flink/flink-docs-stable/monitoring/rest_api.html). It can be used for manage jobs on flink.

## Example submit job or manage jobs through Flink REST API

Before submitting job, ensure JAR files exists on Flink cluster.
Here are some parameters that must be override to enable upload JAR files features via REST API. For this repository already set these parameters.
```
web.submit.enable: true
web.upload.dir: /opt/flink/product-libs/
```

How to submit job:
* Upload JAR file
    ```
    curl -i -X POST -H "Content-Type: multipart/form-data" -H "Expect:" -F jarfile=@./resources/ClickCountJob.jar http://localhost:8081/jars/upload
    ```
* Show list available JAR files
    ```
    curl http://localhost:8081/jars
    ```
* Submit job
    ```
    curl -X POST  http://localhost:8081/jars/<id-jar-with-name>.jar/run
    ```
* Show running jobs
    ```
    curl http://localhost:8081/jobs
    ```
* Delete job
    ```
    curl http://localhost:8081/jobs/<job-id>/yarn-cancel
    ```
## Airflow Operator

Airflow FlinkOperator can be developed by utilizing Flink REST API.     
Before going too far, it's better to decide the Flink architecture deployment either with yarn or flink cluster. It must take a look more for flink-yarn implementation because the REST API usage is different.

