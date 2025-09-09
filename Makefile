.PHONY: deploy

deploy:
	rsync -avz --progress --exclude='.git' --delete ./ atom:/data/data/restic/
