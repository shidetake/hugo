local_url = "localhost"


help:
	@echo 'make new NAME=filename: new post'
	@echo 'make deploy: deploy'
	@echo 'make dryrun: local deploy'

new:
ifeq (${NAME},)
	echo 'undefined NAME'
	exit 1
endif
	mkdir -p content/post/${NAME}/img
	hugo new content/post/${NAME}/index.md --editor='nvim'

deploy:
	hugo
	cd public; git add -A
	cd public; git commit -m 'rebuilding site $(shell date)'
	cd public; git push origin master

dryrun:
	hugo server --baseURL=$(local_url) --bind=$(local_url) -p1314
