---
title: Helm notes
---

## Code examples

```bash
helm --namespace staging \
    upgrade --install \
    --values staging/values.yaml \
    go-demo-9 go-demo-9 \
    --wait \
    --timeout 10m
```
