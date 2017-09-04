class Bdsup2sub < Formula
  desc "Convert and tweak bitmap based subtitle streams"
  homepage "https://github.com/mjuhasz/BDSup2Sub"
  url "https://github.com/mjuhasz/BDSup2Sub/archive/5.1.2.tar.gz"
  sha256 "9441f1f842547a008c1878711cdc62c6656c0efea88e29bdfa6f21ac24ba87cd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9232142f8615f8755356f1a006d7b206ded6ac8d70d4de53d9e4b81985abe671" => :sierra
    sha256 "a0b75dbd6dac5e243db26dbf98f4da326574a73a2d3f5e8b2147bb04d5ed7bcb" => :el_capitan
    sha256 "9aff52cd45aaa64dcf70fb2ebd4565eea76700844cae4255158a0280ce18907b" => :yosemite
  end

  depends_on "maven" => :build
  depends_on :java

  def install
    system "mvn", "clean", "package", "-DskipTests"
    libexec.install "target/BDSup2Sub-#{version}-jar-with-dependencies.jar"
    bin.write_jar_script(libexec/"BDSup2Sub-#{version}-jar-with-dependencies.jar", "BDSup2Sub")
  end

  test do
    assert_match(/^BDSup2Sub #{version}$/, shell_output("#{bin}/BDSup2Sub -V"))
  end
end
