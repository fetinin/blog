build:
	git submodule update --recursive --remote &&\
	obsidian-export ./knowledge_base/ ./_build && cp -R _build/blogposts/ content/posts/ &&\
	hugo

release:
	git add . &&\
	git commit -m "Updated: `date +'%Y-%m-%d'`" &&\
	git push
