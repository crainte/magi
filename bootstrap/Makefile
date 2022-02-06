.POSIX:

default: namespace registry gpg argocd

namespace:
	kubectl create namespace argocd --dry-run=client --output=yaml | kubectl apply -f -

.PHONY: registry
registry:
	kubectl delete secret -n argocd dockerhub-registry || true
	@read -rp "Docker Username: " USERNAME; \
		read -rsp "Docker Password: " PASSWORD; \
		kubectl create secret -n argocd docker-registry dockerhub-registry --docker-server=https://index.docker.io/v1/ --docker-username=$$USERNAME --docker-password=$$PASSWORD

.PHONY: gpg
gpg:
	kubectl delete secret -n argocd helm-secrets-private-key || true
	gpg --armor --export-secret-keys $$USER > key.asc
	kubectl create secret -n argocd generic helm-secrets-private-key --from-file=key.asc
	rm key.asc

.PHONY: argocd
argocd:
	helm dependency update ../helm/argocd/
	helm template --include-crds --namespace argocd argocd ../helm/argocd/ | kubectl apply -n argocd -f -
	kubectl -n argocd wait --timeout=60s --for condition=Established \
		crd/applications.argoproj.io \
		crd/applicationsets.argoproj.io
	helm template --include-crds --namespace argocd argocd ../helm/argo-stack/ | kubectl apply -n argocd -f -
	kubectl -n argocd wait --timeout=300s --for condition=ResourcesUpToDate \
		applicationset/system \
		applicationset/platform \
		applicationset/apps
