build-example-job-with-docker:
	docker run --rm -v "$(PWD)/resources":/opt/resources -v "$(PWD)/docker/java/flink-playground-clickcountjob":/opt/flink-playground-clickcountjob -w /opt/flink-playground-clickcountjob maven:3.6-jdk-8-slim bash -c 'mvn clean install && cp -r /opt/flink-playground-clickcountjob/target/flink-playground-clickcountjob-*.jar /opt/resources/ClickCountJob.jar && rm -rf /opt/flink-playground-clickcountjob/target'

build-flink-exporter:
	git clone https://github.com/matsumana/flink_exporter.git
	docker run --rm -v "$(PWD)/flink_exporter":/go/src/github.com/matsumana/flink_exporter -w /go/src/github.com/matsumana/flink_exporter golang:1.10.3 bash -c 'make install-depends && glide install && make build-all'
	mkdir ./flink_exporter_bin
	mv ./flink_exporter/releases/* ./flink_exporter_bin/
	rm -rf ./flink_exporter