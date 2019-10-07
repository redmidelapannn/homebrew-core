class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.4.1.tar.gz"
  sha256 "30c613ec26eba48b188d2520cfbe64244f3b1a541e60909ce9ed2efb381f5e8c"
  revision 1

  bottle do
    cellar :any
    sha256 "2cfd0af1eca719ebabf9d9c8cfd679db0b09cfd5a9de396ed1f65080bd61c3f4" => :catalina
    sha256 "6a67d9d19e8b9abb86943856333e593f3c3ef354f731b4618f8dc1f25b2d5369" => :mojave
    sha256 "6b0669d721933ff56c9ae5ea0c7b8bc98e05b4ead0f6ffa34e362c7a44f98b01" => :high_sierra
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
