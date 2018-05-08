class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.6.1/sleuthkit-4.6.1.tar.gz"
  sha256 "1f68f3b5983acdb871a30592fb735a32f4db93f041fcf318bcf3ec87128ab433"
  revision 1

  bottle do
    cellar :any
    sha256 "1e38d11563ae91226ac4f90c8225a5a4a483c58a4526db69794bfcb40c5bb116" => :high_sierra
    sha256 "70c430d1eca19d127670e40a3d0a663e23f5414fcec6e7df7a2ae58a28665a91" => :sierra
    sha256 "87120b753ce53c4224e94320c7ca935bfb034ce91572ee30854af3accb590e89" => :el_capitan
  end

  option "with-jni", "Build Sleuthkit with JNI bindings"
  option "with-debug", "Build debug version"

  depends_on "afflib" => :optional
  depends_on "libewf" => :optional
  depends_on "postgresql" => :optional

  if build.with? "jni"
    depends_on :java
    depends_on "ant" => :build
  end

  conflicts_with "irods", :because => "both install `ils`"
  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV.append_to_cflags "-DNDEBUG" if build.without? "debug"

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
