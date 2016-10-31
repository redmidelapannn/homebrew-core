class Dvtm < Formula
  desc "Dynamic Virtual Terminal Manager"
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.15.tar.gz"
  sha256 "8f2015c05e2ad82f12ae4cf12b363d34f527a4bbc8c369667f239e4542e1e510"
  head "https://github.com/martanne/dvtm.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "325ffb7e7b72bb81287931e0b1d704f46480c498faf619f07b86183521ac4468" => :sierra
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "LIBS=-lc -lutil -lncurses -L#{HOMEBREW_PREFIX}/opt/ncurses/lib", "install"
  end

  test do
    result = shell_output("#{bin}/dvtm -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match(/^dvtm-#{version}/, result)
  end
end
