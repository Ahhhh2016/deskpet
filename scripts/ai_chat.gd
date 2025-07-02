extends Node

var api_key = ""
var app_id = "49ab8a790c11476588d9dd4746b745bb" # Qwen application id, with some prompts set up
var url = "https://dashscope.aliyuncs.com/api/v1/apps/%s/completion" % app_id

# Reference to the HTTPRequest node (used to send HTTP requests)
@onready var http_request = $HTTPRequest  

@onready var responsebox = $"../ResponseBox"
func _ready():
	if http_request == null:
		print("http_request is null")
		return
	http_request.request_completed.connect(_on_request_completed)

# Set the apikey from the setting panel
func set_api_key(key: String):
	api_key = key
	#print("key here", api_key)


func send_message(message: String):
	#print("Send message to API: ", message)
	responsebox.show()
	
	var headers = [
		"Authorization: Bearer " + api_key,
		"Content-Type: application/json"
	]
	
	var body = {
		"input": {
			"prompt": message  # User input 
		},
		"parameters": {},
		"debug": {}
	}

	var json_body = JSON.stringify(body)

	# Send a POST request to the API
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if error != OK:
		print("HTTP request failed with error code: ", error)

# handle the API response
func _on_request_completed(result, response_code, headers, body):
	var data = body.get_string_from_utf8()
	#print("Original data：", data)
	
	var response = JSON.parse_string(data) # Returns null if parsing failed.
	response = response["output"]["text"]
	#print(response)
	
	# Display the response in the UI
	responsebox.text = response
