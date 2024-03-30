# build everything for production
all: css build
	@echo "--- production build finished"

# build only css for production
css:
	@echo "--- building tailwind css"
	npx tailwindcss -i ./src/input.css -o ./static/main.css --minify

# compile only elm for production
build:
	@echo "--- compiling elm land project"
	npx elm-land build
	hugo --source blog --destination ../dist --minify

# compile and watch for dev
elm-serve:
	npx elm-land server

# build css and watch
css-serve:
	npx tailwindcss -i ./src/input.css -o ./static/main.css --watch

# clean
clean:
	rm -rf dist
	rm -rf blog/public