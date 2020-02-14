class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.8.0/sleuthkit-4.8.0.tar.gz"
  sha256 "f584b46c882693bcbd819fb58f75e9be45ac8abdbf605c190f87ef1122f28f6c"

  bottle do
    cellar :any
    sha256 "58dc42cdef07e6861752700bfb53ecf709cefd6db89d5fc32fa9c2aa53a1ba83" => :catalina
    sha256 "be7d1acb094aa4ba0d320a4fed8bade2d7cb96f11755b6df7c4de940f69defc3" => :mojave
    sha256 "351935ab8b6b597a11577e40ee52f29c05b14414549dbd2d60159e950dcfa62e" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on "afflib"
  depends_on :java
  depends_on "libewf"
  depends_on "libpq"
  depends_on "sqlite"

  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV.append_to_cflags "-DNDEBUG"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    cd "bindings/java" do
      system "ant"
    end
    prefix.install "bindings"
  end

  test do
    system "#{bin}/tsk_loaddb", "-V"
  end
end
