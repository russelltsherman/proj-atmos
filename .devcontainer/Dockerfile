
#####################################################################
#
# Debian/Atmos Infrastructure Management Container
#
#####################################################################
ARG TARGETOS=linux
ARG TARGETARCH=arm64

ARG ATMOS_VERSION=1.146.1   
ARG HELM_VERSION=3.16.4
ARG K9S_VERSION=0.32.7
ARG KUBECTL_VERSION=1.32.0
ARG KUSTOMIZE_VERSION=5.6.0
ARG TERRAFORM_VERSION=1.8
ARG TOFU_VERSION=1.8.0

#
# Neovim Build from source
#
FROM debian:12.9 AS neovimbuild
RUN apt-get update && apt-get -y install gettext git libtool libtool-bin autoconf automake cmake g++ pkg-config
# Install NeoVim from source
RUN mkdir -p /root/TMP
RUN cd /root/TMP && git clone https://github.com/neovim/neovim
RUN cd /root/TMP/neovim && git checkout stable && make -j4 && make install
RUN rm -rf /root/TMP

#
# Download precompiled binaries
#
FROM curlimages/curl:7.83.1 AS downloader

ARG TARGETARCH
ARG ATMOS_VERSION
ARG HELM_VERSION
ARG KUBECTL_VERSION
ARG KUSTOMIZE_VERSION
ARG K9S_VERSION

WORKDIR /downloads

RUN set -ex; \
    curl -fL https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl -o kubectl && \
    chmod +x kubectl

RUN set -ex; \
    curl -fL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_${TARGETARCH}.tar.gz | tar xz && \
    chmod +x kustomize

RUN set -ex; \
    curl -fL https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_${TARGETARCH}.tar.gz | tar xz && \
    chmod +x k9s 

RUN set -ex; \
    curl -fL https://github.com/cloudposse/atmos/releases/download/v${ATMOS_VERSION}/atmos_${ATMOS_VERSION}_linux_${TARGETARCH} -o atmos && \
    chmod +x atmos 

RUN set -ex; \
    curl -fL https://get.helm.sh/helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz | tar xz && \
    mv ./linux-${TARGETARCH}/helm ./helm && rm -rf ./linux-${TARGETARCH} && chmod +x helm

#
# precompiled open tofu
#
FROM ghcr.io/opentofu/opentofu:${TOFU_VERSION}-arm64 AS opentofubuild

#
# precompiled terraform
#
FROM hashicorp/terraform:${TERRAFORM_VERSION} AS terraformbuild

#
# finally our tools container
#
FROM debian:12.9

ENV NAMESPACE="atmos"
ENV AWS_DEFAULT_REGION=us-east-1

RUN apt-get update && apt-get -y install curl jq make screen tmux tree unzip yq zsh zsh-antigen

RUN usermod --shell /usr/bin/zsh root

# Install Starship shell prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

COPY --from=downloader /downloads/atmos /usr/local/bin/atmos
COPY --from=downloader /downloads/helm /usr/local/bin/helm
COPY --from=downloader /downloads/k9s /usr/local/bin/k9s
COPY --from=downloader /downloads/kubectl /usr/local/bin/kubectl
COPY --from=downloader /downloads/kustomize /usr/local/bin/kustomize
COPY --from=neovimbuild /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=neovimbuild /usr/local/share/nvim /usr/local/share/nvim
COPY --from=opentofubuild /usr/local/bin/tofu /usr/local/bin/tofu
COPY --from=terraformbuild /bin/terraform /usr/local/bin/terraform

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install

RUN apt-get update && apt-get -y install python3-full python3-pip && pip install wakatime --break-system-packages

RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /localhost/.aws /root/.aws && \
    ln -s /localhost/.kube /root/.kube && \
    ln -s /localhost/.continue /root/.continue && \
    ln -s /localhost/.ollama /root/.ollma && \
    ln -s /localhost/.ssh /root/.ssh && \
    ln -s /localhost/.wakatime.cfg /root/.wakatime.cfg
