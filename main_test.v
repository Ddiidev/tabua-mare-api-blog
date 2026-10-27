module main

import entities
import json2

fn test_normalize_base_path() {
	assert normalize_base_path('') == ''
	assert normalize_base_path('/') == ''
	assert normalize_base_path('/blog/') == '/blog'
	assert normalize_base_path(' blog ') == '/blog'
}

fn test_wrap_tables_wraps_every_table() {
	html := '<p>antes</p>\n<table>\n<tr><th>Hora</th></tr>\n</table>\n<p>depois</p>'

	wrapped := wrap_tables(html)

	assert wrapped.count('<div class="table-scroll">') == 1
	assert wrapped.count('</div>') == 1
	assert wrapped.contains('<div class="table-scroll"><table>')
	assert wrapped.contains('</table></div>')
	assert wrapped.contains('<p>antes</p>')
	assert wrapped.contains('<p>depois</p>')
}

fn test_wrap_tables_keeps_text_without_table_untouched() {
	assert wrap_tables('<p>so texto</p>') == '<p>so texto</p>'
}

fn test_server_port() {
	assert server_port('') == 8080
	assert server_port('invalid') == 8080
	assert server_port('0') == 8080
	assert server_port('65536') == 8080
	assert server_port('9090') == 9090
}

fn test_build_sitemap_lists_home_and_every_post() {
	posts := [
		entities.Post{
			slug: 'oque-e-a-tabua-de-mare-api'
			data: '2026-09-16T00:00:00Z'
		},
		entities.Post{
			slug: 'lendo-a-mare-alta'
			data: '2026-09-20T00:00:00Z'
		},
	]
	xml := build_sitemap(posts, '/blog')

	assert xml.starts_with('<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
	assert xml.ends_with('</urlset>\n')
	assert xml.count('<url>') == 3
	assert xml.contains('<loc>https://tabuamare.api.br/blog</loc>')
	assert xml.contains('<loc>https://tabuamare.api.br/blog/post/oque-e-a-tabua-de-mare-api</loc>')
	assert xml.contains('<loc>https://tabuamare.api.br/blog/post/lendo-a-mare-alta</loc>')
	assert xml.contains('<lastmod>2026-09-16T00:00:00Z</lastmod>')
}

fn test_build_sitemap_keeps_home_when_there_is_no_post() {
	xml := build_sitemap([], '/blog')

	assert xml.count('<url>') == 1
	assert xml.contains('<loc>https://tabuamare.api.br/blog</loc>')
	assert !xml.contains('<lastmod>')
}

fn test_build_sitemap_omits_lastmod_when_post_has_no_date() {
	xml := build_sitemap([entities.Post{
		slug: 'sem-data'
	}], '/blog')

	assert xml.contains('<loc>https://tabuamare.api.br/blog/post/sem-data</loc>')
	assert !xml.contains('<lastmod>')
}

fn test_build_blog_posting_schema_encodes_content_and_authors() {
	post := entities.Post{
		headline: 'Título "com" barra \\ e </script>\nsegunda linha'
		title:    'Descrição do artigo'
		data:     '2026-10-20T00:00:00Z'
		authors:  [
			entities.Author{ name: 'André Luiz', email: 'privado@example.com' }
			entities.Author{ name: 'Outra autora' },
		]
	}
	encoded := build_blog_posting_schema(post, 'https://tabuamare.api.br/blog/post/teste', 'https://example.com/image.jpg')
	assert !encoded.contains('</script>')
	assert encoded.contains('\\u003c/script\\u003e')
	decoded := json2.decode[json2.Any](encoded) or { panic(err) }
	root := decoded.as_map()
	headline := root['headline'] or { panic('missing headline') }
	assert headline.str() == post.headline
	assert !encoded.contains('privado@example.com')
	authors_value := root['author'] or { panic('missing author') }
	authors := authors_value.as_array()
	assert authors.len == 2
	first_type := authors[0].as_map()['@type'] or { panic('missing first author type') }
	second_name := authors[1].as_map()['name'] or { panic('missing second author name') }
	assert first_type.str() == 'Person'
	assert second_name.str() == 'Outra autora'
}

fn test_build_blog_posting_schema_uses_organization_fallback() {
	post := entities.Post{ headline: 'Sem autor', title: 'Descrição' }
	encoded := build_blog_posting_schema(post, 'https://tabuamare.api.br/blog/post/sem-autor', '')
	decoded := json2.decode[json2.Any](encoded) or { panic(err) }
	author_value := decoded.as_map()['author'] or { panic('missing author') }
	author := author_value.as_array()[0].as_map()
	author_type := author['@type'] or { panic('missing author type') }
	author_name := author['name'] or { panic('missing author name') }
	assert author_type.str() == 'Organization'
	assert author_name.str() == 'Tábua de Maré'
}
