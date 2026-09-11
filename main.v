module main

import os
import veb
import typ
import time
import infra
import entities
import guweigang.vmarkdown

pub struct Context {
	veb.Context
}

pub struct App {
	veb.StaticHandler
pub:
	content_json shared typ.ContentDbJson
	base_path    string
}

pub struct PostCard {
pub:
	headline string
	url      string
	image    string
	date_pt  string
	author   string
}

fn post_card(post entities.Post, base_path string) PostCard {
	author := if post.authors.len > 0 { post.authors[0].name } else { 'Tábua de Maré' }
	return PostCard{
		headline: post.headline
		url: '${base_path}/post/${post.slug}'
		image: infra.get_image_main_post(post)
		date_pt: format_date(post.data)
		author: author
	}
}

fn suggested_post_cards(posts []entities.Post, current_slug string, base_path string) []PostCard {
	mut cards := []PostCard{}
	for post in posts {
		if post.slug == current_slug {
			continue
		}
		cards << post_card(post, base_path)
		if cards.len == 3 {
			break
		}
	}
	return cards
}

fn normalize_base_path(raw_path string) string {
	trimmed_path := raw_path.trim_space().trim_right('/')
	if trimmed_path == '' {
		return ''
	}
	if trimmed_path.starts_with('/') {
		return trimmed_path
	}
	return '/${trimmed_path}'
}

fn server_port(raw_port string) int {
	port := raw_port.int()
	if port > 0 && port <= 65535 {
		return port
	}
	return 8080
}

fn format_date(iso string) string {
	if iso.len < 10 {
		return iso
	}
	return '${iso[8..10]} ${month_pt(iso[5..7])} ${iso[..4]}'
}

fn month_pt(month string) string {
	return match month {
		'01' { 'jan' }
		'02' { 'fev' }
		'03' { 'mar' }
		'04' { 'abr' }
		'05' { 'mai' }
		'06' { 'jun' }
		'07' { 'jul' }
		'08' { 'ago' }
		'09' { 'set' }
		'10' { 'out' }
		'11' { 'nov' }
		else { 'dez' }
	}
}

@['/']
pub fn (app &App) index() veb.Result {
	title := 'Tábua de maré API BLOG'
	base_path := app.base_path

	mut registers_posts := []entities.Post{}

	lock app.content_json {
		if app.content_json.content.len == 0 || app.content_json.expire < time.utc() {
			app.content_json = infra.get_db_json() or { typ.ContentDbJson{} }
		}
		content_json := app.content_json

		registers_posts = infra.addapt(content_json) or { [] }
	}

	has_featured := registers_posts.len > 0
	featured := if has_featured {
		post_card(registers_posts[0], base_path)
	} else {
		PostCard{}
	}
	mut cards := []PostCard{}
	for i := 0; i < registers_posts.len; i++ {
		cards << post_card(registers_posts[i], base_path)
	}

	return $veb.html()
}

@['/health'; get]
pub fn (app &App) health(mut ctx Context) veb.Result {
	return ctx.no_content()
}

@['/post/:slug'; get]
pub fn (app &App) post(mut ctx Context, slug string) veb.Result {
	base_path := app.base_path
	mut registers_posts := []entities.Post{}

	lock app.content_json {
		if app.content_json.content.len == 0 || app.content_json.expire < time.utc() {
			app.content_json = infra.get_db_json() or {
				return ctx.server_error_with_status(.internal_server_error)
			}
		}
		content_json := app.content_json
		registers_posts = infra.addapt(content_json) or { [] }
	}

	post := registers_posts.filter(it.slug == slug)[0] or { return ctx.not_found() }
	suggested_posts := suggested_post_cards(registers_posts, slug, base_path)

	content_post := infra.get_post(post) or { return ctx.server_error_with_status(.internal_server_error) }
	content := veb.RawHtml(vmarkdown.render_html(content_post) or { '' })

	title := '${post.headline} | Tábua de Maré'
	description := post.title
	canonical := 'https://tabuamare.api.br/blog/post/${post.slug}'
	eyebrow := 'Artigo'
	lead := post.headline
	date_pt := format_date(post.data)
	main_image := infra.get_image_main_post(post)
	name_author := if post.authors.len > 0 {
		post.authors.filter(it.typ.contains('creator')).map(it.name).join(', ')
	} else {
		'Tábua de Maré'
	}

	return $veb.html()
}

fn main() {
	os.chdir(os.dir(os.executable()))!
	mut app := &App{
		base_path: normalize_base_path(os.getenv('BLOG_BASE_PATH'))
	}
	app.handle_static('assets', false)!
	veb.run[App, Context](mut app, server_port(os.getenv('PORT')))
}
