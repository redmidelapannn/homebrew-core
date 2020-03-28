class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.15.1.tar.gz"
  sha256 "ab597456f9d44d907bb5a2e82b8ce2af01e9c59641dc828457cd768ef05a831d"

  bottle do
    sha256 "b6f25749391414d3b5588fba1c611e37446cfc3032ded562cf8736f28c260dd9" => :mojave
    sha256 "ceddc692d668b2e7ee4ee90747734c9c84ff583eb31c1d9339f29b8c40974f2a" => :high_sierra
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.15.1.tar.gz"
    sha256 "051369054a2e17a4ea1f68a41198fe5377fbbf33f600168246bf0b667fc1ab74"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-workdir=#{var}/cfengine",
                          "--with-lmdb=#{Formula["lmdb"].opt_prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}",
                          "--without-mysql",
                          "--without-postgresql"
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
