.POSIX:

default: argocd

.PHONY: argocd
argocd:
	helm dependency update ../helm/argocd/
	helm template --include-crds --namespace argocd argocd ../helm/argocd/ | kubectl apply -n argocd -f -
	kubectl -n argocd wait --timeout=60s --for condition=Established \
		crd/applications.argoproj.io \
		crd/applicationsets.argoproj.io
	helm dependency update ../helm/sealed-secrets/
	helm upgrade --install --namespace kube-system sealed-secrets ../helm/sealed-secrets --wait
	helm template --include-crds --namespace argocd argocd ../helm/argo-stack/ | kubectl apply -n argocd -f -
	kubectl -n argocd wait --timeout=300s --for condition=ResourcesUpToDate \
		applicationset/system \
		applicationset/platform \
		applicationset/apps
