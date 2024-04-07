# 使用基於 Ubuntu 的 Docker 鏡像作為基礎
FROM ubuntu:latest as builder

# 更新 apt 資源庫
RUN apt-get update

# 安裝所需的開發工具、依賴項和 Python 3.9
RUN apt-get install -y \
    build-essential \
    cmake \
    git 

# 在容器中建立工作目錄
WORKDIR /app

# 複製 ggerganov/llama.cpp 專案的內容到容器的工作目錄
RUN git clone https://github.com/ggerganov/llama.cpp.git .

# 使用 CMake 建立專案
RUN mkdir /build
WORKDIR /build
RUN cmake ../app
RUN make

# ==============================================================
FROM python:3.9.19

# 在容器中建立工作目錄
WORKDIR /app

RUN mkdir /llama.cpp.build
WORKDIR /app/llama.cpp.build

# 复制第一段的构建结果到第二段
COPY --from=builder /build/ .

RUN mkdir /llama.cpp
WORKDIR /app/llama.cpp
COPY --from=builder /app/ .
RUN pip3 install -r requirements.txt

ENV MODEL_PATH=/app/models/default.gguf
WORKDIR /app/llama.cpp.build/bin

EXPOSE 8080
#--host: Set the hostname or ip address to listen. Default 127.0.0.1
#--port: Set the port to listen. Default: 8080
#./server -m /app/models/default.gguf -ngl 100 --host 0.0.0.0 --port 8080
CMD ["./server", "-m", "/app/models/default.gguf", "-ngl", "100", "--host", "0.0.0.0", "--port", "8080","--embedding"]