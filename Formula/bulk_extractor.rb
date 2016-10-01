class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "http://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.5.5.tar.gz"
  sha256 "297a57808c12b81b8e0d82222cf57245ad988804ab467eb0a70cf8669594e8ed"
  revision 2

  bottle do
    cellar :any
    sha256 "fd44b6fb4000513f0eb3c76afa753c0439a832147000b0b5994bf642c18fe91c" => :sierra
    sha256 "0949386652cea9830d78873ad48241e4c5bcde847eef5dc88edb92cfa69fcf38" => :el_capitan
    sha256 "587394c332eb27c7409ace07d6c3b2df7eaeaf1b105fe2a36950727af642aa5f" => :yosemite
  end

  depends_on "afflib" => :optional
  depends_on "boost@1.61"
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
    input_file.write "http://brew.sh\n(201)555-1212\n"

    output_dir = testpath/"output"
    system "#{bin}/bulk_extractor", "-o", output_dir, input_file

    assert_match "http://brew.sh", (output_dir/"url.txt").read
    assert_match "(201)555-1212", (output_dir/"telephone.txt").read
  end
end
