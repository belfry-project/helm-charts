{{/*
This template gets filled with the operator SDK's controller definition
during chart build
*/}}
{{- define "awx-operator.controller" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    control-plane: controller-manager
    helm.sh/chart: awx-operator
  name: awx-operator-controller-manager
spec:
  replicas: 1
  selector:
    matchLabels:
      control-plane: controller-manager
      helm.sh/chart: awx-operator
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/default-container: awx-manager
      labels:
        control-plane: controller-manager
        helm.sh/chart: awx-operator
    spec:
      containers:
        - args:
            - --metrics-require-rbac
            - --metrics-secure
            - --metrics-bind-address=:8443
            - --leader-elect
            - --leader-election-id=awx-operator
            - --health-probe-bind-address=:6789
          env:
            - name: ANSIBLE_GATHERING
              value: explicit
            - name: ANSIBLE_DEBUG_LOGS
              value: "false"
            - name: WATCH_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          image: ghcr.io/belfry-project/belfry-operator:main
          imagePullPolicy: IfNotPresent
          livenessProbe:
            httpGet:
              path: /healthz
              port: 6789
            initialDelaySeconds: 15
            periodSeconds: 20
          name: awx-manager
          readinessProbe:
            httpGet:
              path: /readyz
              port: 6789
            initialDelaySeconds: 5
            periodSeconds: 10
          resources:
            limits:
              cpu: 2000m
              memory: 4000Mi
            requests:
              cpu: 50m
              memory: 32Mi
          securityContext:
            allowPrivilegeEscalation: false
            capabilities:
              drop:
                - ALL
      imagePullSecrets:
        - name: redhat-operators-pull-secret
      securityContext:
        runAsNonRoot: true
      serviceAccountName: awx-operator-controller-manager
      terminationGracePeriodSeconds: 10

---
{{- end -}}
