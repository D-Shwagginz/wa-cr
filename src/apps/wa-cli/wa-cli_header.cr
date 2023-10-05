module Apps
  module WaCli
    macro load_header
      header = C::Widget::Layout.new \
        parent: @@screen,
        name: "header", # Symbolic name
        top: 0,         # Can also be of format 10, "50%", or "50%+-10"
        left: 0,        # Can also be of format 10, "50%", or "50%+-10"
        width: "100%",  # Can also be of format 10, "50%", or "50%+-10"
        height: 1,      # Can also be of format 10, "50%", or "50%+-10"
        style: C::Style.new(bg: "#9c9c9c")

      header1 = C::Widget::Label.new \
        parent: header,
        name: "header1", # Symbolic name
        width: 28,       # Can also be of format 10, "50%", or "50%+-10"
        height: 1,       # Can also be of format 10, "50%", or "50%+-10"
        content: "wa-cli Version: #{WaCli::VERSION}",
        style: C::Style.new(fg: "blue", bg: "#9c9c9c")
    end
  end
end
