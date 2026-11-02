---
name: docker-cleanup
description: Free local Docker disk space with prune commands after user confirmation. Use when the Docker disk is full, or to remove images, containers, build cache, or volumes.
---

# Docker Disk Cleanup

## Find reclaimable space

- Start Docker disk cleanup with `docker system df -v` to identify reclaimable space.

## Select the prune command

- Prefer a targeted prune when one resource type causes the problem.
- Use `docker image prune --all` to remove images that no container uses.
- Use `docker buildx prune` to remove unused build cache for the selected builder.
- Use `docker container prune` to remove stopped containers.
- Use `docker system prune --all` for routine cleanup across these resource types.
- Add `--filter "until=168h"` when resources from the last seven days must remain.

## Get confirmation

- Before each prune, show me the exact command and the reclaimable space from `docker system df -v`.
  - After I confirm in chat, run the command with `--force`.
  - If I request unattended cleanup, do not wait for my confirmation.

## Protect volumes

- Treat volumes as persistent user data. Do not include volumes in broad cleanup without my explicit request.
- `docker system prune --volumes` removes unused anonymous volumes. It does not remove unused named volumes.
- Inspect volume names, labels, and project ownership before volume removal.
- Prefer `docker volume rm <volume>` when I identify exact named volumes for removal.
- Use `docker volume prune --all` only when I explicitly request removal of all unused named volumes.
- Prefer `docker compose down --volumes` when I explicitly request removal of one Compose project's data.

## Protect Docker Desktop data

- Do not edit or delete Docker Desktop's `Docker.raw` disk image directly.
- Use Docker Desktop's destructive reset options only when I explicitly request deletion of all local Docker data.
