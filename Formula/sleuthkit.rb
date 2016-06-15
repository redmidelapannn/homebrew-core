class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "http://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/archive/sleuthkit-4.2.0.tar.gz"
  sha256 "d71414134c9f8ce8e193150dd478c063173ee7f3b01f8a2a5b18c09aaa956ba7"
  head "https://github.com/sleuthkit/sleuthkit.git", :branch => "develop"

  bottle do
    cellar :any
    revision 1
    sha256 "9c783829d74608141946393d344c65db499f719c2d84e4892046ef571231c45e" => :el_capitan
    sha256 "c89c7d790a5cc5e3a7a108bfda1e17a013759df2c9bee157a6ffc7fe8d16b49a" => :yosemite
    sha256 "fbf2be47b70e7551e3b0bc1a327439847724e6804b604b1567f722f1417e2c16" => :mavericks
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
