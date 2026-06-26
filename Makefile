export GITLAB_HOME ?= /home/${USER}

.PHONY: env-print gitlab-up gitlab-down

env-print:
	@echo "GITLAB_HOME is set to $(GITLAB_HOME)"

gitlab-up:env-print
	docker compose up -d

gitlab-down:
	docker compose down
