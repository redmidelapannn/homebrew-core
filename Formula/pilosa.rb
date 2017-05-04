class Pilosa < Formula
  desc "Distributed bitmap index that accelerates queries across data sets."
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/releases/download/v0.3.1/pilosa-v0.3.1-darwin-amd64.tar.gz"
  version "0.3.1"
  sha256 "e462a1ae7c9e215b5c348bfa761ad91e5cd6c647d96e3a1d3a105a4abddbf6bd"

  def install
    bin.install "pilosa"
  end

  test do
    system "#{bin}/pilosa", "--help"
  end
end
