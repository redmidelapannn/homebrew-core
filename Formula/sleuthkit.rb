class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/archive/sleuthkit-4.3.1.tar.gz"
  sha256 "91a9aa86041f8746038b8e8b0c6e07584971b025a9dd239c6f46d3db52c85d98"
  head "https://github.com/sleuthkit/sleuthkit.git", :branch => "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "86e582ac6f80a66513c87d4882d5fb24fec6f38cb990039429da315f28703742" => :sierra
    sha256 "16e37d6e2036ddfcaed09ba9ec6bb406bbe600ffdca133969c6068d1716219aa" => :el_capitan
    sha256 "00942016f9579af6f879f87d9e5df8ea9cf5402615a6ce37d7eae0f9108739bb" => :yosemite
  end

  conflicts_with "irods", :because => "both install `ils`"

  option "with-jni", "Build Sleuthkit with JNI bindings"
  option "with-debug", "Build debug version"

  if build.with? "jni"
    depends_on :java
    depends_on :ant => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "afflib" => :optional
  depends_on "libewf" => :optional

  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV.append_to_cflags "-DNDEBUG" if build.without? "debug"
    ENV.java_cache if build.with? "jni"

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          if build.without? "jni" then "--disable-java" end,
                          "--prefix=#{prefix}"
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
