class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.12.1/dictd-1.12.1.tar.gz"
  sha256 "a237f6ecdc854ab10de5145ed42eaa2d9b6d51ffdc495f7daee59b05cc363656"

  bottle do
    rebuild 1
    sha256 "a605b74e8e123bd6f799d7b2d534d030371610ae627a7a5699a87df0dd9b7bc3" => :sierra
    sha256 "8e96e6137e2a3a53633c0d2d3cffba38275d8d1a2a688891d36e74129d1e2b61" => :el_capitan
    sha256 "1b13f78af04b265b8d9ad54347d536ec924ba02d4c6d8750d7e9d02953842ed7" => :yosemite
  end

  depends_on "libtool" => :build
  depends_on "libmaa"

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    (prefix+"etc/dict.conf").write <<-EOS.undent
      server localhost
      server dict.org
    EOS
  end
end
