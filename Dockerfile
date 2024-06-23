FROM debian:11

COPY sources.list /etc/apt/sources.list
RUN apt update && apt install nano apt-transport-https ca-certificates supervisor build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev gcc libicu-dev libglib2.0-0 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libatspi2.0-0 libxcomposite1 libxdamage1 libxext6 libxfixes3 libxrandr2 libgbm1 libxkbcommon0 libpango-1.0-0 libcairo2 libasound2 fonts-wqy-zenhei locales -y

# 设置环境变量
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

# 生成 C.UTF-8 locale & 确认 locale 设置
RUN locale-gen C.UTF-8 && update-locale LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /workspace
COPY Python-3.11.1.tgz .
RUN tar -zxvf Python-3.11.1.tgz
WORKDIR /workspace/Python-3.11.1
RUN ./configure --prefix=/workspace/python3.11.1 --enable-optimizations && make && make install
WORKDIR /workspace
#RUN rm -rf Python-3.11.1/ Python-3.11.1.tgz && ln -sf /workspace/python3.11.1/bin/python3 /usr/bin/python && ln -sf /workspace/python3.11.1/bin/pip3 /usr/bin/pip && pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ && python -m pip install --upgrade pip && python -m pip install --user pipx && python -m pipx ensurepath && python -m pipx install nb-cli
RUN rm -rf Python-3.11.1/ Python-3.11.1.tgz && ln -sf /workspace/python3.11.1/bin/python3 /usr/bin/python && ln -sf /workspace/python3.11.1/bin/pip3 /usr/bin/pip && pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ && python -m pip install --upgrade pip python -m pip install nb-cli


COPY Lagrange.OneBot .
RUN chmod +x Lagrange.OneBot

COPY start.sh .
COPY nbrun.sh .
COPY lgrrun.sh .
RUN chmod 777 start.sh && chmod 777 nbrun.sh && chmod 777 lgrrun.sh

CMD [ "/workspace/start.sh" ]