module entities

pub struct Post {
pub mut:
	assets_path  string   @[omitempty]
	authors      []Author @[omitempty]
	content_path string   @[omitempty]
	data         string   @[omitempty]
	headline     string   @[omitempty]
	image        string   @[omitempty]
	slug         string   @[omitempty]
	path_post    string   @[omitempty]
	title        string   @[omitempty]
}
