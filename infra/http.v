module infra

import json2
import net.http
import time
import entities
import typ

const url_json_db = 'https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/db.json'
const template_url_content_post = 'https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/posts'

pub fn get_db_json() ?typ.ContentDbJson {
	resp := http.get(url_json_db) or {
		return none
	}

	expire := time.utc().add_days(5)

	return typ.ContentDbJson{
		content: resp.body
		expire:  expire
	}
}

pub fn addapt(content_db_json typ.ContentDbJson) ?[]entities.Post {
	posts := json2.decode[[]entities.Post](content_db_json.content) or {
		return none
	}

	return posts
}

pub fn get_post(post entities.Post) ?string {
	resp := http.get('${template_url_content_post}/${post.slug}/content.md') or {
		return none
	}

	if resp.status_code == 200 {
		return resp.body
	}

	return none
}

pub fn get_image_main_post(post entities.Post) string {
	return 'https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/${post.image}'
}