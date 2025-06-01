.PHONY: venv install clean lint

VENV_DIR = .venv
PYTHON = $(VENV_DIR)/bin/python
PIP = $(VENV_DIR)/bin/pip

# Create virtual environment
venv:
	python3 -m venv $(VENV_DIR)

# Install dependencies inside virtualenv
install: venv
	$(PIP) install --upgrade pip
	$(PIP) install -e ".[dev]"

# Clean up
clean:
	rm -rf $(VENV_DIR) __pycache__ .pytest_cache .mypy_cache coverage .ruff_cache junit
	find . -type d -name '__pycache__' -exec rm -r {} +


lint: install
	$(PYTHON) -m ruff format
	$(PYTHON) -m ruff check
	$(PYTHON) -m pyright
