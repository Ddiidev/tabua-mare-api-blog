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
	ch := chan string{}
	go fn [ch, url] () {
		res := http.get(url) or {
			ch <- ''
			return
		}
		ch <- if res.status_code == 200 { res.body } else { '' }
	}()
	select {
		body := <-ch {
			if body.len == 0 {
				return none
			}
			return body
		}
		fetch_timeout {
			return none
		}
	}
	return none
}

pub fn get_db_json() ?typ.ContentDbJson {
	content := fetch_url(raw_base + 'db.json') or {
		return none
	}

	expire := time.utc().add_days(3)

	return typ.ContentDbJson{
		content: content
		expire:  expire
	}
}

pub fn addapt(content_db_json typ.ContentDbJson) ?[]entities.Post {
	posts := json2.decode[[]entities.Post](content_db_json.content) or { return none }

	return posts
}

pub fn get_post(post entities.Post) ?string {
	if body := fetch_url(raw_base + 'posts/${post.path_post}/content.md') {
		return body
	}
	// fallback: conteúdo empacotado na imagem
	return os.read_file(os.join_path('posts', post.path_post, 'content.md')) or { return none }
}

pub fn get_image_main_post(post entities.Post) string {
	return 'https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/${post.image}'
}