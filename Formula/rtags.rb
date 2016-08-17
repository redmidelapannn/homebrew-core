class Rtags < Formula
  desc "ctags-like source code cross-referencer with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags.git",
      :tag => "v2.3",
      :revision => "da75268b1caa973402ab17e501718da7fc748b34"

  head "https://github.com/Andersbakken/rtags.git"

  bottle do
    revision 1
    sha256 "c0a8f6b15a4fea43412da154c3ae421a36ae4cf43b172cec48b8537f70c0d31f" => :el_capitan
    sha256 "198ef0d868aef9c68104ecc49617aa6819819d4534e40a41ae34153503b8cb35" => :yosemite
    sha256 "ada5a6c096bfbae13f8c7f714695cce97d0971b8e1dab963e43b0a0efb7c930e" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "openssl"

  def install
    # Homebrew llvm libc++.dylib doesn't correctly reexport libc++abi
    ENV.append("LDFLAGS", "-lc++abi")

    mkdir "build" do
      system "cmake", "..", "-DRTAGS_NO_BUILD_CLANG=ON", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    mkpath testpath/"src"
    (testpath/"src/foo.c").write <<-EOS.undent
        void zaphod() {
        }

        void beeblebrox() {
          zaphod();
        }
    EOS
    (testpath/"src/README").write <<-EOS.undent
        42
    EOS

    rdm = fork do
      $stdout.reopen("/dev/null")
      $stderr.reopen("/dev/null")
      exec "#{bin}/rdm", "-L", "log"
    end

    begin
      sleep 1
      pipe_output("#{bin}/rc -c", "clang -c src/foo.c", 0)
      sleep 1
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f src/foo.c:5:3")
      system "#{bin}/rc", "-q"
    ensure
      Process.kill 9, rdm
      Process.wait rdm
    end
  end
end
