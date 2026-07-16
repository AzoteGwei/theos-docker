# theos-docker

Container image for Theos, based on Ubuntu 22.04. Optimized for rootless Podman.

## Building

### With Podman (recommended)

Clone this repo and cd into it. Then:

```bash
podman build --build-arg CHANGE_SOURCE=true -t theos:22.04 .
```

> Set `CHANGE_SOURCE=true` to use a Chinese mirror for faster apt downloads.

### With Docker

```bash
docker build --build-arg CHANGE_SOURCE=true -t theos:22.04 .
```

### With podman-compose

```bash
podman-compose up --build --no-start
```

## Usage

### Podman (rootless, recommended)

```bash
# First run
podman run -it --rm --name theos \
  -v theos-data:/home/me/theos:Z \
  -v theos-work:/home/me/work:Z \
  theos:22.04

# Stop and restart (data in named volumes persists)
podman stop theos
podman start -i theos
```

### Docker

```bash
docker run -it --rm --name theos \
  -v theos-data:/home/me/theos \
  -v theos-work:/home/me/work \
  theos:22.04
```

### podman-compose

```bash
podman start -i theos
```

## Persistence

Data is stored in two named volumes:

| Volume | Container Path | Purpose |
|--------|---------------|---------|
| `theos-data` | `~/theos` | Theos installation + SDKs |
| `theos-work` | `~/work` | Your tweak projects |

To inspect or backup volumes:

```bash
podman volume inspect theos-data
podman volume inspect theos-work
```

## What's Included

| Component | Version |
|-----------|---------|
| Ubuntu | 22.04 (jammy) |
| Theos | Latest (master) |
| Swift | 5.8 (toolchain v2.3.0) |
| Clang | 13 |
| ldid | 2.1.5-procursus5 |

## Project Structure

```
theos-docker/
├── Dockerfile                # Image definition
├── docker-compose.yml        # podman-compose / docker-compose config
├── entry                     # Container entrypoint
├── container_init_template   # First-boot initialization script
└── docs/expect/              # Planning documents
```
