class Astartectl < Formula
  desc "Astarte command-line client utility"
  homepage "https://astarte.cloud"
  url "https://github.com/astarte-platform/astartectl/archive/v0.10.2.tar.gz"
  sha256 "18c5a08274350866e814f777384dfabb4000469c29d45a5f7a2bfbea102b82c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ed877d4526f611d453989e42a56fe7b58a5c30517d01c478b7ee476cededff3" => :catalina
    sha256 "28f985759e6650985f57f5a8f549dd96ca2a77629f4722f70a5d7128a32d9b83" => :mojave
    sha256 "79b52c7dfb9f9a6bf53e132105250a94a6704efe1ca86d0e3342dcf1f3d3b691" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build"
    bin.install "astartectl" => "astartectl"
  end

  test do
    system "#{bin}/astartectl", "help"
  end
end
