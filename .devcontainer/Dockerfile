# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.236.0/containers/python-3-anaconda/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/anaconda:0-3

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Copy environment.yml (if found) to a temp location so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
COPY environment.yml* .devcontainer/noop.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends pandoc \
     texlive-xetex texlive-fonts-recommended texlive-plain-generic \
     xorg xvfb gtk2-engines-pixbuf \
     dbus-x11 xfonts-base xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable \
     libnss3-dev libxss1 libcups2 libasound2 libpangocairo-1.0-0 libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 \
     nodejs npm libzmq3-dev  tree

RUN mkdir -p /home/vscode/.jupyter
COPY .devcontainer/jupyter_nbconvert_config.py /home/vscode/.jupyter/jupyter_nbconvert_config.py
COPY .devcontainer/jupyter_lab_config.py /home/vscode/.jupyter/jupyter_lab_config.py

# # Make sure everything in vscode belongs to vscode
RUN chown -R vscode:vscode /home/vscode

RUN python -m pip install --upgrade pip \
    && python -m pip install nbconvert nbconvert[webpdf] \
    plotly \
    jax[cpu] \
    jupyterlab-link-share \
    && jupyter labextension install plotlywidget \
    # the jupyter-link-share breaks jupyter lab unless you disable this.
    && jupyter server extension disable nbclassic 

# Julia
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends julia 

# R
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends r-base  \
     && Rscript -e "install.packages('IRkernel'); IRkernel::installspec(user = FALSE)"

# # Racket
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends racket racket-doc      


# Up to this point the build succeeds. Past it, the build fails with something like
# #21 exporting to image
# #21 sha256:e8c613e07b0b7ff33893b694f7759a10d42e180f2b4dc349fb57dc6b71dcab00
# #21 exporting layers
# unexpected EOF


######## USER code ##############

USER vscode
COPY .devcontainer/julia-setup.jl julia-setup.jl
RUN julia julia-setup.jl

RUN raco pkg install --batch --deps search-auto iracket && raco iracket install

RUN pyppeteer-install \
    && mv /home/vscode/.local/share/pyppeteer/local-chromium/588429/chrome-linux/chrome /home/vscode/.local/share/pyppeteer/local-chromium/588429/chrome-linux/chrome-exe 
COPY .devcontainer/chrome /home/vscode/.local/share/pyppeteer/local-chromium/588429/chrome-linux/

