module infra

fn test_versioned_content_is_available_locally() {
	db := get_db_json() or { panic('db.json nao encontrado') }
	posts := addapt(db) or { panic('db.json invalido') }

	assert posts.len > 0
	content := get_post(posts[0]) or { panic('conteudo do post nao encontrado') }
	assert content.len > 0
}
