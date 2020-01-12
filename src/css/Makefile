all: site

site: site.scss
	sassc --style expanded site.scss ../../public/css/site.css

diary: site diary.scss
	sassc --style expanded diary.scss diary.css

clean:
	rm -rf site.css diary.css
