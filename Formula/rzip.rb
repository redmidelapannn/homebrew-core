class Rzip < Formula
  desc "File compression tool (like gzip or bzip2)"
  homepage "https://rzip.samba.org/"
  url "https://rzip.samba.org/ftp/rzip/rzip-2.1.tar.gz"
  sha256 "4bb96f4d58ccf16749ed3f836957ce97dbcff3e3ee5fd50266229a48f89815b7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "517d4d77189d73f7690b4aad74c17921701c5848de565a62127a5af529407170" => :high_sierra
    sha256 "c0ef51d1729c386d271c57d1bbff5195643e8e4afda9a879b707ccbb07df755e" => :sierra
    sha256 "3481db37cc519740c18346a06dd93d88846e6967026acce1a8f190630e1c8a79" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install", "INSTALL_MAN=#{man}"

    bin.install_symlink "rzip" => "runzip"
    man1.install_symlink "rzip.1" => "runzip.1"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.rz
    system bin/"rzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.rz -> data.txt
    system bin/"rzip", "-d", "#{path}.rz"
    assert_equal original_contents, path.read
  end
end
