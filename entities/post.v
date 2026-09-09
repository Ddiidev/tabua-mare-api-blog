module entities

pub struct Post {
pub mut:
	assets_path  string @[json: "assets-path"; omitempty]
	authors      []Author @[omitempty]
	content_path string @[json: "content-path"; omitempty]
	data         string @[omitempty]
	headline     string @[omitempty]
	image        string @[omitempty]
	slug         string @[omitempty]
	title        string @[omitempty]
}
