class Dvtm < Formula
  desc "Dynamic Virtual Terminal Manager"
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.15.tar.gz"
  sha256 "8f2015c05e2ad82f12ae4cf12b363d34f527a4bbc8c369667f239e4542e1e510"
  head "https://github.com/martanne/dvtm.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e5c4a5dc06fb1064e0dda833c821a6b36057fea074c52f74dd510ab3cd56579a" => :sierra
    sha256 "109f9c4db0626fe37dd155517545e329f8933b9a604bd657957d15bcd30c5fc0" => :el_capitan
    sha256 "0e4b7b99536a70c847e6998b93b761c122b2ff7001e1151d0cb7b614ddecfb5a" => :yosemite
  end

  depends_on "homebrew/dupes/ncurses"

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
