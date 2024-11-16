## port_forward.sh

```sh
#!/bin/bash
sudo socat TCP4-LISTEN:8800,fork TCP4:127.0.0.1:33210 &
# sudo socat TCP4-LISTEN:8801,fork TCP4:127.0.0.1:33211 &
# sudo socat TCP4-LISTEN:8822,fork TCP4:192.168.15.128:22 &
```


## 排查网络问题

```bash
sudo log stream | rg -v 'wezterm' | rg 'location|wireless|awdl|phone|rapport|sharing|handoff'
```

1. location
2. wifi scaning
3. awdl0
4. application
