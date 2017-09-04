class Gcviewer < Formula
  desc "Java garbage collection visualization tool"
  homepage "https://github.com/chewiebug/GCViewer"
  url "https://github.com/chewiebug/GCViewer/archive/1.34.1.tar.gz"
  sha256 "e0e97a94c80be8323772dc8953d463fe8eaf60c3a1c5f212d0b575a3b5c640ba"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cfce50b632fffb19f1ba88683d9c74c600eed77bb8aff388987bc70625d091aa" => :sierra
    sha256 "50bf4349b92b225bde1bd794e4b069747f2bbcdd747eba79f8b5545605d6d011" => :el_capitan
    sha256 "2710dbdf33c3e36d2ec7d703247910933d94bfebdd8f161b2ac7e7f5ee94408a" => :yosemite
  end

  depends_on :java
  depends_on "maven" => :build

  def install
    system "mvn", "-Dmaven.surefire.debug=-Duser.language=en", "clean", "install"
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"target/gcviewer-1.34.1.jar", "gcviewer"
  end

  test do
    assert(File.exist?(libexec/"target/gcviewer-#{version}.jar"))
  end
end
