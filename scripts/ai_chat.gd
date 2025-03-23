extends Node

var url = "https://dashscope.aliyuncs.com/api/v1/apps/49ab8a790c11476588d9dd4746b745bb/completion"
var api_key = "sk-3e99f796630442e7887c27ad94d8cdef"

@onready var http_request = $HTTPRequest  # 获取 HTTPRequest 节点
@onready var responsebox = $"../ResponseBox"
func _ready():
	if http_request == null:
		print("http_request is null")
		return
	http_request.request_completed.connect(_on_request_completed)

func send_message(message: String):
	print("发送消息到 API: ", message)
	responsebox.show()
	
	var headers = [
		"Authorization: Bearer " + api_key,
		"Content-Type: application/json"
	]

	var body = {
		"model": "qwen-plus",  # 确保使用正确的模型
		"messages": [{"role": "user", "content": message}]
	}

	var json_body = JSON.stringify(body)

	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if error != OK:
		print("HTTP 请求失败，错误代码: ", error)

# 处理 API 响应
func _on_request_completed(result, response_code, headers, body):
	var data = body.get_string_from_utf8()
	var response = JSON.parse_string(data) # Returns null if parsing failed.
	#response = response["choices"][0]["message"]["content"]
	print(response)
	#responsebox.text = response
