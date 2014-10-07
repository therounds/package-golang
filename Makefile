SRPM_OUT=./out/srpm
RPM_OUT=./out/rpm
SRC=./src

SPEC_TOOL=/usr/bin/spectool
MOCK=/usr/bin/mock
MOCK_ENV=epel-7-x86_64
DIST=el7.centos

SPEC_FILE=./golang.spec
VERSION:=$(shell grep Version ${SPEC_FILE} | awk '{print $$2}')

# Jenkins sets this environment variable for us. If it isn't set, set to 0
ifndef BUILD_NUMBER
BUILD_NUMBER=0
endif

MOCK_DEFINE=--define '__tr_release_num ${BUILD_NUMBER}'

.PHONY: dirs clean build build-srpm build-rpm fetch-source mock-dep spectool-dep

build: build-rpm

dirs:
	mkdir -p ${SRPM_OUT} ${RPM_OUT}

clean:
	rm -rf ${SRPM_OUT} ${RPM_OUT} ${SRC}/*.gz

build-srpm: fetch-source mock-dep dirs
	${MOCK} -v -r ${MOCK_ENV} --buildsrpm --spec ${SPEC_FILE} --sources ${SRC} ${MOCK_DEFINE} --resultdir ${SRPM_OUT}

build-rpm:  build-srpm mock-dep
	${MOCK} -v -r ${MOCK_ENV} --rebuild ${SRPM_OUT}/golang-${VERSION}-${BUILD_NUMBER}.${DIST}.src.rpm ${MOCK_DEFINE} --resultdir ${RPM_OUT}

fetch-source: spectool-dep
	${SPEC_TOOL} -g -R -C ${SRC} ${SPEC_FILE}

mock-dep:
	test -x ${MOCK} || { echo "You do not have mock installed! Install with 'yum install -y mock'. Exiting..."; false; }

spectool-dep:
	test -x ${SPEC_TOOL} || { echo "You do not have spectool installed! Install with 'yum install -y rpmdevtools'. Exiting..."; false; }
