FROM silkeh/clang:13

RUN apt-get update && apt-get install -y curl build-essential zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN apt-get install llvm-13-dev libclang-common-13-dev

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install nightly-2021-12-05
RUN rustup default nightly-2021-12-05
RUN rustup component add rustc-dev llvm-tools-preview

WORKDIR /host
CMD ["/bin/bash"]
