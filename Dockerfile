FROM hieupth/mamba as BUILD

ADD environment.yml environment.yml
RUN mamba install -c conda-forge conda-pack && \
    mamba env create -f environment.yml
SHELL ["conda", "run", "-n", "nedo", "/bin/bash", "-c"]
RUN pip install git+https://${{secrets.HIEUKNG_ACCESS_TOKEN}}@github.com/kngcotofure/NEDO.git@{refactor}