# syntax=docker.io/docker/dockerfile:1.4
FROM --platform=linux/riscv64 cartesi/python:3.10-slim-jammy

WORKDIR /opt/cartesi/dapp

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential wget xxd git git-lfs \
  && rm -rf /var/apt/lists/*


# stories15M model
# ARG FILE_NAME=stories15M.bin
# ARG FILE_URL=https://huggingface.co/karpathy/tinyllamas/resolve/main/stories15M.bin
# RUN wget https://huggingface.co/karpathy/tinyllamas/resolve/main/stories15M.bin
# COPY ./stories15M.bin .
# Try to copy the file. If it doesn't exist, download it using wget.
# RUN if ! cp $FILE_NAME /$FILE_NAME 2>/dev/null; then wget -O /$FILE_NAME $FILE_URL; fi
# COPY ./tokenizer.bin .
# COPY ./stories15M.bin .
# COPY ./run.c .
# RUN gcc -Ofast run.c  -lm  -o run

# phi-2 model
RUN git clone https://github.com/ggerganov/llama.cpp
WORKDIR /opt/cartesi/dapp/llama.cpp
RUN make
RUN pip3 install huggingface-hub
# RUN huggingface-cli download TheBloke/dolphin-2_6-phi-2-GGUF dolphin-2_6-phi-2.Q4_K_M.gguf --local-dir . --local-dir-use-symlinks False
WORKDIR /opt/cartesi/dapp/llama.cpp/models
RUN huggingface-cli download TheBloke/phi-2-dpo-GGUF phi-2-dpo.Q4_K_M.gguf --local-dir . --local-dir-use-symlinks False
WORKDIR /opt/cartesi/dapp


COPY ./requirements.txt .
RUN pip install -r requirements.txt --no-cache \
  && find /usr/local/lib -type d -name __pycache__ -exec rm -r {} +

COPY ./entrypoint.sh .
COPY ./trust-and-teach.py .
