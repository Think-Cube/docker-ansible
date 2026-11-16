# docker-ansible

Container image with Ansible, `ansible-lint` and common connection plugins for running playbooks in a controlled, reproducible environment.

Images are built for `linux/amd64` and `linux/arm64`, run as a non-root user and ship with an SBOM, build provenance and a keyless signature.

## Images

Images are published to GitHub Container Registry as `ghcr.io/think-cube/ansible`.

| Tag | Meaning | Changes? |
|---|---|---|
| `2.0.0` | Exact release | Never |
| `2.0`, `2`, `latest` | Newest matching release | With each release |
| `edge` | Newest build of `main` | With each merge and weekly rebuild |
| `edge-YYYYMMDD` | Weekly rebuild of `main` with current OS patches | Never |
| `sha-<commit>` | Build of one `main` commit | Never |

For production, pin by digest: `ghcr.io/think-cube/ansible:2.0.0@sha256:...`.

## Usage

```bash
docker run --rm -it \
  -v "$PWD:/ansible" \
  ghcr.io/think-cube/ansible:2 \
  ansible-playbook site.yml
```

The image runs as `ansible` (UID/GID `10001`) in `/ansible`. Mounted files must be readable by that user, and writable if your playbooks create files next to them. To use your own SSH key, mount it read-only and readable by UID `10001`, or use an SSH agent.

## Included software

Versions of the Python packages are pinned with hashes in `requirements.txt`, generated from `requirements.in`.

- `ansible` and `ansible-core`
- `ansible-lint`
- `jmespath`, `mitogen` and `pywinrm`
- `git`, `gnupg`, `openssh-client` and `sshpass`

## Verify an image

Check the signature:

```bash
cosign verify ghcr.io/think-cube/ansible:2.0.0 \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  --certificate-identity-regexp '^https://github\.com/Think-Cube/workflows/\.github/workflows/container-image\.yml@refs/tags/v.+$'
```

Read the SBOM and provenance:

```bash
docker buildx imagetools inspect ghcr.io/think-cube/ansible:2.0.0 --format '{{ json .SBOM }}'
docker buildx imagetools inspect ghcr.io/think-cube/ansible:2.0.0 --format '{{ json .Provenance }}'
```

## Build and test locally

```bash
docker build -t ansible:local .
bash tests/smoke.sh ansible:local
```

To change a Python dependency, edit `requirements.in` and regenerate the lock file:

```bash
pip-compile --generate-hashes --output-file=requirements.txt requirements.in
```

## Support

Only the newest release receives fixes. `main` is rebuilt every week, and images with fixable critical vulnerabilities are not published. Report security issues through [GitHub private vulnerability reporting](https://github.com/Think-Cube/docker-ansible/security/advisories/new).

## License

This project is licensed under the [MIT License](LICENSE).

## Contribution

Feel free to contribute by opening issues or pull requests. Your feedback and improvements are highly appreciated!
