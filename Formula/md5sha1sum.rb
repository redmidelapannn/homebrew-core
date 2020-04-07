class Md5sha1sum < Formula
  desc "Hash utilities"
  homepage "http://microbrew.org/tools/md5sha1sum/"
  url "http://microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  sha256 "2fe6b4846cb3e343ed4e361d1fd98fdca6e6bf88e0bba5b767b0fdc5b299f37b"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "81e48e5f783807283915604c6a3691995d028819f26a373c4cea6cf14a98516d" => :catalina
    sha256 "fe50454ea370e0838756598513df1981df23f0381521b2b891d511602e975e64" => :mojave
    sha256 "45df2d3d090809f6b8a02a43408c4c58c24487475cf9c0766aad37b6f4a31b40" => :high_sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "coreutils", :because => "both install `md5sum` and `sha1sum` binaries"

  def install
    openssl = Formula["openssl@1.1"]
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
