class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "http://detox.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/detox/detox/1.2.0/detox-1.2.0.tar.bz2"
  sha256 "abfad90ee7d3e0fc53ce3b9da3253f9a800cdd92e3f8cc12a19394a7b1dcdbf8"

  bottle do
    revision 1
    sha256 "886f37ab52a92b8cbc82bd6c0be49efbf56c9186903f9d3b3652b0ddb0555329" => :el_capitan
    sha256 "0e1939ae85d72e1c941c1eb58bce8839b393c052221ef848373b518e3927cc59" => :yosemite
    sha256 "3d320db47affcec22e8e769a22f880b2ebb040a4d26ecb59daf3764a80124202" => :mavericks
  end

  def install
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    (prefix/"etc").mkpath
    pkgshare.mkpath
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"

    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
