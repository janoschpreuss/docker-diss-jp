FROM schruste/ngsolve:latest

USER root
RUN apt-get install -y \
  libgoogle-glog-dev \
  libatlas-base-dev \
  libeigen3-dev \
  libsuitesparse-dev \
  libflint-arb-dev \
  install libflint-arb2 \
  wget

RUN pip3 install psutil mpmath
        
WORKDIR /home/app
RUN wget http://ceres-solver.org/ceres-solver-1.14.0.tar.gz
RUN tar zxf ceres-solver-1.14.0.tar.gz
RUN mkdir /home/app/ceres-bin
WORKDIR /home/app/ceres-bin
RUN cmake ../ceres-solver-1.14.0
RUN make -j3
RUN make install

WORKDIR /home/app        
RUN git clone https://gitlab.gwdg.de/learned_infinite_elements/diss_jp_repro
WORKDIR /home/app/diss_jp_repro
RUN git pull origin master
RUN git submodule update --init --recursive  
WORKDIR /home/app/diss_jp_repro/ngs_refsol
RUN python3 setup.py install --user  
WORKDIR /home/app/diss_jp_repro/ceres_dtn
RUN python3 setup.py install --user
WORKDIR /home/app/diss_jp_repro/ngs_arb
RUN python3 setup.py install --user
WORKDIR /home/app/diss_jp_repro/pole_finder
RUN python3 setup.py install --user
        
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
        
WORKDIR /home/app/diss_jp_repro/reproduction
                
