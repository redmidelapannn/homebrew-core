class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "http://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.5.1.tar.gz"
  sha256 "723dce178594a6a9a64de6ba7929f04d5fd08d0c9ed57650b22993afdb1ebdf3"
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6f7d440fb9ff42393ad76adfd75bbabe704bd0f2a56f0a58f1e936a66a4ce1ad" => :mojave
    sha256 "41cc03bb30d2932ba2d69be4bf853b64987fe843ef53cf696b08d8d7f5b44f7a" => :high_sierra
    sha256 "fa88680cb59e287a056c8ad6329a0daea207b0dcc8fcf342dea0bec498eef084" => :sierra
    sha256 "bab5e000218580a5305cfb16eeb0383b7b2a8409a6548b38dcefafba1b4fbd94" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "luajit"

  def install
    cd "embed" do
      # Ensure file placement is compatible with HOMEBREW_SANDBOX.
      inreplace "Makefile" do |s|
        s.gsub! "install -d $(DESTDIR)$(INSTALL_CMOD)",
                "install -d $(PREFIX)/lib/lua/5.1"
        s.gsub! "$(DESTDIR)$(INSTALL_CMOD)/radio.so",
                "$(PREFIX)/lib/lua/5.1/radio.so"
      end
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    (testpath/"hello").write("Hello, world!")
    (testpath/"test.lua").write <<~EOS
      local radio = require('radio')

      local PrintBytes = radio.block.factory("PrintBytes")

      function PrintBytes:instantiate()
          self:add_type_signature({radio.block.Input("in", radio.types.Byte)}, {})
      end

      function PrintBytes:process(c)
          for i = 0, c.length - 1 do
              io.write(string.char(c.data[i].value))
          end
      end

      local source = radio.RawFileSource("hello", radio.types.Byte, 1e6)
      local sink = PrintBytes()
      local top = radio.CompositeBlock()

      top:connect(source, sink)
      top:run()
    EOS

    assert_equal "Hello, world!", shell_output("#{bin}/luaradio test.lua")
  end
end
