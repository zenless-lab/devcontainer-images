.PHONY: prepare
prepare:
	@pipx install uv
	@uv venv
	@uv sync
	@uv run pre-commit install
