module Apps
  module WaCli
    @@screen = C::Screen.new

    background = C::Widget::Box.new \
      parent: @@screen,
      name: "background",
      width: "100%",
      height: "100%",
      style: C::Style.new(bg: "#616161")

    load_header

    @@screen.on(C::Event::KeyPress) do |e|
      if e.key == Tput::Key::Escape || e.key == Tput::Key::CtrlC
        @@screen.destroy
        exit
      end
    end

    def self.run(file_location : String)
      @@screen.exec
    end
  end
end
