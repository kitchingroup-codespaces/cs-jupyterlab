# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.236.0/containers/python-3-anaconda/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/anaconda:0-3

# This makes the jupyter lab terminal be a bash shell, with completion and color 
# It also makes sure the RUN commands below happen in bash, and not sh
# That is important for the source commands.
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Copy environment.yml (if found) to a temp location so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
COPY environment.yml* .devcontainer/noop.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp

# [Optional] Uncomment this section to install additional OS packages.
# These packages are to get PDF export via LaTeX (minimal) and via webpdf
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends pandoc \
     texlive-xetex texlive-fonts-recommended texlive-plain-generic \
     xorg xvfb gtk2-engines-pixbuf \
     dbus-x11 xfonts-base xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable \
     libnss3-dev libxss1 libcups2 libasound2 libpangocairo-1.0-0 libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 \
     nodejs npm libzmq3-dev libsundials-dev

# Julia
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends julia 

# R
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends r-base  \
     && Rscript -e "install.packages('IRkernel'); IRkernel::installspec(user = FALSE)"

# Racket
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends racket racket-doc
   
# Hack for controlling how chromium works with no-sandbox and allow-downloads
# This seems to be important mostly for using webpdf in nbconvert.
RUN mkdir -p /home/vscode/.jupyter
COPY .devcontainer/jupyter_nbconvert_config.py /home/vscode/.jupyter/jupyter_nbconvert_config.py



# Note: this results in some warnings during build about not running pip as root
# with a suggestion to use a venv. I tried a lot of variations, and was unsuccessful
# in getting everything to work where the venv was activated in the Codespace, and
# that Jupyter Lab used the venv. This works fine as far as I can tell.
RUN python -m pip install --upgrade pip \
    && python -m pip install pycse nbconvert nbconvert[webpdf] \
    plotly \
    pytest \
    black flake8 pylint jupyterlab_flake8 pycodestyle pycodestyle_magic \
    pint quantities lmfit pysr \
    jupyterlab-git \
    jax[cpu]\
    # this is really a proof of concept for building the class package
    https://github.com/jkitchin/f21-06623/archive/refs/heads/master.zip \
    && jupyter labextension install plotlywidget \
    && jupyter nbextension install https://github.com/drillan/jupyter-black/archive/master.zip --user \
    && jupyter nbextension enable jupyter-black-master/jupyter-black \
    && conda install -c conda-forge pyomo ipopt glpk 
    
# Make sure everything in vscode belongs to vscode
RUN chown -R vscode:vscode /home/vscode

# Here I try to setup all this in the vscode userspace
# It appears these need to be run as the user.
USER vscode
COPY .devcontainer/julia-setup.jl julia-setup.jl
RUN julia julia-setup.jl

RUN raco pkg install --batch --deps search-auto iracket || true && raco iracket install || true

# setup for chromium so that webpdf works
# I had to monkey-patch the chrome executable with a shell script that uses --no-sandbox in .devcontainer/chrome
# to get the menu in jupyter lab to work
RUN pyppeteer-install \
    && mv /home/vscode/.local/share/pyppeteer/local-chromium/588429/chrome-linux/chrome /home/vscode/.local/share/pyppeteer/local-chromium/588429/chrome-linux/chrome-exe 
COPY .devcontainer/chrome /home/vscode/.local/share/pyppeteer/local-chromium/588429/chrome-linux/

