all:
	docker build -t bg6cq/ahstatus .
push:
	docker push bg6cq/ahstatus
