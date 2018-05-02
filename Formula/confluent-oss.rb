class ConfluentOss < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-open-source/"
  url "https://packages.confluent.io/archive/4.1/confluent-oss-4.1.0-2.11.tar.gz"
  version "4.1.0"
  sha256 "32c3aff688d6f24e1ea573efdc4e16a3a5f466f1641b770ae4ba0350e7be583a"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b0b4eaec923dcaca03940047061c1a8bfd0b38b25937d1ed4443a1d6939f5cb" => :high_sierra
    sha256 "0b0b4eaec923dcaca03940047061c1a8bfd0b38b25937d1ed4443a1d6939f5cb" => :sierra
    sha256 "0b0b4eaec923dcaca03940047061c1a8bfd0b38b25937d1ed4443a1d6939f5cb" => :el_capitan
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
  end
end
