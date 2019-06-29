class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20190303.tgz"
  version "5.0.20190303"
  sha256 "adad7870988d44b95df57722ab8dffc587d035183eb6b12a9500ebed4d8dba25"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2b0c3b57e88f355f9f12c165c90af3afafc7eec8586728009313767957d721c5" => :mojave
    sha256 "02c972ee5b04fbc04c66ade99acb774edabb7d31d0e1fd29f145d713d72fb7d7" => :high_sierra
    sha256 "b1caba9e7e1fdaae58e0a36fa51d9bbaecf75c8c1e7a5d1ed4fb94bcd20339a6" => :sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
