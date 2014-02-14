MONLYBIN = "bin"
MONLYLIB = "lib"

MAINDIR = "/usr/local/bin/monly/"

MAINFILE = "bin/monly-client.pl"

all:
	echo Hi mom!

install:
	mkdir $(MAINDIR)

	cp -rf $(MONLYBIN) $(MAINDIR)
	cp -rf $(MONLYLIB) $(MAINDIR)

	chmod +x $(MAINDIR) $(MAINFILE)

clean:
	rm -rf $(MAINDIR)