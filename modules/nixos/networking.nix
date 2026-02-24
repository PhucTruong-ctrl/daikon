{ pkgs, ... }: {
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;

  systemd.services.tailscale-autoheal = {
    description = "Restart tailscaled when node is offline or control map is stale";
    after = [ "network-online.target" "tailscaled.service" ];
    wants = [ "network-online.target" ];
    serviceConfig.Type = "oneshot";
    path = [ pkgs.tailscale pkgs.python3 pkgs.systemd ];
    script = ''
      set -euo pipefail

      status_json="$(tailscale status --json 2>/dev/null || true)"
      if [ -z "$status_json" ]; then
        logger -t tailscale-autoheal "tailscale status failed; restarting tailscaled"
        systemctl restart tailscaled
        exit 0
      fi

      if printf '%s' "$status_json" | python3 -c 'import json, sys; data = json.load(sys.stdin); self_data = data.get("Self", {}); health = " ".join(data.get("Health", [])); backend = data.get("BackendState", ""); offline = not bool(self_data.get("Online")); stale = "network map" in health.lower(); bad_backend = backend not in ("Running", "Starting"); raise SystemExit(0 if (offline or stale or bad_backend) else 1)'; then
        logger -t tailscale-autoheal "tailscale unhealthy (offline/netmap/backend); restarting tailscaled"
        systemctl restart tailscaled
      fi
    '';
  };

  systemd.timers.tailscale-autoheal = {
    description = "Periodic tailscale health check";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "2min";
      RandomizedDelaySec = "20s";
      Unit = "tailscale-autoheal.service";
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  networking.firewall.allowedUDPPorts = [ 4445 ];
  # networking.firewall.allowedTCPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
