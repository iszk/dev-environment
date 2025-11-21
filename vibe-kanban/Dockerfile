FROM docker.io/library/node:current-trixie

ARG USERNAME=vk
ARG GROUPNAME=vk
ARG UID=9999
ARG GID=9999
ARG DOCKER_GID=999
# UID/GID は利便性のため、ホスト側のユーザーと合わせる
# 1000 は node ユーザーが埋めてるので別のものにする

ENV TZ=Asia/Tokyo
ENV LANG=C.UTF-8


# ★ここがポイント：Docker公式イメージからCLIだけコピー
COPY --from=docker:cli /usr/local/bin/docker /usr/local/bin/
COPY --from=docker/buildx-bin:latest /buildx /usr/libexec/docker/cli-plugins/docker-buildx
COPY --from=docker/compose-bin:latest /docker-compose /usr/libexec/docker/cli-plugins/docker-compose


# common
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl unzip && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g $GID $GROUPNAME && \
    groupadd -g $DOCKER_GID docker && \
    useradd -m -s /bin/bash -u $UID -g $GID -G docker $USERNAME
USER $USERNAME

WORKDIR /workspace

ENV HOST=0.0.0.0
ENV BACKEND_PORT=8080

RUN mkdir -p ~/.local/bin
RUN mkdir -p ~/.local/share/vibe-kanban
RUN mkdir -p ~/.vibe-kanban

EXPOSE 8080

CMD ["npx", "--yes", "vibe-kanban"]
