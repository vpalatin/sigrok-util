
TARGETS:=debian-buster ubuntu-xenial ubuntu-trusty debian-stretch mingw

BUILDS:=$(foreach t, $(TARGETS), build-sigrok-$(t))
CIDS:=$(foreach t, $(TARGETS), .docker.cid.$(t))
CPS:=$(foreach t, $(TARGETS), cp-$(t))
CLEANS:=$(foreach t, $(TARGETS), clean-$(t))

TWINKIE:=$(shell lsusb -d 18d1:500a | sed -e "s@Bus \([0-9]\+\) Device \([0-9]\+\):.\+@/dev/bus/usb/\1/\2@")
DEVICE:=$(TWINKIE:%=--device=%:$(TWINKIE))

OUTDIR:=twinkie-$(shell date "+%Y%m%d")
_MK_OUT:=$(shell mkdir -p $(OUTDIR))

.PHONY: $(BUILDS) $(CPS) $(CLEANS)

.PHONY: all
all: $(CPS)

.PHONY: build
build: $(BUILDS)

$(BUILDS): build-sigrok-%: Dockerfile.%
	docker build -f $< -t=$@ .

.docker.cid.%: build-sigrok-%
	docker run $(DEVICE) --cidfile $@ --detach=true $<

shell-%: .docker.cid.%
	docker exec -it "$(shell cat $<)" /bin/bash

$(CPS): cp-%: .docker.cid.%
	docker cp "$(shell cat $<)":/wip/packages/* $(OUTDIR)/$*/

.PHONY: push
push: $(CPS)
	gsutil cp -r -a public-read $(OUTDIR) gs://chromeos-vpa/

clean-%:
	docker rm -f "$(shell cat .docker.cid.$*)"

.PHONY: clean
clean: $(CLEANS)

#docker ps -a
#docker images

#./sigrok-twinkie-0.5.0/bin/sigrok-cli -d chromium-twinkie --show
# sigrok-cli -d chromium-twinkie --continuous -P usb_power_delivery:cc=CC1:fulltext=yes -P usb_power_delivery:cc=CC2:fulltext=yes -A usb_power_delivery=text
