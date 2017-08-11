class Up < Formula
  desc "Deploy infinitely scalable serverless apps, apis, and sites in seconds."
  homepage "https://github.com/apex/up"
  url "https://github.com/apex/up/releases/download/v0.1.6/up_0.1.6_darwin_amd64.tar.gz"
  version "0.1.6"
  sha256 "4d421689c7493891c355bd08078020195d35625292e2a18b89cee4d988408669"

  bottle do
    cellar :any_skip_relocation
    sha256 "388736304eb0b1ed0f417ebe5268a9d352f7f16dd67359823d74659cec1c8543" => :sierra
    sha256 "388736304eb0b1ed0f417ebe5268a9d352f7f16dd67359823d74659cec1c8543" => :el_capitan
    sha256 "388736304eb0b1ed0f417ebe5268a9d352f7f16dd67359823d74659cec1c8543" => :yosemite
  end

  def install
    bin.install "up"
  end

  test do
    system "#{bin}/up", "version"
  end
end
