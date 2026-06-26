export GITLAB_HOME ?= /home/${USER}
export GITLAB_BACKUP_DIR ?= /mnt/u30pro/gitlab/backups

export GITLAB_INIT_TASK_DIR ?= ${PWD}/init-tasks

export GITLAB_CRON_DIR ?= ${PWD}/cron
export GITLAB_CROND_DIR ?= ${GITLAB_CRON_DIR}/crond
export GITLAB_CRON_TASKS_DIR ?= ${GITLAB_CRON_DIR}/cron-tasks
export GITLAB_BACKUP_CRON ?= gitlab_backup

.PHONY: env-check env-print gitlab-up gitlab-down gitlab-backup gitlab-recover help

env-check:
	@if [ ! -d "${GITLAB_HOME}" ]; then \
		echo "${GITLAB_HOME} is not a directory"; \
		exit 1; \
	fi

	@if [ ! -d "${GITLAB_BACKUP_DIR}" ]; then \
		echo "${GITLAB_BACKUP_DIR} is not a directory"; \
		exit 1; \
	fi

	@if [ ! -d "${GITLAB_INIT_TASK_DIR}" ]; then \
		echo "${GITLAB_INIT_TASK_DIR} is not a directory"; \
		exit 1; \
	else \
		for task in ${GITLAB_INIT_TASK_DIR}/*; do \
			echo "$${task} change to executable"; \
			sudo chmod +x $${task}; \
		done; \
	fi

	@if [ ! -d "${GITLAB_CROND_DIR}" ]; then \
		echo "${GITLAB_CROND_DIR} is not a directory"; \
		exit 1; \
	fi

	@if [ ! -d "${GITLAB_CRON_TASKS_DIR}" ]; then \
		echo "${GITLAB_CRON_TASKS_DIR} is not a directory"; \
		exit 1; \
	else \
		for task in ${GITLAB_CRON_TASKS_DIR}/*; do \
			echo "$${task} change to executable"; \
			sudo chmod +x $${task}; \
		done; \
	fi

	@echo "------------------------------------------------------------"


env-print:
	@echo "GITLAB_HOME is set to $(GITLAB_HOME)"

	@echo "GITLAB_INIT_TASK_DIR is set to $(GITLAB_INIT_TASK_DIR)"

	@echo "GITLAB_CROND is set to $(GITLAB_CROND_DIR)"
	@echo "GITLAB_BACKUP_DIR is set to $(GITLAB_CRON_TASKS_DIR)"

	@echo "------------------------------------------------------------"


gitlab-up:env-print env-check 
	docker compose up -d


gitlab-down:
	docker compose down

help:
	@echo ""