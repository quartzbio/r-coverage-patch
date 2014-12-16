RVERSION=3.1.2
RDIR=R-$(RVERSION)
RCOV=$(RDIR)cov

PATCH=r312_coverage.patch

.PHONY: patch.txt


$(RDIR).tar.gz:
	wget http://cran.r-project.org/src/base/R-3/$(RDIR).tar.gz 

$(RDIR): $(RDIR).tar.gz
	tar zxf $(RDIR).tar.gz

apply_production_patch: $(RDIR)
	rm -rf $(RCOV)
	patch -p0 < $(PATCH)
	mv $(RDIR) $(RCOV)

distclean:
	-cd $(RCOV) && make distclean

patch.txt: distclean $(RDIR)
	rm -f patch.txt
	diff -urN -x NEWS $(RDIR) $(RCOV) > patch.txt || true

PREFIX=$(PWD)/local


install: 
	cd $(RCOV) && \
	./configure  --prefix $(PREFIX) --enable-R-shlib --enable-memory-profiling --with-readline && \
	make -j 4 && \
	make install

clean:
	rm -rf $(RCOV) $(RDIR) local
