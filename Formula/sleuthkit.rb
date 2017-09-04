class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.4.2/sleuthkit-4.4.2.tar.gz"
  sha256 "135964463f4b0a58fcd95fdf731881fcd6f2f227eeb8ffac004880c8e4d8dd53"

  bottle do
    cellar :any
    rebuild 1
    sha256 "abeef5c3610a23f6489da59846bf8a097e2a59cfba84c06d4bce5803e190e5d0" => :sierra
    sha256 "450b2e639678c6b1d00d18f481a81e614e200ee21ccca45aa580a3f8df4d42c1" => :el_capitan
    sha256 "57c5beb1353a7441251aa96c9996afbe91c8710e437375b280e159b43c01c4a9" => :yosemite
  end

  option "with-jni", "Build Sleuthkit with JNI bindings"
  option "with-debug", "Build debug version"

  depends_on "afflib" => :optional
  depends_on "libewf" => :optional

  if build.with? "jni"
    depends_on :java
    depends_on :ant => :build
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
