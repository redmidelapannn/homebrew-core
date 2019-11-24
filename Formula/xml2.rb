class Xml2 < Formula
  desc "Makes XML and HTML more amenable to classic UNIX text tools"
  homepage "https://web.archive.org/web/20160730094113/www.ofb.net/~egnor/xml2/"
  url "https://web.archive.org/web/20160427221603/download.ofb.net/gale/xml2-0.5.tar.gz"
  sha256 "e3203a5d3e5d4c634374e229acdbbe03fea41e8ccdef6a594a3ea50a50d29705"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4230f4ce33bb50ea5abdea5e200591ca8ebe3fb44b42ad5294e62fd3c6e515f9" => :catalina
    sha256 "12def949c8b4ca0da3fbcb0a5bc46d3c71274a62117a2574a6a3d779c7916746" => :mojave
    sha256 "c9abda63419cce0ffcf7cefffa47c3f5a3ee7279ef00dde19eaa2ef1577afd25" => :high_sierra
  end

  depends_on "pkg-config" => :build
  uses_from_macos "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "/test", pipe_output("#{bin}/xml2", "<test/>", 0).chomp
  end
end
