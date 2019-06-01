class Corectl < Formula
  desc "CoreOS over macOS made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.7.18.tar.gz"
  sha256 "9bdf7bc8c6a7bd861e2b723c0566d0a093ed5d5caf370a065a1708132b4ab98a"
  revision 2
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any
    sha256 "469548281d4d4471dcc703f7293abefa1f85a584f91f05c9398de9add6ff1e87" => :mojave
    sha256 "10c9555c55b71fdab0d3b34fed23785f33ec8a30436083eedc99bfa0fb7724ee" => :high_sierra
    sha256 "68e80b5e018f8c43516e01b53f26e46d2eb4b99adf4b8d9fd2be4bfa9a08231c" => :sierra
  end

  depends_on "aspcud" => :build
  depends_on "go" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on :x11 => :build
  depends_on "libev"
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/TheNewNormal/#{name}"
    path.install Dir["*"]

    opamroot = path/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    args = []
    args << "VERSION=#{version}" if build.stable?

    cd path do
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "switch", "create", "ocaml-base-compiler.4.05.0"
      system "opam", "config", "exec", "--", "opam", "install", "uri.2.2.0",
             "ocamlfind.1.8.0", "qcow-format.0.5.0", "conf-libev.4-11", "io-page.1.6.1",
             "mirage-block-unix.2.4.0", "lwt.3.0.0"
      (opamroot/"system/bin").install_symlink opamroot/"ocaml-base-compiler.4.05.0/bin/qcow-tool"
      system "opam", "config", "exec", "--", "make", "tarball", *args

      bin.install Dir["bin/*"]

      prefix.install_metafiles
      man1.install Dir["documentation/man/*.1"]
      pkgshare.install "examples"
    end
  end

  def caveats; <<~EOS
    Starting with 0.7 "corectl" has a client/server architecture. So before you
    can use the "corectl" cli, you have to start the server daemon:

    $ corectld start

  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/corectl version")
  end
end
