class Henplus < Formula
  desc "SQL shell that can handle multiple sessions in parallel"
  homepage "https://github.com/neurolabs/henplus"
  url "https://github.com/downloads/neurolabs/henplus/henplus-0.9.8.tar.gz"
  sha256 "ea7ca363d0503317235e97f66aa0efefe44463d8445e88b304ec0ac1748fe1ff"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9430d3d0f01da91504c53f35c37f6856200d333ee865fd3e180e5f7a1196741c" => :high_sierra
    sha256 "d59a56f4eaf9deea38fb6ef7d11c94e626fa46280557e46aad9e41b49f7297b6" => :sierra
    sha256 "79aaf3744f0c3a612ead620d61c9aa2be85e7d97c1a9210410a07b017dcf212e" => :el_capitan
  end

  depends_on "ant" => :build
  depends_on "libreadline-java"
  depends_on :java => "1.8"

  def install
    inreplace "bin/henplus" do |s|
      s.gsub! "LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"
      s.change_make_var! "DYLD_LIBRARY_PATH", Formula["libreadline-java"].opt_lib
      s.gsub! "$THISDIR/..", HOMEBREW_PREFIX
      s.gsub! "share/java/libreadline-java.jar",
              "share/libreadline-java/libreadline-java.jar"
    end

    system "ant", "install", "-Dprefix=#{prefix}"
  end

  def caveats; <<~EOS
    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end

  test do
    system bin/"henplus", "--help"
  end
end
