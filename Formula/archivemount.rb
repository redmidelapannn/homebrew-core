class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://www.cybernoia.de/software/archivemount.html"
  url "https://www.cybernoia.de/software/archivemount/archivemount-0.8.12.tar.gz"
  sha256 "247e475539b84e6d2a13083fd6df149995560ff1ea92fe9fdbfc87569943cb89"

  bottle do
    cellar :any
    rebuild 1
    sha256 "acdea89137176a12fbf50adb11a7d61dc6874231bd576d96633df688e748a360" => :high_sierra
    sha256 "34b119ef9c6baa5b222af47bf909eaccebf557e9919a7d3e780f5a3be5306e7a" => :sierra
    sha256 "d22d9a6dcc4e10c1c80a2c87256f7739cd2122e6f08a40e9d38f6a2be3bcd998" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on :osxfuse

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
