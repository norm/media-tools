BASH_COMPLETION_DIR := '/usr/local/etc/bash_completion.d'
MEDIA_SCRIPTS = media \
	media-add-cd \
	media-add-video \
	media-convert-video \
	media-convert-wav \
	media-create-audio-metadata \
	media-create-video-metadata \
	media-extract-audio-metadata \
	media-extract-video-metadata \
	media-get-cd-id \
	media-get-episode-title \
	media-get-youtube-video \
	media-install-video \
	media-itunes-add \
	media-make-episode-dir \
	media-rip-cd \
	media-set-artwork \
	media-tag-audio \
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
