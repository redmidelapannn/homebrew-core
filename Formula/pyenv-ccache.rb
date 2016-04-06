class PyenvCcache < Formula
  desc "Make Python build faster, using the leverage of `ccache`"
  homepage "https://github.com/yyuu/pyenv-ccache"
  url "https://github.com/yyuu/pyenv-ccache/archive/v0.0.2.tar.gz"
  sha256 "ebfb8a5ed754df485b3f391078c5dc913f0587791a5e3815e61078f0db180b9e"

  head "https://github.com/yyuu/pyenv-ccache.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "829dc27f70974f824509498ec590dcd852ecfc312dcfe3200aef970fd673212d" => :el_capitan
    sha256 "ab2f5c4ed5358317f67b4e02bb865762750dddfec3cb37633db49bfdf84dd4cc" => :yosemite
    sha256 "83ae7fa368aab7b264c935b4b65586ab8d92978635a63db32997bd4137f4da2c" => :mavericks
  end

  depends_on "pyenv"
  depends_on "ccache" => :recommended

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    assert_match(/ccache.bash/, shell_output("eval \"$(pyenv init -)\" && pyenv hooks install && ls"))
  end
end
