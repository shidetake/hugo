local_url = "shidetake.me"

dryrun:
	hugo server --baseURL=$(local_url) --bind=$(local_url)
