OLLAMA_FILE="$(dpkg --print-architecture)"; 
case "$OLLAMA_FILE" in \
    arm64) export OLLAMA_OPTIONS='arm64' ;; \
    amd64) export OLLAMA_OPTIONS='amd64-rocm' ;; \
esac; 
echo "Installing ollama for '$OLLAMA_FILE' with '$OLLAMA_OPTIONS' options"

file_name=ollama-linux-$OLLAMA_FILE.tgz
echo "Downloading $file_name..."
curl -L https://ollama.com/download/$file_name -o $file_name

if [ ! -f $file_name ]; then
    echo "File '$file_name' failed to download!" >&2
else 
    echo "File '$file_name' was found" >&1
fi
echo "Extracting '$file_name' in /usr..."
tar -C /usr -xzf $file_name

# getting extra cuda files for AMD
if [ $OLLAMA_FILE = "amd64" ]; then
    echo "Installing extra packages for $OLLAMA_FILE.." 
    apt install amdgpu-install

    file_cuda=ollama-linux-$OLLAMA_OPTIONS.tgz
    echo "Downloading CUDA file $file_cuda..."
    curl -L https://ollama.com/download/$file_cuda -o $file_cuda

    echo "Extracting CUDA '$file_cuda' in /usr..."
    tar -C /usr -xzf $file_cuda

    exit 0
fi
