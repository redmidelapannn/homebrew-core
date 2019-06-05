class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.12.2.tar.gz"
  sha256 "0b583ca546e4ae1896e6390c1a0ef53e7673b6ca6a5597502e9d1ba35f02c2ea"
  revision 1

  bottle do
    sha256 "1ac7f69557f1a8f19feefdde48cb8d66d1bb9d09b87ea6881624a525f6f3957c" => :mojave
    sha256 "23864fedcf3abd7237f055144cb9bd5be47d821d8398317b79eaf88ea451163c" => :high_sierra
    sha256 "6c03fb185912410b372d6e5e18d5c33b423cfd97cdb84d56167271bbd2812af3" => :sierra
  end

  depends_on "lmdb"
  depends_on "openssl"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.12.2.tar.gz"
    sha256 "1183c892e050c39645b7d79171fca8e829fba63628d29c3b776fc7840599573b"
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
