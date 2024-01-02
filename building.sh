#!/bin/bash

# Building the images
docker build -f gitpod-neovim-tmux.dockerfile -t maxdac/gitpod-neovim:0.9.5-tmux-3.3a .
docker tag maxdac/gitpod-neovim:0.9.5-tmux-3.3a maxdac/gitpod-neovim:latest 
docker build -f gitpod-elixir.dockerfile -t maxdac/gitpod-elixir:1.16.0-otp-26 .
docker tag maxdac/gitpod-elixir:1.16.0-otp-26 maxdac/gitpod-elixir:latest 

# Logging in to docker hub
docker login

# Pushing images to docker
docker push maxdac/gitpod-neovim:0.9.4-tmux-3.3a
docker push maxdac/gitpod-neovim:latest
docker push maxdac/gitpod-elixir:1.15.7-otp-26c 
docker push maxdac/gitpod-elixir:latest 
