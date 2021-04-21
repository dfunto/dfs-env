DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
build:
	docker build -t dfunto/hadoop-base:$(current_branch) ./hadoop-base
	docker build -t dfunto/hadoop-app:$(current_branch) ./hadoop-app