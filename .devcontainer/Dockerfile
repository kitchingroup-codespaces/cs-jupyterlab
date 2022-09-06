FROM jupyter/datascience-notebook

USER root

# [Optional] Uncomment this section to install additional OS packages.
# These packages are to get PDF export via LaTeX (minimal) and via webpdf
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends pandoc \
     texlive-xetex texlive-fonts-recommended texlive-plain-generic \
     xorg xvfb gtk2-engines-pixbuf \
     dbus-x11 xfonts-base xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable \
     libnss3-dev libxss1 libcups2 libasound2 libpangocairo-1.0-0 libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 \
     nodejs npm libzmq3-dev build-essential
    
# Racket
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends racket racket-doc

RUN python -m pip install --upgrade pip \
    && python -m pip install pycse nbconvert nbconvert[webpdf] \
    plotly \
    pytest \
    black flake8 pylint \
    pycse pint quantities pyDOE2\
    lmfit pysr jax[cpu] \
    jupyterlab-git jupyter-videochat \
    && jupyter labextension install plotlywidget 
    

ENV SHELL=/bin/bash

# Hack for controlling how chromium works with no-sandbox and allow-downloads
RUN mkdir -p /home/jovyan/.jupyter
COPY .devcontainer/jupyter_nbconvert_config.py /home/jovyan/.jupyter/jupyter_nbconvert_config.py
COPY .devcontainer/jupyter_lab_config.py /home/jovyan/.jupyter/jupyter_lab_config.py
COPY .devcontainer/jupyter_server_config.json /home/jovyan/.jupyter/jupyter_server_config.json

RUN raco setup --doc-index --force-user-docs 
RUN raco pkg install --batch --deps search-auto iracket 
RUN raco iracket install 

RUN fix-permissions /home/jovyan/.jupyter
RUN fix-permissions /home/jovyan/.local

USER ${NB_UID}


RUN pyppeteer-install \
    && mv /home/jovyan/.local/share/pyppeteer/local-chromium/588429/chrome-linux/chrome /home/jovyan/.local/share/pyppeteer/local-chromium/588429/chrome-linux/chrome-exe 

COPY .devcontainer/chrome /home/jovyan/.local/share/pyppeteer/local-chromium/588429/chrome-linux/chrome

RUN pip install jupyterlab-link-share \
    && jupyter server extension disable nbclassic  
