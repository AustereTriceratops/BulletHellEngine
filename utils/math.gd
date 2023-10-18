extends Node

func average_vec2_array(arr):
	var length = arr.size()
	var result = Vector2(0, 0)
	
	for i in range(length):
		result += arr[i]
	
	if length > 0:
		result /= length
	
	return result
