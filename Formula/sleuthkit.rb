class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.6.1/sleuthkit-4.6.1.tar.gz"
  sha256 "1f68f3b5983acdb871a30592fb735a32f4db93f041fcf318bcf3ec87128ab433"
  revision 1

  bottle do
    cellar :any
    sha256 "f1e2857edb10e8db1275f08637e3c8418576bf5666679a154cf2f5db1bf1b853" => :high_sierra
    sha256 "47ee7371c6dd58154c13579d2aa4a2a354fdf16135ffaf3224fef699268dd229" => :sierra
    sha256 "97ba29414ad06044995be0c3eccc3d3ef6a12ff6c0838ac7cfb0913127c6b17c" => :el_capitan
  end

  option "with-jni", "Build Sleuthkit with JNI bindings"

  depends_on "afflib"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "sqlite"

  if build.with? "jni"
    depends_on :java
    depends_on "ant" => :build
  end

  conflicts_with "irods", :because => "both install `ils`"
  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--disable-java" if build.without? "jni"

    system "./configure", *args
    system "make"
    system "make", "install"

    if build.with? "jni"
      cd "bindings/java" do
        system "ant"
      end
      prefix.install "bindings"
    end
  end

  test do
    system "#{bin}/tsk_loaddb", "-V"
  end
end
