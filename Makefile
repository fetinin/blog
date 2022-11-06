build:
	git submodule update --remote &&\
	rm -rf _build/* &&\
	rm -rf content/posts/* &&\
	obsidian-export ./knowledge_base/ ./_build && cp -R _build/blogposts/ content/posts/ &&\
	rm -rf public/ &&\
	hugo

release:
	git add . &&\
	git commit -m "Updated: `date +'%Y-%m-%d'`" &&\
	git push
