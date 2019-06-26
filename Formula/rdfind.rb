class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.4.1.tar.gz"
  sha256 "30c613ec26eba48b188d2520cfbe64244f3b1a541e60909ce9ed2efb381f5e8c"
  revision 1

  bottle do
    cellar :any
    sha256 "8b047add9ebf1c257a7c28f89a43ba6c89fd086c85a5fa87fe91685e66e19efa" => :mojave
    sha256 "2d90201f6eaf0d6c630b7a842819a8ad5d2b409a809029d43c76d40d3a7fa7e1" => :high_sierra
    sha256 "efb66262980ee7852738ecfceb9376add037da2e3ee924752f4e3af81471ffb7" => :sierra
  end

  depends_on "nettle"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "folder"
    (testpath/"folder/file1").write("foo")
    (testpath/"folder/file2").write("bar")
    (testpath/"folder/file3").write("foo")
    system "#{bin}/rdfind", "-deleteduplicates", "true", "folder"
    assert_predicate testpath/"folder/file1", :exist?
    assert_predicate testpath/"folder/file2", :exist?
    refute_predicate testpath/"folder/file3", :exist?
  end
end
