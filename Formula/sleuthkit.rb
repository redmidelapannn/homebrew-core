class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.4.0/sleuthkit-4.4.0.tar.gz"
  sha256 "7d252562622f657001e080777c5fe1fd919b952fa3d658c86a62e57b6ad70f57"

  bottle do
    cellar :any
    rebuild 1
    sha256 "717ee43b12b06f90119826a5e5e3093a4c005babd541269ee86b2452c818e1bd" => :sierra
    sha256 "22163df1113ac659b9acdfb048c629988d8a68a13d600f60752028ae66a362a5" => :el_capitan
    sha256 "89531721912aa897119eb0c117e95eb463918cced4bced808405221d12e0472d" => :yosemite
  end

  option "with-jni", "Build Sleuthkit with JNI bindings"
  option "with-debug", "Build debug version"

  if build.with? "jni"
    depends_on :java
    depends_on :ant => :build
  end

  depends_on "afflib" => :optional
  depends_on "libewf" => :optional

  conflicts_with "irods", :because => "both install `ils`"
  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV.append_to_cflags "-DNDEBUG" if build.without? "debug"
    ENV.java_cache if build.with? "jni"

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
