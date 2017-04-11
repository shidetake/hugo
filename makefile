local_url = "shidetake.me"

help:
	@echo 'make deploy: deploy'
	@echo 'make dryrun: local deploy'

deploy:
	cd public; git add -A
	cd public; git commit -m 'rebuilding site $(shell date)'
	cd public; git push origin master

dryrun:
	hugo server --baseURL=$(local_url) --bind=$(local_url)
