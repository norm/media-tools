BASH_COMPLETION_DIR := '/usr/local/etc/bash_completion.d'

install:
	install bin/media* /usr/local/bin
	install completion.d/* ${BASH_COMPLETION_DIR}
