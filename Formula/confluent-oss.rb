class ConfluentOss < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-open-source/"
  url "https://packages.confluent.io/archive/4.1/confluent-oss-4.1.0-2.11.tar.gz"
  version "4.1.0"
  sha256 "32c3aff688d6f24e1ea573efdc4e16a3a5f466f1641b770ae4ba0350e7be583a"

  bottle do
    cellar :any_skip_relocation
    sha256 "df6810e081f32667c527fba07da921301fbda0fd83dfcc29aead214b6bcc1890" => :high_sierra
    sha256 "df6810e081f32667c527fba07da921301fbda0fd83dfcc29aead214b6bcc1890" => :sierra
    sha256 "df6810e081f32667c527fba07da921301fbda0fd83dfcc29aead214b6bcc1890" => :el_capitan
  end

  depends_on :java => "1.8"

  conflicts_with "kafka", :because => "kafka also ships with identically named Kafka related executables"

  def install
    prefix.install "bin"
    rm_rf "#{bin}/windows"
    prefix.install "etc"
  end

  test do
    system "#{bin}/confluent", "current"
    assert_match "schema-registry", shell_output("#{bin}/confluent list")
  end
end
