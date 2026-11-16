#!/usr/bin/env bash
set -euo pipefail

image=${1:?usage: smoke.sh <image>}
tests=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

run() {
  docker run --rm -v "$tests:/ansible/tests:ro" "$image" "$@"
}

test "$(run id -u)" != "0"
run ansible --version
run ansible-lint --version
run git --version
run gpg --version
run ssh -V
run sshpass -V
run python -c 'import ansible_mitogen, jmespath, winrm'
run ansible-lint --offline tests/smoke.yml
run ansible-playbook tests/smoke.yml
run sh -c 'ANSIBLE_STRATEGY_PLUGINS="$(python -c "import ansible_mitogen, os; print(os.path.dirname(ansible_mitogen.__file__))")/plugins/strategy" ANSIBLE_STRATEGY=mitogen_linear ansible-playbook tests/smoke.yml'
