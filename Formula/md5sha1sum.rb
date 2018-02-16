class Md5sha1sum < Formula
  desc "Hash utilities"
  homepage "http://www.microbrew.org/tools/md5sha1sum/"
  url "http://www.microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  sha256 "2fe6b4846cb3e343ed4e361d1fd98fdca6e6bf88e0bba5b767b0fdc5b299f37b"

  bottle do
    cellar :any
    rebuild 3
    sha256 "108454471a530a9600a93f26f6e28386fae3d29dc945163cdd2a18e19bf039bf" => :high_sierra
    sha256 "26ea15db5d15657e1029495cdf9881426904d84c985e9db1cff9e803fcf45a56" => :sierra
    sha256 "bbfd834346d3af82db34e26c2a85242eeba8c38394734a9aeccd7648dbcbb963" => :el_capitan
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
