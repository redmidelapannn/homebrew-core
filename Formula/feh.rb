class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.27.1.tar.bz2"
  sha256 "6ec338f80c3f4c30d715f44780f1a09ebfbb99e92a1bb43316428744a839f383"

  bottle do
    rebuild 1
    sha256 "44b6899240240cb3fb66ea28158cddf19017bb2ca4bc4aeba91d0c3351f4dd7a" => :mojave
    sha256 "028e4334b9bf6372084515e860533a10380738133d7ef9e6df4aceefbf373be8" => :high_sierra
    sha256 "6d9fc8f077b2e9cc055d39793ddedf0a4795a7973bc36978d0b9afa1f4ba8dbb" => :sierra
    sha256 "a0e88e7cc1ae47e4cbd20eb29d084dd4eb2a3050101d81d6c5feb12545d96e2c" => :el_capitan
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
