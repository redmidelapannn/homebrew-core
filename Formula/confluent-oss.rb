class ConfluentOss < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-open-source/"
  url "https://packages.confluent.io/archive/4.1/confluent-oss-4.1.1-2.11.tar.gz"
  version "4.1.1"
  sha256 "e00eb4c6c7445ad7a43c9cd237778d1cd184322aebf5ff64a8e9806ba2cc27aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "987ea69030dce21013523d73cfecda2ebb7b1a5a2f57f4973c89e3b1fd9ced4b" => :high_sierra
    sha256 "987ea69030dce21013523d73cfecda2ebb7b1a5a2f57f4973c89e3b1fd9ced4b" => :sierra
    sha256 "987ea69030dce21013523d73cfecda2ebb7b1a5a2f57f4973c89e3b1fd9ced4b" => :el_capitan
  end

  depends_on :java => "1.8"

  conflicts_with "kafka", :because => "kafka also ships with identically named Kafka related executables"

  def install
    prefix.install "bin"
    rm_rf "#{bin}/windows"
    prefix.install "etc"
    prefix.install "share"
  end

  test do
    system "#{bin}/confluent", "current"
    assert_match "schema-registry", shell_output("#{bin}/confluent list")
  end
end
