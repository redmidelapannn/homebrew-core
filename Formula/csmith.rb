class Csmith < Formula
  desc "Generates random C programs conforming to the C99 standard"
  homepage "https://embed.cs.utah.edu/csmith/"
  url "https://embed.cs.utah.edu/csmith/csmith-2.2.0.tar.gz"
  sha256 "62fd96d3a5228241d4f3159511ad3ff5b8c4cedb9e9a82adc935830b421c8e37"
  head "https://github.com/csmith-project/csmith.git"

  bottle do
    cellar :any
    revision 1
    sha256 "619b377fdaa13e274ae25fdb41b63c4d7816e6cd1e39d34d95ed44c20103b459" => :el_capitan
    sha256 "0c918977416ef0c5774f219ac25bb854abbf9f348d3bae34cd76c9a3bb7061f2" => :yosemite
    sha256 "80f7f3f6170642d1ca4353c59203d8c5b4ae06cf32375a864f2fbdacdc685db5" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    mv "#{bin}/compiler_test.in", share
    (include/"csmith-#{version}/runtime").install Dir["runtime/*.h"]
  end

  def caveats; <<-EOS.undent
    It is recommended that you set the environment variable 'CSMITH_PATH' to
      #{include}/csmith-#{version}
    EOS
  end

  test do
    system "#{bin}/csmith", "-o", "test.c"
  end
end
