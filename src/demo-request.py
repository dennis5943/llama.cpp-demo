import requests
import json

# source url: https://ithelp.ithome.com.tw/articles/10331129

url = "http://127.0.0.1:8080/completion"
prompt = """### USER: 什麼是語言模型？

### ASSISTANT: """

params = {
    "prompt": "### USER: 8+9等於?\n\n### ASSISTANT: ",
    "stream": True,
    "stop": ["###", "\n\n\n"],
}

resp = requests.post(url, json=params, stream=True)
for chunk in resp.iter_lines():
    if not chunk:
        continue
    # 會有固定的 "data:" 前綴，需要跳掉 5 個字元
    content = json.loads(chunk[5:])["content"]
    print(end=content, flush=True)