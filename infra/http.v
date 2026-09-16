module infra

import typ
import time
import json2
import net.http
import entities

pub fn get_db_json() ?typ.ContentDbJson {
	content := if res := http.get('https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/db.json') {
		if res.status_code != 200 {
			return none
		}
		res.body
	} else {
		'Conteúdo indisponível no momento ou em construção 👷🏻'
	}

	expire := time.utc().add_days(5)

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
	return if res := http.get('https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/posts/${post.path_post}/content.md') {
		if res.status_code != 200 {
			return none
		}
		res.body
	} else {
		'Conteúdo indisponível no momento ou em construção 👷🏻'
	}
}

pub fn get_image_main_post(post entities.Post) string {
	return 'https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/${post.image}'
}
