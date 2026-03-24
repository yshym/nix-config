SRCS = main.swift Protocol.swift Theme.swift Fuzzy.swift Scan.swift \
       RowView.swift App.swift Client.swift Server.swift
OUT = Menu
SWIFTC = swiftc

$(OUT): clean
	$(SWIFTC) -O -framework Cocoa \
		-o $(OUT) $(SRCS)

clean:
	rm -rf $(OUT)
