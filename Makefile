export GITLAB_HOME ?= /home/${USER}
export GITLAB_BACKUP_DIR ?= /mnt/usb64/gitlab/backups
export GITLAB_RESTORE_DIR ?= /mnt/usb64/gitlab/restores
export GITLAB_RESTORE_INIT ?= 0

export GITLAB_INIT_TASK_DIR ?= ${PWD}/init-tasks

export GITLAB_CRON_DIR ?= ${PWD}/cron
export GITLAB_CROND_DIR ?= ${GITLAB_CRON_DIR}/crond
export GITLAB_CRON_TASKS_DIR ?= ${GITLAB_CRON_DIR}/cron-tasks

export GITLAB_ENV_DIR ?= ${PWD}/env

export GITLAB_DOMAIN ?= oalh.dpdns.org

.PHONY: env-check env-print gitlab-up gitlab-down gitlab-down-volume gitlab-backup gitlab-recover help

env-check:
	@if [ ! -d "${GITLAB_HOME}" ]; then \
		echo "${GITLAB_HOME} is not a directory"; \
		exit 1; \
	fi

	@if [ ! -d "${GITLAB_BACKUP_DIR}" ]; then \
		echo "${GITLAB_BACKUP_DIR} is not a directory"; \
		exit 1; \
	fi

	@if [ ! -d "${GITLAB_RESTORE_DIR}" ]; then \
		echo "${GITLAB_RESTORE_DIR} is not a directory"; \
		exit 1; \
	fi

	@if [ ! -z ${GITLAB_RESTORE_FILE} -a ! -f "${GITLAB_BACKUP_DIR}/${GITLAB_RESTORE_FILE}" ]; then \
		echo "${GITLAB_BACKUP_DIR}/${GITLAB_RESTORE_FILE} is not a file"; \
		exit 1; \
	fi

	@if [ ! -d "${GITLAB_INIT_TASK_DIR}" ]; then \
		echo "${GITLAB_INIT_TASK_DIR} is not a directory"; \
		exit 1; \
	else \
		for task in ${GITLAB_INIT_TASK_DIR}/*; do \
			echo "$${task} change to executable"; \
			sudo chmod 777 $${task}; \
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
			sudo chmod 777 $${task}; \
		done; \
	fi

	@if [ ! -d "${GITLAB_ENV_DIR}" ]; then \
		echo "${GITLAB_ENV_DIR} is not a directory"; \
		exit 1; \
	else \
		for env in ${GITLAB_ENV_DIR}/*; do \
			echo "$${env} change to executable"; \
			sudo chmod 777 $${env}; \
		done; \
	fi

	@echo "------------------------------------------------------------"


env-print:
	@echo "GITLAB_HOME is set to $(GITLAB_HOME)"

	@echo "GITLAB_BACKUP_DIR is set to $(GITLAB_BACKUP_DIR)"
	@echo "GITLAB_RESTORE_DIR is set to $(GITLAB_RESTORE_DIR)"
	@echo "GITLAB_RESTORE_INIT is set to $(GITLAB_RESTORE_INIT)"
	@echo "GITLAB_RESTORE_FILE is set to $(GITLAB_RESTORE_FILE)"

	@echo "GITLAB_INIT_TASK_DIR is set to $(GITLAB_INIT_TASK_DIR)"

	@echo "GITLAB_CROND is set to $(GITLAB_CROND_DIR)"
	@echo "GITLAB_BACKUP_DIR is set to $(GITLAB_CRON_TASKS_DIR)"

	@echo "GITLAB_ENV_DIR is set to ${GITLAB_ENV_DIR}"

	@echo "GITLAB_DOMAIN is set to ${GITLAB_DOMAIN}"

	@echo "------------------------------------------------------------"


gitlab-up:env-print env-check 
	docker compose up -d


gitlab-down:
	docker compose down

gitlab-down-volume:env-print env-check
	docker compose down --volumes

gitlab-restart:gitlab-down gitlab-up
	@echo "gitlab restart done"

help:
	@echo "GITLAB_RESTORE_INIT=1 GITLAB_RESTORE_FILE=backup.tar restore gitlab data"