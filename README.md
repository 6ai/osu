# osu

**O**ne-click **S**etup-script for **U**buntu

> If you're going through hell, keep going.

## For Ubuntu 18.04 LTS

while inside docker container, install git first:

```bash
apt update && apt install -y git
```

install:

```bash
git clone https://github.com/6ai/osu.git ~/.osu && cd ~/.osu && ./init-1804.sh
```

TODO:

- alias for hash methods
- clean up after install
- use wget/curl instead of manual git
- auto-detect system version
- shared scripts for 20.04 and 16.04
- support non-root
- install docker
