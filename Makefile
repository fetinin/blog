build:
	git submodule update --remote &&\
	rm -rf content/posts/* &&\
	cp -R knowledge_base/blogposts/ content/posts/ &&\
	rm -rf public/ &&\
	hugo

release:
	git add . &&\
	git commit -m "Updated: `date +'%Y-%m-%d'`" &&\
	git push
