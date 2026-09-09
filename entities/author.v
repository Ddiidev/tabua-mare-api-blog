module entities

pub struct Author {
pub mut:
	created_at string @[omitempty]
	email      string @[omitempty]
	name       string @[omitempty]
	typ        []string @[json: 'type'; omitempty]
}
