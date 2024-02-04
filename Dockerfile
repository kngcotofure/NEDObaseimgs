FROM hieupth/mamba:essential as BUILD
ARG PAT
ARG CUDA

ADD ${CUDA}env.yml environment.yml
RUN apt-get update --yes && \
    apt-get install --yes git && \
    mamba install -c conda-forge conda-pack && \
    mamba env create -f environment.yml
SHELL ["conda", "run", "-n", "nedo", "/bin/bash", "-c"]
RUN pip install git+https://${PAT}@github.com/kngcotofure/NEDO.git@dev/refactor
RUN conda-pack -n nedo -o /tmp/env.tar && \
    mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
    rm /tmp/env.tar
RUN /venv/bin/conda-unpack

FROM qdrant/qdrant as RUNTIME
RUN apt-get update --yes && \
    apt-get install --yes libgl1 ffmpeg
COPY --from=BUILD /venv /venv