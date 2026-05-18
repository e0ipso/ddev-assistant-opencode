#!/usr/bin/env bats

# Bats is a testing framework for Bash
# Documentation https://bats-core.readthedocs.io/en/stable/
# Bats libraries documentation https://github.com/ztombol/bats-docs

# For local tests, install bats-core, bats-assert, bats-file, bats-support
# And run this in the add-on root directory:
#   bats ./tests/test.bats
# To exclude release tests:
#   bats ./tests/test.bats --filter-tags '!release'
# For debugging:
#   bats ./tests/test.bats --show-output-of-passing-tests --verbose-run --print-output-on-failure

setup() {
  set -eu -o pipefail

  # Override this variable for your add-on:
  export GITHUB_REPO=e0ipso/ddev-assistant-opencode

  TEST_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  export BATS_LIB_PATH="${BATS_LIB_PATH}:${TEST_BREW_PREFIX}/lib:/usr/lib/bats"
  bats_load_library bats-assert
  bats_load_library bats-file
  bats_load_library bats-support

  export DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)"
  export PROJNAME="test-$(basename "${GITHUB_REPO}")"
  mkdir -p "${HOME}/tmp"
  export TESTDIR="$(mktemp -d "${HOME}/tmp/${PROJNAME}.XXXXXX")"
  export DDEV_NONINTERACTIVE=true
  export DDEV_NO_INSTRUMENTATION=true
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  run ddev config --project-name="${PROJNAME}" --project-tld=ddev.site
  assert_success
  run ddev start -y
  assert_success
}

health_checks() {
  # Debug: inspect the container state
  run ddev exec "ls -la /usr/local/lib/opencode/ 2>/dev/null || echo 'DIR_MISSING'"
  echo "# DEBUG /usr/local/lib/opencode: ${output}" >&3

  run ddev exec "ls -la ~/.local/bin/ 2>/dev/null || echo 'BIN_MISSING'"
  echo "# DEBUG ~/.local/bin: ${output}" >&3

  run ddev exec "ls -la ~/.ddev/web-build/ 2>/dev/null || echo 'WEBBUILD_MISSING'"
  echo "# DEBUG web-build: ${output}" >&3

  # Verify OpenCode is installed at ~/.local/bin and owned by the web user
  run ddev exec "test -f ~/.local/bin/opencode"
  assert_success

  run ddev exec "stat -c '%U' ~/.local/bin/opencode"
  assert_success
  refute_output "root"

  # Verify ~/.local/bin is in PATH and opencode is accessible
  run ddev exec "opencode --version"
  assert_success

  # Verify mounted config directories are owned by the web user (not root)
  run ddev exec "stat -c '%U' ~/.config/opencode"
  assert_success
  refute_output "root"

  # Verify the host config file is mounted as a regular file (the pre-start hook
  # ensures the host path exists as a file; without it Docker would bind-mount a
  # directory there instead)
  run ddev exec "test -f ~/.gitconfig"
  assert_success
}

teardown() {
  set -eu -o pipefail
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1
  # Persist TESTDIR if running inside GitHub Actions. Useful for uploading test result artifacts
  # See example at https://github.com/ddev/github-action-add-on-test#preserving-artifacts
  if [ -n "${GITHUB_ENV:-}" ]; then
    [ -e "${GITHUB_ENV:-}" ] && echo "TESTDIR=${HOME}/tmp/${PROJNAME}" >> "${GITHUB_ENV}"
  else
    [ "${TESTDIR}" != "" ] && rm -rf "${TESTDIR}"
  fi
}

@test "install from directory" {
  set -eu -o pipefail
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${DIR}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  echo "# ddev add-on get ${GITHUB_REPO} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${GITHUB_REPO}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}
