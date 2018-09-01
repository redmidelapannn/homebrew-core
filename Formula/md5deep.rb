class Md5deep < Formula
  desc "Recursively compute digests on files/directories"
  homepage "https://github.com/jessek/hashdeep"
  url "https://github.com/jessek/hashdeep/archive/release-4.4.tar.gz"
  sha256 "dbda8ab42a9c788d4566adcae980d022d8c3d52ee732f1cbfa126c551c8fcc46"
  head "https://github.com/jessek/hashdeep.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3f6697d767437776e73b50417bedf3ebccdb315ecf3a60de9ba78deb0cccfb76" => :mojave
    sha256 "5bfbe6b2b3400ea50cd053e8864242ab4832828e6a9e5a6fa64a408ff7354ddc" => :high_sierra
    sha256 "9407a31f948566270c46ff2012ce9fe0431c0fadbf2c76afd864713313aaec9e" => :sierra
    sha256 "9e0b7d45adc33537fc5a99c8aaa8c39a4a1a35db855ca40b80a4cead054d5e85" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Fix compilation error due to pointer comparison
  if MacOS.version >= :sierra
    patch do
      url "https://github.com/jessek/hashdeep/commit/8776134.patch?full_index=1"
      sha256 "3d4e3114aee5505d1336158b76652587fd6f76e1d3af784912277a1f93518c64"
    end
  end

  def install
    system "sh", "bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Do not reduce the spacing of the below text.
    assert_equal "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32  testfile.txt",
    shell_output("#{bin}/sha1deep -b testfile.txt").strip
  end
end
