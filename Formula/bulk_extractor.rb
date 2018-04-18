class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.5.5.tar.gz"
  sha256 "297a57808c12b81b8e0d82222cf57245ad988804ab467eb0a70cf8669594e8ed"
  revision 2

  bottle do
    rebuild 1
    sha256 "cc2a498bf16d579dd40c272cfc802f715fab6a63915196dd1d210438cc5e05e1" => :high_sierra
    sha256 "64fbfa93ea6cf61ea2cf59ecf5e06c54f3c33f51837bef34cd75fb6339077754" => :sierra
    sha256 "693028aabc71f4c95006c435438191a62d30c2ffd014cc7e3bdc96daa6c59177" => :el_capitan
  end

  depends_on "boost"
  depends_on "openssl"
  depends_on "afflib" => :optional
  depends_on "exiv2" => :optional
  depends_on "libewf" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    # Install documentation
    (pkgshare/"doc").install Dir["doc/*.{html,txt,pdf}"]

    (lib/"python2.7/site-packages").install Dir["python/*.py"]
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
