class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/Devel/pianod2-298.tar.gz"
  sha256 "0de916d8df19c045a98fd9b63ec25f157d30235c412689c00c3cead99c64ba76"

  bottle do
    rebuild 1
    sha256 "b0f8dc74b232ed61f3f700e7991edbd7c1ea23e9fdf01b09aebb5f1bb50d83c4" => :catalina
    sha256 "7e3ebeded1fe0fefd6bdbb63946e2809ebefe82f145740bd6843c7f6fcb20478" => :mojave
    sha256 "d2528d2914b50fddd2eb97af285ecd02e170e44763382c8867854705854b3273" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  def install
    ENV["OBJCXXFLAGS"] = "-std=c++11"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
