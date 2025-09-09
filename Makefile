.PHONY: deploy

deploy:
	rsync -avz --progress ./ atom:/data/data/restic/
