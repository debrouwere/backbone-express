all:
	coffee -co lib src
	cat vendor/backbone/0.9.1/backbone.min.js lib/client.js | uglifyjs -o backbone-express.min.js
	mkdir -p example/vendor/backbone-express/0.1.0
	cp backbone-express.min.js example/vendor/backbone-express/0.1.0/backbone-express.min.js

clean:
	rm -rf lib

test: all
	./node_modules/.bin/mocha --reporter list
