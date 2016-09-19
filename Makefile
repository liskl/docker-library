
builders: 
	test -f versions/liskl_base/rootfs.tar.gz || \
		/usr/local/bin/docker build -t 'builder' ./builder/. \
		/usr/local/bin/docker run --rm 'alpine-builder' -d -s -E -c -t UTC -r 'v3.4' -m 'http://nl.alpinelinux.org/alpine' > './versions/liskl_base/rootfs.tar.gz'

base: builders
	docker build -t 'liskl/base' ./versions/liskl_base/
	docker rmi 'alpine-builder' || true

flask: base
	docker build -t 'liskl/flask' ./versions/liskl_flask/

mosca: base

	docker rmi 'liskl/mosca' || true
	docker build -t 'liskl/mosca' ./versions/liskl_mosca/

clean:
	/bin/bash -c 'docker stop $( docker ps -a -q )' 2>/dev/null || true
	/bin/bash -c 'docker rm $( docker ps -a -q )' 2>/dev/null || true
	/bin/bash -c 'docker rmi $( docker images --quiet --filter=dangling=true )' 2>/dev/null || true
	rm ./versions/liskl_base/rootfs.tar.gz


#
#all: clean builder base flask
#
#
#