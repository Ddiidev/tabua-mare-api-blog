module infra

import json2
import os
import time
import entities
import typ

pub fn get_db_json() ?typ.ContentDbJson {
	content := os.read_file('db.json') or {
		return none
	}

	expire := time.utc().add_days(5)

	return typ.ContentDbJson{
		content: content
		expire: expire
	}
}

pub fn addapt(content_db_json typ.ContentDbJson) ?[]entities.Post {
	posts := json2.decode[[]entities.Post](content_db_json.content) or {
		return none
	}

	return posts
}

pub fn get_post(post entities.Post) ?string {
	return os.read_file(os.join_path('posts', post.slug, 'content.md')) or {
		return none
	}
}

pub fn get_image_main_post(post entities.Post) string {
	return 'https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/${post.image}'
}
