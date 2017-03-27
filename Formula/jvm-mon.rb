class JvmMon < Formula
  desc "Console-based JVM monitoring"
  homepage "https://github.com/ajermakovics/jvm-mon"
  url "https://github.com/ajermakovics/jvm-mon/releases/download/0.3/jvm-mon-0.3.tar.gz"
  sha256 "9b5dd3d280cb52b6e2a9a491451da2ee41c65c770002adadb61b02aa6690c940"

  bottle do
    cellar :any
    sha256 "b2729f3fb6719aaf370ee30df6f7e95fa250c3c9528e3c85a80bc71fb3085fe8" => :sierra
    sha256 "b2729f3fb6719aaf370ee30df6f7e95fa250c3c9528e3c85a80bc71fb3085fe8" => :el_capitan
    sha256 "b2729f3fb6719aaf370ee30df6f7e95fa250c3c9528e3c85a80bc71fb3085fe8" => :yosemite
  end

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/jvm-mon"
    system "unzip", "-j", libexec/"lib/j2v8_macosx_x86_64-4.6.0.jar", "libj2v8_macosx_x86_64.dylib", "-d", libexec
  end

  test do
    system "echo q | #{bin}/jvm-mon"
  end
end
