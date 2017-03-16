class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "http://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.5.5.tar.gz"
  sha256 "297a57808c12b81b8e0d82222cf57245ad988804ab467eb0a70cf8669594e8ed"
  revision 1

  bottle do
    rebuild 2
    sha256 "2cebb0c89fc83f73ccaf730ab12cfd17b2f31d73ec683c5825d4cdc143d835e9" => :sierra
    sha256 "b34a0408d4e9c8506554a567f969c907093506e1f0b82819e74adedba5c1ea05" => :el_capitan
    sha256 "7e8c810dbaba0acbda4c21e4b971c40672e90dc0b06041f1dffae4298dab8e52" => :yosemite
  end

  depends_on "afflib" => :optional
  depends_on "boost"
  depends_on "exiv2" => :optional
  depends_on "libewf" => :optional
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    # Install documentation
    (pkgshare/"doc").install Dir["doc/*.{html,txt,pdf}"]

    (lib/"python2.7/site-packages").install Dir["python/*.py"]

    # Install the GUI the Homebrew way
    # .jar gets installed into bin by default
    libexec.install bin/"BEViewer.jar"
    (bin/"BEViewer").unlink
    bin.write_jar_script libexec/"BEViewer.jar", "BEViewer", "-Xmx1g"
  end

  test do
    input_file = testpath/"data.txt"
    input_file.write "https://brew.sh\n(201)555-1212\n"

    output_dir = testpath/"output"
    system "#{bin}/bulk_extractor", "-o", output_dir, input_file

    assert_match "https://brew.sh", (output_dir/"url.txt").read
    assert_match "(201)555-1212", (output_dir/"telephone.txt").read
  end
end
