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
# These packages are to get PDF export via LaTeX (minimal) and via webpdf
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends pandoc \
     texlive-xetex texlive-fonts-recommended texlive-plain-generic \
     xorg xvfb gtk2-engines-pixbuf \
     dbus-x11 xfonts-base xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable \
     libnss3-dev libxss1 libcups2 libasound2 libpangocairo-1.0-0 libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 \
     nodejs npm

# Julia
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends julia \
     && julia -e "using Pkg; Pkg.add(\"IJulia\")"

# R
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends r-base \
     && Rscript -e "install.packages('IRkernel'); IRkernel::installspec(user = FALSE)"

RUN mkdir -p /home/vscode/.jupyter
COPY .devcontainer/jupyter_nbconvert_config.py /home/vscode/.jupyter/jupyter_nbconvert_config.py
RUN chown -R vscode:vscode /home/vscode/.jupyter

RUN pip install pycse nbconvert nbconvert[webpdf] \
    plotly \
    && jupyter labextension install plotlywidget \
    && pyppeteer-install \
    # this installs in root, and we need to move this to be owned by the vscode user
    && mv /root/.local /home/vscode/ \
    && mv /home/vscode/.local/share/pyppeteer/local-chromium/588429/chrome-linux/chrome /home/vscode/.local/share/pyppeteer/local-chromium/588429/chrome-linux/chrome-exe \
    && chown -R vscode:vscode /home/vscode/.local

COPY .devcontainer/chrome /home/vscode/.local/share/pyppeteer/local-chromium/588429/chrome-linux/

# This makes the jupyter lab terminal be a bash shell, with completion and color 
ENV SHELL=/bin/bash

# This installs my class customization for MC questions. you do not need it in general
RUN git clone https://github.com/jkitchin/f21-06623.git && cd f21-06623 && pip install .

# Extensions
RUN pip install jupyterlab-git