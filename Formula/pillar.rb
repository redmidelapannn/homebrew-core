class Pillar < Formula
  desc "Manage migrations for Cassandra data stores"
  homepage "https://github.com/comeara/pillar"
  url "https://github.com/comeara/pillar/archive/v2.3.0.tar.gz"
  sha256 "f1bb1f2913b10529263b5cf738dd171b14aff70e97a3c9f654c6fb49c91ef16f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "81ee050e0e5435569285b3e78dea96f6cfb5777013f38533ea4338c4f3368001" => :sierra
    sha256 "e72ad6a254adc65ffa106f35418b16e86619ce89883e275c2351855d08617c4b" => :el_capitan
    sha256 "9499a9acf833695ca61c74524f5cd664afcdddcfcea2592913368443cd6383e1" => :yosemite
  end

  depends_on :java
  depends_on "sbt" => :build

  def install
    inreplace "src/main/bash/pillar" do |s|
      s.gsub! "$JAVA ", "`/usr/libexec/java_home`/bin/java "
      s.gsub! "${PILLAR_ROOT}/lib/pillar.jar", "#{libexec}/pillar-assembly-#{version}.jar"
      s.gsub! "${PILLAR_ROOT}/conf", "#{etc}/pillar-log4j.properties"
    end

    system "sbt", "assembly"

    bin.install "src/main/bash/pillar"
    etc.install "src/main/resources/pillar-log4j.properties"
    libexec.install "target/scala-2.10/pillar-assembly-#{version}.jar"
  end

  test do
    assert_match "Missing parameter", shell_output("#{bin}/pillar 2>&1", 1)
  end
end
