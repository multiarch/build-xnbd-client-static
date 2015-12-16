build:
	docker build -t build-xnbd-client-static .
	docker run --rm build-xnbd-client-static | tar xvf -
