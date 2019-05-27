class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.5.tar.gz"
  sha256 "308b032124965dc2405fe1873a5142f82b5901daabbf315a0a851d3cb74919bf"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "28c830bc630674ff829789a59a84f178571ba43d9302cf9cd131b33a3d3d9533" => :mojave
    sha256 "2f7e7a5233fb2a3e1a4b945e30ab8382bfe4536a50f4caeb76fd0fe47a821cd2" => :high_sierra
    sha256 "fc6adb5b246feeb915011210344a567346312e80c99c03fe4f4c03f8910dc87b" => :sierra
  end

  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "scripts/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "scripts/auto-completion/zsh/_nnn"
    fish_completion.install "scripts/auto-completion/fish/nnn.fish"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"

    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
