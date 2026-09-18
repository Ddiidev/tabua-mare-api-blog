module infra

import typ
import time
import json2
import net.http
import os
import entities

const raw_base = 'https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/'

// limite total do fetch: sem isso, um TCP pendurado (ex: IPv6 sem rota no
// container) trava o request indefinidamente, pois o read_timeout só cobre a
// leitura da resposta
const fetch_timeout = 10 * time.second

fn fetch_url(url string) ?string {
	t0 := time.now()
	ch := chan string{}
	go fn [ch, url] () {
		gt0 := time.now()
		res := http.get(url) or {
			println('[timing][fetch_url] url=${url} http_get_err=${time.since(gt0)}')
			ch <- ''
			return
		}
		println('[timing][fetch_url] url=${url} http_get=${time.since(gt0)} status=${res.status_code} bytes=${res.body.len}')
		ch <- if res.status_code == 200 { res.body } else { '' }
	}()
	select {
		body := <-ch {
			if body.len == 0 {
				println('[timing][fetch_url] url=${url} total=${time.since(t0)} empty')
				return none
			}
			println('[timing][fetch_url] url=${url} total=${time.since(t0)}')
			return body
		}
		fetch_timeout {
			println('[timing][fetch_url] url=${url} total=${time.since(t0)} TIMEOUT')
			return none
		}
	}
	return none
}

pub fn get_db_json() ?typ.ContentDbJson {
	t0 := time.now()
	content := fetch_url(raw_base + 'db.json') or {
		println('[timing][get_db_json] fetch=${time.since(t0)} FAILED')
		return none
	}

	expire := time.utc().add_days(3)

	println('[timing][get_db_json] fetch=${time.since(t0)} bytes=${content.len}')
	return typ.ContentDbJson{
		content: content
		expire:  expire
	}
}

pub fn addapt(content_db_json typ.ContentDbJson) ?[]entities.Post {
	t0 := time.now()
	posts := json2.decode[[]entities.Post](content_db_json.content) or {
		println('[timing][addapt] decode=${time.since(t0)} FAILED bytes=${content_db_json.content.len}')
		return none
	}

	println('[timing][addapt] decode=${time.since(t0)} posts=${posts.len}')
	return posts
}

pub fn get_post(post entities.Post) ?string {
	t0 := time.now()
	if body := fetch_url(raw_base + 'posts/${post.path_post}/content.md') {
		println('[timing][get_post] slug=${post.slug} fetch=${time.since(t0)} bytes=${body.len}')
		return body
	}
	// fallback: conteúdo empacotado na imagem
	if body := os.read_file(os.join_path('posts', post.path_post, 'content.md')) {
		println('[timing][get_post] slug=${post.slug} disk_fallback=${time.since(t0)} bytes=${body.len}')
		return body
	}
	println('[timing][get_post] slug=${post.slug} total=${time.since(t0)} FAILED')
	return none
}

pub fn get_image_main_post(post entities.Post) string {
	return 'https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/${post.image}'
}
