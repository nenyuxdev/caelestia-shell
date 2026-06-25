## Switch to unstable channels just in case
```
sudo nix-channel --remove nixos
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
```

```
sudo nix-channel --update
```

```
sudo nixos-rebuild switch --upgrade
```
