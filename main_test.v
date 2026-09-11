module main

fn test_normalize_base_path() {
	assert normalize_base_path('') == ''
	assert normalize_base_path('/') == ''
	assert normalize_base_path('/blog/') == '/blog'
	assert normalize_base_path(' blog ') == '/blog'
}

fn test_server_port() {
	assert server_port('') == 8080
	assert server_port('invalid') == 8080
	assert server_port('0') == 8080
	assert server_port('65536') == 8080
	assert server_port('9090') == 9090
}
