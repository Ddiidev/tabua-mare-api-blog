module main

import os
import veb

pub struct Context {
	veb.Context
}

pub struct App {
	veb.StaticHandler
}

pub fn (app &App) index() veb.Result {
	title := 'tabua_mare_api_blog'
	message := 'Your new V web app is powered by veb.'
	return $veb.html()
}

@['/health'; get]
pub fn (app &App) health(mut ctx Context) veb.Result {
	return ctx.text('ok')
}

fn main() {
	os.chdir(os.dir(@FILE))!
	mut app := &App{}
	app.handle_static('assets', false)!
	veb.run[App, Context](mut app, 3330)
}
