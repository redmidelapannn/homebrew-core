class Jpeg < Formula
  desc "Image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v9b.tar.gz"
  sha256 "240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052"

  bottle do
    cellar :any
    sha256 "db4a192710ffa041956744ac446006842464cccb1bda2f3c1f99e6d5985c91e8" => :sierra
    sha256 "99fbe9664c4471ef6298e6997f22cfc827673a5a7a3ccea4918ba0131f158754" => :el_capitan
    sha256 "6c6896daee4640b1e14bdb40e9ee216366cf0ea73e61f7a4e57573f7a52c0cca" => :yosemite
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
