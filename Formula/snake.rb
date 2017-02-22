class Snake < Formula
  desc "simple snake game. Written in pure java"
  homepage "http://silo.cs.indiana.edu:32903/snake/snakehome.html"
  url "http://silo.cs.indiana.edu:32903/snake/snake.tar.gz"
  version "1.0.0"
  sha256 "c80ef8ce54fa2a4d37de11bd386f04b77ea75b1e012dd3171cec14d86ed26090"
  bottle do
    cellar :any_skip_relocation
    sha256 "f54e465c0d1fca30d3e3c985f14a86613fa7d4f7f3c97c72f003441783593c1e" => :sierra
    sha256 "842941f53bca85ecd106cbc43ffaa25c3a8ff1aafd41ad50a33c9849095d1dc2" => :el_capitan
    sha256 "842941f53bca85ecd106cbc43ffaa25c3a8ff1aafd41ad50a33c9849095d1dc2" => :yosemite
  end

  depends_on "ant" => :build
  depends_on :java
  def install
    system "ant", "compile", "jar"
    mv "snake.jar", "#{prefix}/"
    bin.install "snake"
  end
  test do
    system "java", "-jar", "#{prefix}/snake.jar", "--version"
  end
end
