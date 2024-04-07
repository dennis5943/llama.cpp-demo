from llama_cpp import Llama

llm = Llama(
    model_path="/app/mymodels/ggml-model-Q4_K_M.Taiwan-LLM-13B.gguf",
    n_gpu_layers=100,
    verbose=True,
)

output = llm(
    "### USER: 7*9等於多少\n\n### ASSISTANT:",
    max_tokens=256,
    stop=["###"],
    stream=True,
)

for token in output:
    print(end=token["choices"][0]["text"], flush=True)