SRCS = main.swift Protocol.swift Theme.swift Fuzzy.swift Scan.swift \
       RowView.swift App.swift Client.swift Server.swift
OUT = Menu
SWIFTC = swiftc

ifndef NIX_BUILD_TOP
	export DEVELOPER_DIR=/Library/Developer/CommandLineTools
	export SDKROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
	SWIFTC = /usr/bin/swiftc
endif

$(OUT): clean
	$(SWIFTC) -O -framework Cocoa \
		-o $(OUT) $(SRCS)

clean:
	rm -rf $(OUT)
