class ParquetTools < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      :tag => "apache-parquet-1.9.0",
      :revision => "38262e2c80015d0935dad20f8e18f2d6f9fbd03c"
  head "https://github.com/apache/parquet-mr.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c1d81ac9d76135091418a6ba5ec8985507b75a73d281de63febf17f056557545" => :sierra
    sha256 "bc55fd467e44d74a97b47a16fee6cb93c02d42261208d26438a6274588d27ea5" => :el_capitan
    sha256 "79fb80b3a2197e51c8a6f32c1a94d7d008e69c97451c029c00355ba2eb907938" => :yosemite
  end

  depends_on "maven" => :build

  def install
    cd "parquet-tools" do
      system "mvn", "clean", "package", "-Plocal"
      libexec.install "target/parquet-tools-#{version}.jar"
      bin.write_jar_script libexec/"parquet-tools-#{version}.jar", "parquet-tools"
    end
  end

  test do
    system "#{bin}/parquet-tools", "cat", "-h"
  end
end
