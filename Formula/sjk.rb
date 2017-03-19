class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://github.com/aragozin/jvm-tools/archive/jvmtool-umbrella-pom-0.5.1.tar.gz"
  sha256 "d6e34a7e9ce8a094bcf8b5ceab092c04a7307a9a4e7eca0005b7d4f70dd98942"

  bottle do
    cellar :any_skip_relocation
    sha256 "48f9877727de2b95ebe5fef9bac072659cf39b0a81d454427befdb7c6844bdb8" => :sierra
    sha256 "e5cd8366335cf07292aa612adfa61741209462e9e117ebf4346725ff591a641a" => :el_capitan
    sha256 "86dd7c006756022163a57dabec4b3b8b50dd59d6368fe1ab4a52aca8187322b4" => :yosemite
  end

  depends_on "maven" => :build
  depends_on :java

  def install
    ENV.java_cache
    system "mvn", "clean", "package"
    cd "sjk-plus/target" do
      libexec.install "sjk-plus-#{version}.jar"
      bin.write_jar_script "#{libexec}/sjk-plus-#{version}.jar", "sjk"
    end
  end

  test do
    system bin/"sjk", "jps"
  end
end
