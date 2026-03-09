.PHONY: help prereqs check-python check-poetry check-docker install pre-commit-install up down dbt-run dbt-test dbt-seed dbt-docs dbt-clean dbt-debug lint lint-fix clean

# Default target
help:
	@echo "Analytics Engineering with SQL and dbt - Makefile Commands"
	@echo ""
	@echo "Setup:"
	@echo "  make prereqs              Check prerequisites (Python, Poetry, Docker)"
	@echo "  make install              Install project dependencies with Poetry"
	@echo "  make pre-commit-install   Install pre-commit git hooks"
	@echo ""
	@echo "Infrastructure:"
	@echo "  make up                   Start PostgreSQL (Docker)"
	@echo "  make down                 Stop PostgreSQL (Docker)"
	@echo ""
	@echo "dbt:"
	@echo "  make dbt-debug            Test dbt connection"
	@echo "  make dbt-seed             Load seed data"
	@echo "  make dbt-run              Run all dbt models"
	@echo "  make dbt-test             Run dbt tests"
	@echo "  make dbt-docs             Generate and serve dbt docs"
	@echo "  make dbt-clean            Remove dbt artifacts"
	@echo "  make dbt-build            Seed + run + test (full pipeline)"
	@echo ""
	@echo "Code Quality:"
	@echo "  make lint                 Run sqlfluff linter"
	@echo "  make lint-fix             Run sqlfluff with auto-fix"
	@echo "  make check                Run all checks (lint + dbt test)"
	@echo ""
	@echo "Utilities:"
	@echo "  make clean                Remove generated files and caches"

# ============================================================================
# Prerequisites
# ============================================================================

prereqs: check-python check-poetry check-docker
	@echo ""
	@echo "All prerequisites satisfied"

check-python:
	@command -v python3 >/dev/null 2>&1 || { echo "Python 3 is required but not installed."; exit 1; }
	@python3 --version | grep -E "3\.1[2-9]|3\.[2-9][0-9]" >/dev/null || { echo "Python 3.12+ is required"; exit 1; }
	@echo "Python 3.12+ installed: $$(python3 --version)"

check-poetry:
	@command -v poetry >/dev/null 2>&1 || { \
		echo "Installing Poetry..."; \
		curl -sSL https://install.python-poetry.org | python3 -; \
		export PATH="$$HOME/.local/bin:$$PATH"; \
	}
	@echo "Poetry installed: $$(poetry --version)"

check-docker:
	@command -v docker >/dev/null 2>&1 || { echo "Docker is required but not installed."; exit 1; }
	@echo "Docker installed: $$(docker --version | head -1)"

# ============================================================================
# Installation
# ============================================================================

install: prereqs
	@echo "Installing dependencies with Poetry..."
	poetry install
	@echo "Dependencies installed"

pre-commit-install:
	@echo "Installing pre-commit hooks..."
	poetry run pre-commit install
	@echo "Pre-commit hooks installed"

# ============================================================================
# Infrastructure
# ============================================================================

up:
	docker compose up -d
	@echo "PostgreSQL is running on localhost:5432"

down:
	docker compose down
	@echo "PostgreSQL stopped"

# ============================================================================
# dbt
# ============================================================================

dbt-debug:
	poetry run dbt debug

dbt-seed:
	poetry run dbt seed

dbt-run:
	poetry run dbt run

dbt-test:
	poetry run dbt test

dbt-docs:
	poetry run dbt docs generate
	poetry run dbt docs serve

dbt-clean:
	poetry run dbt clean

dbt-build: dbt-seed dbt-run dbt-test
	@echo ""
	@echo "Full dbt pipeline complete (seed + run + test)"

# ============================================================================
# Code Quality
# ============================================================================

lint:
	@echo "Running sqlfluff linter..."
	poetry run sqlfluff lint models/

lint-fix:
	@echo "Running sqlfluff with auto-fixes..."
	poetry run sqlfluff fix models/

check: lint dbt-test
	@echo ""
	@echo "All checks passed"

# ============================================================================
# Utilities
# ============================================================================

clean:
	@echo "Cleaning generated files..."
	rm -rf target/ dbt_packages/ logs/
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name ".DS_Store" -delete 2>/dev/null || true
	@echo "Cleanup complete"
