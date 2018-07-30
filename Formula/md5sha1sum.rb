class Md5sha1sum < Formula
  desc "Hash utilities"
  homepage "http://microbrew.org/tools/md5sha1sum/"
  url "http://microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  sha256 "2fe6b4846cb3e343ed4e361d1fd98fdca6e6bf88e0bba5b767b0fdc5b299f37b"

  bottle do
    cellar :any
    rebuild 3
    sha256 "a1a46d255d3a8e8deb104e682886a2ce346734702fa6e615012b4a50deed05e4" => :high_sierra
    sha256 "4584c367bc23021e0826a59834a669cad6b1acdba46c3cfe77f4f0406374b820" => :sierra
    sha256 "6dcdfc8cd1107a187813d8879da0d8c558fd677b1e6b4c642b52d1d338d7e6d3" => :el_capitan
  end

  depends_on "openssl"

  def install
    openssl = Formula["openssl"]
    ENV["SSLINCPATH"] = openssl.opt_include
    ENV["SSLLIBPATH"] = openssl.opt_lib

    system "./configure", "--prefix=#{prefix}"
    system "make"

    bin.install "md5sum"
    bin.install_symlink bin/"md5sum" => "sha1sum"
    bin.install_symlink bin/"md5sum" => "ripemd160sum"
  end

  test do
    (testpath/"file.txt").write("This is a test file with a known checksum")
    (testpath/"file.txt.sha1").write <<~EOS
      52623d47c33ad3fac30c4ca4775ca760b893b963  file.txt
    EOS
    system "#{bin}/sha1sum", "--check", "file.txt.sha1"
  end
end
