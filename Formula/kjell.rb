class Kjell < Formula
  desc "Erlang shell"
  homepage "https://karlll.github.io/kjell/"
  # clone repository in order to get extensions submodule
  url "https://github.com/karlll/kjell.git",
      :tag => "0.2.6",
      :revision => "0848ad2d2ddefc74774f0d793f4aebd260efb052"

  head "https://github.com/karlll/kjell.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "0bd639f2cf9daeaa2783d8f42b2c8f34fa8ba8e6edea7af9a85bff3c0ce70ed8" => :el_capitan
    sha256 "7ed207de5bee738e328e4f82957b4e2c016068e834bbb1c4518699ce983836e5" => :yosemite
    sha256 "11220fa59aee667205f4dc90b63662e42114d59dbddbed50ff018f72e45da9b0" => :mavericks
  end

  depends_on "erlang"

  def install
    # mkdir: $HOME/.kjell: Operation not permitted
    # Prevent sandbox violation
    # Reported 5th May 2016: https://github.com/karlll/kjell/issues/33
    inreplace "Makefile", "CFG_DIR=~${USER}/.kjell", "CFG_DIR=#{pkgshare}"

    system "make"
    system "make", "configure", "PREFIX=#{prefix}"
    system "make", "install", "NO_SYMLINK=1"
    system "make", "install-extensions"
  end

  def caveats; <<-EOS.undent
    Extension 'kjell-prompt' requires a powerline patched font.
    See https://github.com/Lokaltog/powerline-fonts
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    system "script", "-q", "/dev/null", bin/"kjell", "-sanity_check", "true"
  end
end
