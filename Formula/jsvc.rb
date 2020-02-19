class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.cgi?path=commons/daemon/source/commons-daemon-1.2.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.2.2-src.tar.gz"
  sha256 "ebd9d50989ee2009cc83f501e6793ad5978672ecea97be5198135a081a8aac71"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "db96c734d80be9d1822586324ec4f16d5255476001a07a789c7d98bf1baeeda0" => :catalina
    sha256 "4ba0b77fa7e48d0a4b45da0bf19b7f68e7ea1e4b14695d5c80631e4181957e85" => :mojave
    sha256 "58d4784133353a698d652f6847479258ff9b84020c0b3be9e8265f940090039e" => :high_sierra
  end

  depends_on :java

  def install
    ENV.append "CFLAGS", "-arch #{MacOS.preferred_arch}"
    ENV.append "LDFLAGS", "-arch #{MacOS.preferred_arch}"
    ENV.append "CPPFLAGS", "-I/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers"

    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      system "./configure", "--with-java=#{ENV["JAVA_HOME"]}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", Language::Java.java_home_env("1.8+")
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
