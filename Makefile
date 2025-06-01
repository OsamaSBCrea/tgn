.PHONY: venv install clean lint

VENV_DIR = .venv
PYTHON = $(VENV_DIR)/bin/python
PIP = $(VENV_DIR)/bin/pip

dataset = wikipedia

# Create virtual environment
venv:
	python3.10 -m venv $(VENV_DIR)

# Install dependencies inside virtualenv
install: venv
	$(PIP) install --upgrade pip
	$(PIP) install -e ".[dev]"

# Clean up
clean:
	rm -rf $(VENV_DIR) __pycache__ .pytest_cache .mypy_cache coverage .ruff_cache junit
	find . -type d -name '__pycache__' -exec rm -r {} +

clean.model:
	rm -rf saved_models saved_checkpoints results

lint: install
	$(PYTHON) -m ruff format
	$(PYTHON) -m ruff check
	$(PYTHON) -m pyright

train.self-supervised:
	$(PYTHON) src/tgn/train_self_supervised.py --use_memory --prefix tgn-attn --n_runs 10

train.supervised:
	$(PYTHON) src/tgn/train_supervised.py -d $(dataset) --use_memory --prefix tgn-attn --n_runs 10
