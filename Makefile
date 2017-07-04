BASH_COMPLETION_DIR := '/usr/local/etc/bash_completion.d'
MEDIA_SCRIPTS = media \
	media-add \
	media-convert-video \
	media-create-metadata-file \
	media-extract-metadata \
	media-get-episode-title \
	media-install \
	media-itunes-add \
	media-make-episode-dir \
	media-set-artwork \
	media-tag-video
COMPLETION_SCRIPTS = media


all:

install:
	for script in $(MEDIA_SCRIPTS); do \
		install bin/$$script /usr/local/bin; done
	for script in $(COMPLETION_SCRIPTS); do \
		install completion.d/$$script $(BASH_COMPLETION_DIR); done

uninstall:
	for script in $(MEDIA_SCRIPTS); do \
		rm /usr/local/bin/$$script; done
	for script in $(COMPLETION_SCRIPTS); do \
		rm $(BASH_COMPLETION_DIR)/$$script; done
