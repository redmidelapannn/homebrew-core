class Xml2 < Formula
  desc "Makes XML and HTML more amenable to classic UNIX text tools"
  homepage "https://web.archive.org/web/20160730094113/www.ofb.net/~egnor/xml2/"
  url "https://web.archive.org/web/20160427221603/download.ofb.net/gale/xml2-0.5.tar.gz"
  sha256 "e3203a5d3e5d4c634374e229acdbbe03fea41e8ccdef6a594a3ea50a50d29705"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "e49f2ebd8eac30049a0a9ac1e2b1da6a29120a4ed0c8aa25817594d2852b9ca5" => :sierra
    sha256 "bb88fda3d48d0895cb4f844a6088ac47650b4e19045b519d94bc427a279255f4" => :el_capitan
    sha256 "c26879b3311d6d7cee5a2dd639688e8d4e6d29c543e9292fc5e0ce81664f36b5" => :yosemite
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "/test", pipe_output("#{bin}/xml2", "<test/>", 0).chomp
  end
end
