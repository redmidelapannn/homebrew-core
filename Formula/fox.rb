class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily"
  homepage "http://www.fox-toolkit.org/"
  url "http://fox-toolkit.org/ftp/fox-1.6.57.tar.gz"
  sha256 "65ef15de9e0f3a396dc36d9ea29c158b78fad47f7184780357b929c94d458923"

  bottle do
    cellar :any
    sha256 "228b37c0d8102548763df637d5b36e9d1169fb4a8a730d27be1de588a9e5a000" => :high_sierra
    sha256 "93c6bf6e899a824e72aa40f5fa41189f810ed838833e6640622e4f3a4e6a05dc" => :sierra
    sha256 "d39b83248632d89702c1520fcbf94370054d48b35d8570f85cafa00df91b6dd9" => :el_capitan
  end

  depends_on :x11
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-release",
                          "--prefix=#{prefix}",
                          "--with-x",
                          "--with-opengl"
    # Fix undefined symbols error for MPCreateSemaphore, MPDeleteSemaphore, etc.
    system "make", "install", "LDFLAGS=-framework CoreServices"
    rm bin/"Adie.stx"
  end

  test do
    system bin/"reswrap", "-t", "-o", "text.txt", test_fixtures("test.jpg")
    assert_match "\\x00\\x85\\x80\\x0f\\xae\\x03\\xff\\xd9", File.read("text.txt")
  end
end
