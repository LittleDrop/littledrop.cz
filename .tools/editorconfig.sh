#!/usr/bin/env bash

set -Eeuo pipefail

function run()
{
	local OS_NAME
	local OS_ARCH
	local BIN_FILE

	command -v uname >/dev/null 2>&1 || {
		echo 'Unable to detect OS, command "uname" not found' >&2
		exit 1
	}

	OS_NAME=$(detect_os_name)
	OS_ARCH=$(detect_os_architecture)
	BIN_FILE=".tools/var/editorconfig-checker-$OS_NAME-$OS_ARCH"

	# Not found or is it older than 7 days?
	if [[ ! -f "$BIN_FILE" ]] || (( $(date +%s) - $(date -r "$BIN_FILE" +%s) > 60*60*24*7 )); then
		echo 'Downloading editorconfig checker binary' >&2

		download "$OS_NAME" "$OS_ARCH" "$BIN_FILE"
	fi

	local FORMAT='default'

	if [[ -n "${GITHUB_ACTIONS:-}" ]]; then
		FORMAT='github-actions'
	fi

	"$BIN_FILE" --config '.editorconfig-checker.json' --format "$FORMAT"

	exit 0
}

function download()
{
	local OS_NAME="$1"
	local OS_ARCH="$2"
	local BIN_FILE="$3"
	local REPO="editorconfig-checker/editorconfig-checker"
	local GH_URL="https://api.github.com/repos/${REPO}/releases/latest"
	local GH_VERSION

	if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
		GH_VERSION=$(gh api "repos/${REPO}/releases/latest" -q .tag_name)
	else
		command -v jq >/dev/null 2>&1 || {
			echo 'Command "jq" is required when gh is not available' >&2
			exit 1
		}

		if [[ -n "${GITHUB_ACTIONS:-}" && -n "${GH_ACTOR:-}" && -n "${GH_TOKEN:-}" ]]; then
			GH_VERSION=$(curl -fsSL "$GH_URL" -u "${GH_ACTOR}:${GH_TOKEN}" | jq -r '.tag_name')
		else
			GH_VERSION=$(curl -fsSL "$GH_URL" | jq -r '.tag_name')
		fi
	fi

	if [[ $GH_VERSION == 'null' ]]; then
		echo 'Unable to get latest version, maybe it is because of api rate limiter' >&2
		exit 1
	fi

	local FILE_NAME
	local TEMP_PATH
	local DL_FILE

	FILE_NAME="ec-${OS_NAME}-${OS_ARCH}"
	TEMP_PATH="$(mktemp -d)"
	DL_FILE="$TEMP_PATH/${FILE_NAME}.tar.gz"

	if ! curl -fsSL -o "$DL_FILE" "https://github.com/${REPO}/releases/download/${GH_VERSION}/${FILE_NAME}.tar.gz"; then
		echo 'Unable to download file' >&2
		exit 1
	fi

	tar -xzf "$DL_FILE" -C "$TEMP_PATH"
	rm -f "$BIN_FILE" 2>/dev/null
	cp "$TEMP_PATH/bin/${FILE_NAME}" "$BIN_FILE"

	rm -rf "$TEMP_PATH" 2>/dev/null
}

function detect_os_name()
{
	uname -s | tr '[:upper:]' '[:lower:]'
}

function detect_os_architecture()
{
	local ARCH

	ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

	case "$ARCH" in
		arm|armv7*)
			echo 'arm'
		;;
		aarch64*|armv8*|arm64)
			echo 'arm64'
		;;
		x86_64)
			echo 'amd64'
		;;
		*)
			printf 'Unkown architecture "%s"' "$ARCH" >&2
			echo '' >&2
			exit 1
		;;
	esac
}

run
