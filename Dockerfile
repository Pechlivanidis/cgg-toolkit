# syntax=docker/dockerfile:1

FROM debian:bookworm-slim AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        g++ \
        make \
        bash \
        wget \
        perl \
        mawk \
        sed \
        libgomp1 \
        procps \
        mcl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Build 0_magicmatch
FROM base AS magicmatch
WORKDIR /app/0_magicmatch
COPY 0_magicmatch/ .
RUN make -f Makefile.linux || make

# Build 1_genecast
FROM base AS genecast
WORKDIR /app/1_genecast
COPY 1_genecast/ .
RUN make

# Build 2_cogent_utils (shell script, no build needed)
FROM base AS cogent_utils
WORKDIR /app/2_cogent_utils
COPY 2_cogent_utils/ .

# Build 3_clustt_utils (shell script, no build needed)
FROM base AS clustt_utils
WORKDIR /app/3_clustt_utils
COPY 3_clustt_utils/ .

# Build 4_generage
FROM base AS generage
WORKDIR /app/4_generage
COPY 4_generage/ .
RUN make

# Build genefuse specifically
WORKDIR /app/4_generage/diffuse
RUN make

# Final runtime image
# For the runtime image:
FROM debian:bookworm-slim AS runtime
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        perl \
        mawk \  
        sed \
        libgomp1 \
        procps \
        mcl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY --from=magicmatch /app/0_magicmatch/magicmatch /usr/local/bin/magicmatch
COPY --from=genecast /app/1_genecast/cast /usr/local/bin/cast
COPY --from=generage /app/4_generage/generage /usr/local/bin/generage
COPY --from=generage /app/4_generage/prss33 /usr/local/bin/prss33
COPY --from=generage /app/4_generage/diffuse/genefuse /usr/local/bin/genefuse
COPY --from=generage /app/4_generage/diffuse/ssearch35 /usr/local/bin/ssearch35
COPY --from=cogent_utils /app/2_cogent_utils/create_cogent.sh /usr/local/bin/create_cogent.sh
COPY --from=clustt_utils /app/3_clustt_utils/mcl_clustering.sh /usr/local/bin/mcl_clustering.sh

RUN chmod +x /usr/local/bin/*.sh
RUN chmod +x /usr/local/bin/prss33
RUN chmod +x /usr/local/bin/ssearch35

ENV PATH="/usr/local/bin:$PATH"

# Default command
CMD ["bash", "-c", "echo 'Available commands: magicmatch, cast, generage, prss33, genefuse, ssearch35, create_cogent.sh, mcl_clustering.sh' && bash"]