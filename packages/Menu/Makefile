SRCS = main.m client.m server.m app.m fuzzy.m scan.m rowview.m
OUT = Menu

$(OUT): clean
	clang -framework Cocoa -O2 -fobjc-arc \
		-o $(OUT) $(SRCS)

clean:
	rm -rf $(OUT)
