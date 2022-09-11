.POSIX:

default: bootstrap

.PHONY: bootstrap
bootstrap:
	make -C bootstrap

.PHONY: update
update:
	make -C bootstrap argocd
